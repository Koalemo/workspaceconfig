-- This file can be loaded by calling `lua require('plugins')` from your init.vim
---
-- Only required if you have packer configured as `opt`
--vim.cmd.packadd('packer.nvim')

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Theme
    -- use {
    --     'nvim-telescope/telescope.nvim', tag = '0.1.8',
    --     -- or                            , branch = '0.1.x',
    --     requires = { { 'nvim-lua/plenary.nvim' },
    --                 {"nvim-treesitter/nvim-treesitter"}}
    -- }

    -- use('nvim-treesitter/playground')
    --use('theprimeagen/harpoon')
    -- use('mbbill/undotree')


    -- gutentags is experimentally replaced by treesitter-textobjects
    --
    -- use 'ludovicchabant/vim-gutentags'
    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      after = "nvim-treesitter",
      requires = "nvim-treesitter/nvim-treesitter",
    })

    use('simnalamburt/vim-mundo')

    use('tpope/vim-fugitive')
    use('airblade/vim-gitgutter')
    -- Fancier statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'tpope/vim-sleuth'

    -- Autocompletion (Conquer of Completion) + veridian.
    -- NEEDS MORE WORK to make it work
    -- use {'neoclide/coc.nvim', branch='master', run= 'npm ci'}

    use 'nvim-tree/nvim-web-devicons'
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    -- use {
        -- "danymat/neogen",
        -- config = function()
            -- require('neogen').setup {}
        -- end,
        -- requires = "nvim-treesitter/nvim-treesitter",
        -- Uncomment next line if you want to follow only stable versions
        -- tag = "*"
    -- }
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    })
    use "cloudhead/neovim-fuzzy"
    use 'voldikss/vim-floaterm'
    use 'kaicataldo/material.vim'

    use "tpope/vim-abolish"
    use "tpope/vim-eunuch"
    use "tpope/vim-vinegar"

    use "jremmen/vim-ripgrep"
    use "stefandtw/quickfix-reflector.vim"

    use 'qxxxb/vim-searchhi'
    use 'kshenoy/vim-signature'

    use 'godlygeek/tabular'

    use 'noib3/nvim-cokeline'

    use 'tpope/vim-obsession'

    -- disable temporarily
    -- use 'dense-analysis/ale'

    -- This  is dangerous though: It opens a new buffer with the original contents. Do not close the wrong one or you might lose data. Better not use it.
    --use 'JBarberU/vim-diffsaved'

    use 'akinsho/bufferline.nvim'


    use 'rafi/awesome-vim-colorschemes'

    -- for easy split resizing
    -- see https://vim.fandom.com/wiki/Resize_splits_more_quickly#:~:text=To%20resize%20all%20windows%20to,%2C%20use%20Ctrl%2Dw%20%7C%20.
    -- TODO: Make this work.
    -- use 'kana/vim-submode'

    use { 'xolox/vim-colorscheme-switcher',
        requires = "xolox/vim-misc"
    }

    use 'averms/black-nvim'

    use 'JBarberU/vim-diffsaved'

    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    use 'tpope/vim-markdown'

    use ({
        '2kabhishek/nerdy.nvim',
        requires = {
            'folke/snacks.nvim',
        },
        cmd = 'Nerdy',
    })
        ---opts = {
            ---max_recents = 30, -- Configure recent icons limit
            ---add_default_keybindings = true, -- Add default keybindings
            ---copy_to_clipboard = false, -- Copy glyph to clipboard instead of inserting
            ---copy_register = '+', -- Register to use for copying (if `copy_to_clipboard` is true)
        ---}
    ---}

    if packer_bootstrap then
        require('packer').sync()
    end

end)
