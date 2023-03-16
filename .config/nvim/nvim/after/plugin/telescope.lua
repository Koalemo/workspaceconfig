require('telescope').setup({
    pickers = {
        find_files = {
            theme = 'ivy',
        },
    },
    defaults = {
        layout_strategy='horizontal',
        layout_config={
            height = 0.3
        },
        anchor="S"
    },
})


local builtin = require('telescope.builtin')
--vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
vim.keymap.set('n', '<leader>fo', builtin.find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>bb', builtin.buffers, {})
