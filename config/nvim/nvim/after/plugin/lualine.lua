require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'codedark',
    component_separators = '|',
    section_separators = '',
  },
   sections = {
    lualine_a = {'mode'},
    lualine_b = {'filename'},
    lualine_c = {'encoding',  'filetype'},
    lualine_x = {'branch', 'diff', 'diagnostics'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
}
