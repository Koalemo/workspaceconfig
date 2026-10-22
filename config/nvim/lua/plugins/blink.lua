return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = 'default',

      ['<C-r>'] = {
        function(cmp)
          vim.schedule(function()
            require('blink.cmp.completion.trigger').hide()
            cmp.show()
          end)
          return true
        end,
      },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      menu = {
        -- Delay before showing the completion menu while typing
        -- auto_show_delay_ms = 500,

        -- never auto-open; press <C-space> to show
        auto_show = false,
      },
      documentation = { auto_show = false },

      -- Warm the cache the moment you enter insert mode
      trigger = { prefetch_on_insert = true }
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      -- optional: tune per-filetype for verilog/systemverilog
      -- per_filetype = {
        -- systemverilog = { 'lsp', 'buffer' },
        -- verilog = { 'lsp', 'buffer' },
      -- },
      providers = {
        lsp = {
          -- SV LSPs can be slow on large designs; don't block the menu
          async = true,
          timeout_ms = 2000,
          fallbacks = { 'buffer' },
        },
      },
    },


    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      -- sorts = { 'sort_text', 'score', 'label' },  -- respect server sortText first
    },

    -- Experimental signature help support
    signature = { enabled = true },
  },
  opts_extend = { "sources.default" }
}
