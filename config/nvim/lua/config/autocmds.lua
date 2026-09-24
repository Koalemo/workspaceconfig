-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd('filetype', {
  pattern = 'netrw',
  desc = 'Better mappings for netrw',
  callback = function()
    local bind = function(lhs, rhs)
      vim.keymap.set('n', lhs, rhs, {remap = true, buffer = true})
    end

    -- edit new file
    bind('o', '<cr>')

  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'rust', 'lua' },
  callback = function()
    vim.treesitter.start()                            -- Highlighting
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Folding
    -- vim.wo.foldmethod = 'expr'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- Indentation
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'systemverilog', 'verilog' },
  callback = function()
    vim.treesitter.start()                            -- Highlighting
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Folding
    vim.wo.foldmethod = 'expr'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- Indentation
  end,
})

-- trim trailing whitespaces
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
