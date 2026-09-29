return {
  "mfussenegger/nvim-lint",
  config = function()

    local sarif_parser = require('lint.parser').for_sarif({ source = 'verilator' })
    local parser = require('lint.parser')

    -- Fallback: parse raw verilator output, e.g.
    --   %Error: rtl/foo.sv:12:9: syntax error, unexpected ...
    --   %Warning-WIDTH: rtl/foo.sv:20:5: Operator ADD expects ...
    local function verilator_parser(output, bufnr, cwd)
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return {}
      end
      local buffer_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p')

      -- verilator's relative paths are relative to the build dir, not cwd
      local build_dir = output:match("Entering directory '(.-)'") or cwd

      local sev_map = {
        Error   = vim.diagnostic.severity.ERROR,
        Warning = vim.diagnostic.severity.WARN,
        Info    = vim.diagnostic.severity.INFO,
      }

      local diagnostics = {}
      for line in vim.gsplit(output, '\n', true) do
        -- %Error: file:lnum:col: msg   /   %Warning-CODE: file:lnum:col: msg
        -- (leading "ERROR: " prefixes from fusesoc are fine, match isn't anchored)
        local sev, code, file, lnum, col, msg =
        line:match('%%(%a+)%-?(%w*):%s*([^:]+):(%d+):(%d+):%s*(.+)')

        if sev and file then
          -- fnamemodify ':p' resolves ../ segments against build_dir
          local path = vim.fn.fnamemodify(build_dir .. '/' .. file, ':p')
          if vim.fs.normalize(path) == vim.fs.normalize(buffer_path) then
            table.insert(diagnostics, {
              lnum = math.max(tonumber(lnum) - 1, 0),
              col  = math.max(tonumber(col) - 1, 0),
              severity = sev_map[sev] or vim.diagnostic.severity.ERROR,
              message = msg,
              code = code ~= '' and code or nil,
              source = 'verilator',
            })
          end
        else
          -- position-less lines, e.g. "%Error: Verilator internal fault, ..."
          local sev2, msg2 = line:match('%%(%a+)%-?%w*:%s*(.+)')
          if sev2 and not msg2:match('^%S+:%d+:%d+:') then
            table.insert(diagnostics, {
              lnum = 0, col = 0,
              severity = sev_map[sev2] or vim.diagnostic.severity.ERROR,
              message = msg2,
              source = 'verilator',
            })
          end
        end
      end
      return diagnostics
    end

    require('lint').linters.fusesoc_verilator = {
      name = 'fusesoc_linter',
      cmd = 'fusesoc',
      args = { 'run',  '--no-export',  '--target=lint', '--setup', '--build',
        function()
          return  vim.g.fusesoc_target
        end,}, -- or whatever build/lint target
      stdin = false,
      append_fname = false,
      stream = 'both',
      ignore_exitcode = true, -- fusesoc/verilator likely exit non-zero on lint errors

      parser = function(output, bufnr, cwd)
        vim.notify(output) -- print output to notification

        local dir = output:match("Entering directory '(.-)'")

        if dir then
          local sarif_path = vim.fn.glob(dir .. '/*.sarif')
          if vim.fn.filereadable(sarif_path) == 1 then
            local sarif_content = table.concat(vim.fn.readfile(sarif_path), '\n')
            return sarif_parser(sarif_content, bufnr, cwd)
          end
        end
        -- fallback: no sarif -> parse verilator's own output
        return verilator_parser(output, bufnr, cwd)

      end,
    }

    require('lint').linters_by_ft.verilog = { 'fusesoc_verilator' }
    require('lint').linters_by_ft.systemverilog = { 'fusesoc_verilator' }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()

        -- try_lint without arguments runs the linters defined in `linters_by_ft`
        -- for the current filetype
        require("lint").try_lint()
      end,
    })
  end

}

