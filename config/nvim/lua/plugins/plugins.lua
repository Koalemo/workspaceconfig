-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {

  -- {
  --   "nvim-treesitter/nvim-treesitter-textobjects", version = 'main',
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  -- },


  -- GitCommands
  {
    'tpope/vim-fugitive'
  },

  -- git tools:show change symbols
  {
    'airblade/vim-gitgutter',
  },

  -- quick grep to quicklist
  {"jremmen/vim-ripgrep"},

  -- Netrw bindings
  {"tpope/vim-vinegar"},


  {'simnalamburt/vim-mundo',
    lazy = false
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ':TSUpdate',
    lazy = false,
    opts = {
      ensure_installed = {
        "c++",
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "systemverilog",
        "verilog",
      },
    }
  },

  -- surrounmd
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  -- nerdfonts
  {
    '2kabhishek/nerdy.nvim',
    dependencies = {
      'folke/snacks.nvim',
    },
    cmd = 'Nerdy',
    opts = {
      max_recents = 30, -- Configure recent icons limit
      add_default_keybindings = true, -- Add default keybindings
      copy_to_clipboard = false, -- Copy glyph to clipboard instead of inserting
      copy_register = '+', -- Register to use for copying (if `copy_to_clipboard` is true)
    }
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

}
