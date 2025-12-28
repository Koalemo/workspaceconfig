return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'kyazdani42/nvim-web-devicons', opt = true },
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          icons_enabled = false,
          theme = 'codedark',
          component_separators = '|',
          section_separators = '',
        },
         sections = {
          lualine_a = {'mode'},
          lualine_b = {{'filename', path=1}},
          lualine_c = {'encoding',  'filetype'},
          lualine_x = {'branch', 'diff', 'diagnostics'},
          lualine_y = {'progress'},
          lualine_z = {'location'},
        },
      }
    end,
  },
}
