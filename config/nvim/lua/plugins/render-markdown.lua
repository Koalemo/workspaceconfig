return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { "markdown", "Avante" },
    opts = {
        file_types = { "markdown", "Avante" },        -- default: { 'markdown' }
        completions = { lsp = { enabled = true } },   -- default: false

        win_options = {
            conceallevel = { rendered = 0 },          -- default: 3
        },

        heading = {
            icons = { '# ', '# ', '# ', '# ', '# ', '# ' }, -- default: nerd-font glyphs
            border = true,                            -- default: false
            border_prefix = true,                     -- default: false
            above = '-',                              -- default: '▄'
            below = '-',                              -- default: '▀'
        },

        code = {
            width = 'block',                          -- default: 'full'
            border = 'none',                          -- default: 'hide'
        },

        pipe_table = {
            wrap = true,                              -- not in documented defaults
        },

        indent = {
            enabled = true,                           -- default: false
            render_modes = true,                      -- default: false
            skip_heading = true,                      -- default: false
        },
    }
  }
}
