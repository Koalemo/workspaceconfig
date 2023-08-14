-- align signal declarations
vim.keymap.set("n", "<Leader>l", ":Tabularize /[^\\ )]\\+;$<cr>")
vim.keymap.set("n", "<Leader>;", ":Tabularize /[^\\ )]\\+,$<cr>")
-- nmap <Leader>; :Tabularize /[^\ )]\                           +,$<cr>

-- align (/l0r0
vim.keymap.set("n", "<Leader>9", ":Tabularize /(/l0r0<cr>")

-- remove spaces within []
vim.keymap.set("v","<Leader>o", ":s/\\[[^\\]]*\\]/\\=substitute(submatch(0), ' ', '', 'g')/g<cr>")
vim.keymap.set("n", "<Leader>p", ":Tabularize /(?<=])/r0<cr>")

-- Tabularize assignment
vim.keymap.set("n", "<Leader>i", ":Tabularize /=<cr>")
vim.keymap.set("n", "<Leader>u", ":Tabularize /<=<cr>")
