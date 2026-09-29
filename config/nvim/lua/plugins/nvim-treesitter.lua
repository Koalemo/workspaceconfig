return{
  {
    "nvim-treesitter/nvim-treesitter",
    build = ':TSUpdate',
    lazy = false,
    config = function()
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath('data') .. '/site'
      }
      require('nvim-treesitter').install {
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
      }
    end,
  },
}
