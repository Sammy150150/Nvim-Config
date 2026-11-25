-- Autocomplete and snippets.
--
-- Both load on `InsertEnter`: you never pay for them while merely reading or
-- navigating, only the first time you start typing in a session.

return {
  ---------------------------------------------------------------------------
  -- Snippet engine
  ---------------------------------------------------------------------------

  {
    'L3MON4D3/LuaSnip',
    version = '2.*',
    event = 'InsertEnter',
    -- NOTE: You can also specify a version range for its git tag in the spec.
    --  See `:help vim.version.range()` for more info
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip').setup {}

      -- `friendly-snippets` contains a variety of premade snippets.
      --    See the README for individual language/plugin snippets:
      --    https://github.com/rafamadriz/friendly-snippets
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },

  ---------------------------------------------------------------------------
  -- Completion engine
  ---------------------------------------------------------------------------

  {
    'saghen/blink.cmp',
    version = '1.*',
    event = 'InsertEnter',
    dependencies = { 'L3MON4D3/LuaSnip' },
    config = function()
      require('blink.cmp').setup {
        keymap = {
          -- 'default' (recommended) for mappings similar to built-in completions
          --   <c-y> to accept ([y]es) the completion.
          --    This will auto-import if your LSP supports it.
          --    This will expand snippets if the LSP sent a snippet.
          -- 'super-tab' for tab to accept
          -- 'enter' for enter to accept
          -- 'none' for no mappings
          --
          -- For an understanding of why the 'default' preset is recommended,
          -- you will need to read `:help ins-completion`
          --
          -- No, but seriously. Please read `:help ins-completion`, it is really good!
          --
          -- All presets have the following mappings:
          -- <tab>/<s-tab>: move to right/left of your snippet expansion
          -- <c-space>: Open menu or open docs if already open
          -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
          -- <c-e>: Hide menu
          -- <c-k>: Toggle signature help
          --
          -- See `:help blink-cmp-config-keymap` for defining your own keymap
          preset = 'default',

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono',
        },

        completion = {
          -- By default, you may press `<c-space>` to show the documentation.
          -- Optionally, set `auto_show = true` to show the documentation after a delay.
          documentation = { auto_show = false, auto_show_delay_ms = 500 },
        },

        sources = {
          default = { 'lsp', 'path', 'snippets' },
        },

        snippets = { preset = 'luasnip' },

        -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
        -- which automatically downloads a prebuilt binary when enabled.
        --
        -- We use `'prefer_rust_with_warning'`: the rust implementation is used
        -- when available, falling back to the Lua implementation otherwise
        -- (a warning is shown if the binary could not be downloaded).
        --
        -- See `:help blink-cmp-config-fuzzy` for more information
        fuzzy = { implementation = 'prefer_rust_with_warning' },

        -- Shows a signature help window while you type arguments for a function
        signature = { enabled = true },
      }
    end,
  },
}
