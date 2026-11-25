-- LSP support: progress UI and the Mason tool manager.
--
-- `nvim-lspconfig` stays eager because `init.lua` registers every server from
-- `lua/config/servers.lua` with `vim.lsp.config()` / `vim.lsp.enable()` during
-- startup (it is cheap, ~3 ms). Everything else loads on demand.

return {
  -- Progress window for LSP messages ("indexing", "loading", ...).
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    config = function() require('fidget').setup {} end,
  },

  -- Installs language servers and formatters into `stdpath('data')/mason`.
  -- Kept eager: `mason.setup()` is what puts `mason/bin` on PATH, and that must
  -- happen before the first file is opened or no language server can start.
  {
    'mason-org/mason.nvim',
    lazy = false,
    config = function() require('mason').setup {} end,
  },

  -- Translates between nvim-lspconfig server names and mason package names
  -- (e.g. lua_ls <-> lua-language-server).
  {
    'mason-org/mason-lspconfig.nvim',
    lazy = false,
    dependencies = { 'mason-org/mason.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      require('mason-lspconfig').setup {
        automatic_enable = false, -- Change this to true if you want to automatically enable servers that are installed manually (e.g. via :Mason / :MasonInstall)
      }
    end,
  },

  -- Installs the servers declared in `lua/config/servers.lua`, plus any extra
  -- tools listed below. Runs right after startup so missing tools still get
  -- installed without delaying the UI.
  --
  -- To check the current status of installed tools and/or manually install
  -- other tools, run `:Mason` (`g?` shows the help for that menu).
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    event = 'VeryLazy',
    dependencies = { 'mason-org/mason.nvim' },
    config = function()
      local ensure_installed = vim.tbl_keys(require 'config.servers')
      vim.list_extend(ensure_installed, {
        -- You can add other tools here that you want Mason to install
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    end,
  },

  -- Required by the `vim.lsp.config()` calls in init.lua. Eager on purpose.
  { 'neovim/nvim-lspconfig' },
}
