vim.lsp.config['svls'] = {
  cmd = { 'svls', '-d' },
  filetypes = { 'verilog', 'systemverilog' },
}

vim.lsp.enable('svls')

--  Enable diagnostic messages
vim.diagnostic.enable = true
vim.diagnostic.config({
  virtual_lines = true,
})
