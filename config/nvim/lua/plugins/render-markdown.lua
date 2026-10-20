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
            render_modes = true,                      -- keep rendering in insert mode. no distracting highlight change.
            icons = function(ctx)                     -- default: nerd-font glyphs
                return string.rep('#', ctx.level) .. ' '
            end,
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
            render_modes = true,                      -- keep borders in insert mode (no visual jump)
            wrap = true,                              -- not in documented defaults
        },

        anti_conceal = {
            disabled_modes = { 'n' },  -- no hover-reveal in normal mode
        },

        indent = {
            enabled = true,                           -- default: false
            render_modes = true,                      -- default: false
            skip_heading = true,                      -- default: false
        },
    }
  }
}
