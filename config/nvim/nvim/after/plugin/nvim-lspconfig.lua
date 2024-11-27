require'lspconfig'.svls.setup{
  cmd = { 'svls', '-d' },
  filetypes = { 'verilog', 'systemverilog' },
}


-- require'lspconfig'.svlangserver.setup{}
