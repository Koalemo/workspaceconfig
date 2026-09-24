return {
  "mfussenegger/nvim-lint",
  config = function()

    local sarif_parser = require('lint.parser').for_sarif({ source = 'verilator' })  

    require('lint').linters.fusesoc_verilator = {  
      cmd = 'fusesoc',  
      args = { 'run',  '--no-export',  '--target=lint', '--setup', '--build',  'ganoam:util:stream_reg:0' }, -- or whatever build/lint target  
      stdin = false,  
      append_fname = false,
      stream = 'both',
      ignore_exitcode = true, -- fusesoc/verilator likely exit non-zero on lint errors  

      parser = function(output, bufnr, cwd)  
        local dir = output:match("Entering directory '(.-)'")  
        if not dir then  
          return {}  
        end  
        local sarif_path = vim.fn.glob(dir .. '/*.sarif')
        if vim.fn.filereadable(sarif_path) == 0 then  
          return {}  
        end  
        local sarif_content = table.concat(vim.fn.readfile(sarif_path), '\n')  
        vim.notify(output) -- print output to notification
        return sarif_parser(sarif_content, bufnr, cwd)  
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

