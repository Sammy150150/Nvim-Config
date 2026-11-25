-- Language servers enabled by this configuration.
--
-- Shared between `init.lua` (which registers and enables them through
-- `vim.lsp.config()` / `vim.lsp.enable()`) and `lua/plugins/lsp.lua`, where
-- mason-tool-installer uses the keys of this table as `ensure_installed`.
--
-- See `:help lsp-config` for the supported keys.

---@type table<string, vim.lsp.Config>
return {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- tsc = {},
  --
  -- Some languages (like rust) have entire language plugins that can be useful:
  --    https://github.com/mrcjkb/rustaceanvim
  --
  -- But for many setups, the LSP (`rust_analyzer`) will work just fine
  -- rust_analyzer = {},

  -- Emmet completions for HTML/CSS/JSX/TSX/Vue/Svelte etc.
  -- (The `emmet-language-server` binary is installed by mason; the
  --  default filetype list from nvim-lspconfig is used.)
  emmet_language_server = {},

  stylua = {}, -- Used to format Lua code

  -- Special Lua Config, as recommended by neovim help docs
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
      client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
          --  See https://github.com/neovim/nvim-lspconfig/issues/3189
          library = vim.api.nvim_get_runtime_file('', true),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false }, -- Disable formatting (formatting is done by stylua)
      },
    },
  },
}
