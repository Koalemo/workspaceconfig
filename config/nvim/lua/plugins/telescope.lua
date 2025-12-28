return {
  {
   'nvim-telescope/telescope.nvim', version = '0.2.0',
   dependencies = { { 'nvim-lua/plenary.nvim' }, {"nvim-treesitter/nvim-treesitter"}},
    opts = {
         pickers = {
             find_files = {
                 theme = 'ivy',
             },
             git_files= {
                 theme = 'ivy',
             },
         },
         defaults = {
             layout_strategy='horizontal',
             layout_config={
                 height = 0.3,
             },
             anchor="S",
         },
    },
    keys = {
      {"<leader>ff", function() require("telescope.builtin").git_files() end, desc = "Find Files" },
      {"<leader>fo", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
      {"<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Find current word" },
      {"<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Find by grep" },
      {"<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Find diagnostics" },
      {"<leader>bb", function() require("telescope.builtin").buffers() end, desc = "Find buffer" },
    },
  },
}

