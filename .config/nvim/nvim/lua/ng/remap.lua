vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever TODO (ng): Whut?
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland TODO (ng): Whut?
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Use lsp to format
vim.keymap.set("n", "<leader>fmt", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Change directory
vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>')

-- Buffer close
vim.keymap.set('n', '<leader>bc', ':bdelete<cr>')
vim.keymap.set('n', '<leader>bd', ':bdelete!<cr>')

-- insert a new line without leaving normal moede (almost)
vim.keymap.set('n', '<leader>o', 'o<ESC>k')
vim.keymap.set('n', '<leader>O', 'O<ESC>j')

-- Split resizing
vim.keymap.set('n',  '<C-l>', '<C-W>>')
vim.keymap.set('n',  '<C-h>', '<C-W><')
vim.keymap.set('n',  '<C-n>', '<C-W>+')
vim.keymap.set('n',  '<C-i>', '<C-W>-')
