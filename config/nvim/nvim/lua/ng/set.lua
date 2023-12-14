vim.opt.termguicolors = true
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true


vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"
vim.opt.clipboard = "unnamedplus"

vim.g.netrw_altfile = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 1

vim.opt.showtabline=2

vim.opt.wrap = true

-- Don't lose selection when shifting sideways
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

vim.cmd "colorscheme spacecamp"
