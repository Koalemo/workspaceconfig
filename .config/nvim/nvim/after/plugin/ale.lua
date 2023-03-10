vim.g.ale_verilog_vlog_options ='-work work -quiet -lint "+incdir+/home/ng/code/exp-compute/DEPS"'

-- let g:ale_linters = { 'systemverilog': ['verible', 'verilator', 'vlog']}
-- let g:ale_linters = { 'verilog': ['verible', 'verilator']}


vim.g.ale_verilog_verilator_options="-I'/home/ng/code/exp-compute/DEPS'"
-- let g:ale_verilog_vlog_options = '-quiet -lint "+incdir+include" -suppress 2583 -svinputport=compat'
-- let g:ale_verilog_xvlog_options = '-sv --include vta/hw/dta/sim2 --incr'


--  Add ALELint toggle
vim.keymap.set("n", "<Leader>at", ":ALEToggle<CR>")

vim.keymap.set("n","[e", "<Plug>(ale_previous_wrap)")
vim.keymap.set("n","]e", "<Plug>(ale_next_wrap)")


--  disable  verilator lint
-- map <Leader>ave :let g:ale_linters = { 'systemverilog': ['vlog', 'verible', 'verilator']} <cr>
-- map <Leader>avd :let g:ale_linters = { 'systemverilog': ['vlog','verible']} <cr>

vim.cmd("au FileType systemverilog let g:ale_linters = {'systemverilog' : ['vlog' ]}")
vim.cmd("au FileType verilog let g:ale_linters = {'verilog' : ['vlog']}")


vim.cmd("set errorformat=\\*\\*\\ %tRROR:\\ \\(vlog-%n\\)\\ %f(%l):\\ %m \
set errorformat+=\\*\\*\\ %trror:\\ \\(vlog-%n\\)\\ \\*\\*\\ %m\\ at\\ %f(%l) \
set errorformat+=\\*\\*\\ at\\ %f(%l):\\ %m \
set errorformat+=\\*\\*\\ %trror:\\ \\(vsim-%n\\)\\ %f\\(%l\\):\\ %m \
set errorformat+=\\*\\*\\ %tRROR:\\ %f(%l):\\ \\(vlog-%n\\)\\ %m \
set errorformat+=\\*\\*\\ %tRROR:\\ %f(%l):\\ %m \
set errorformat+=\\*\\*\\ %trror\\ \\(suppressible\\):\\ %f(%l):\\ \\(vlog-%n\\)\\ %m \
set errorformat+=\\*\\*\\ %tarning:\\ %f(%l):\\ \\(vlog-%n\\)\\ %m \
set errorformat+=\\*\\*\\ %tarning:\\ \\(vlog-%n\\)\\ %m\\ \\'%f\\'. \
set errorformat+=\\#\\ \\ \\ Time:\\ %m\\ File:\\ %f\\ Line:\\ %l \
set errorformat+=\\*\\*\\ %tRROR\\ \\(suppressible\\):\\ %f(%l):\\ \\(vopt-%n\\)\\ %m \
set errorformat+=\\*\\*\\ %tRROR\\ \\(suppressible\\):\\ \\(vopt-%n\\)\\ %f(%l):\\ %m \
set errorformat+=%f\\(%l\\):\\ (vopt-%n)\\ %m \
set errorformat+=\\#\\ \\*\\*\\ %trror:\\ T=%.%#\\ %f\\(%l\\):\\ %m \
set errorformat+=\\#\\ Fatal\\ error\\ at\\ %f\\ line\\ %l")
