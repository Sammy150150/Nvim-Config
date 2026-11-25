-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Plugin specs live in `lua/plugins/*.lua`, one file per area:
--   ui.lua          guess-indent, gitsigns, which-key, tokyonight,
--                   todo-comments, mini.nvim, live-preview, emmet
--   telescope.lua   fuzzy finder (+ its LSP pickers)
--   lsp.lua         fidget, mason, mason-lspconfig, mason-tool-installer
--   formatting.lua  conform.nvim
--   completion.lua  LuaSnip and blink.cmp
--   treesitter.lua  nvim-treesitter and parser auto-install
--
-- Each file declares its own lazy-loading triggers, so most plugins are only
-- loaded on first use. Global options, LSP wiring and non-plugin keymaps stay
-- in `init.lua`.
require('lazy').setup {
  spec = {
    { import = 'plugins' },

    -- Optional kickstart example plugins - uncomment to enable them:
    -- { import = 'kickstart.plugins.autopairs' },
    -- { import = 'kickstart.plugins.debug' },
    -- { import = 'kickstart.plugins.indent_line' },
    -- { import = 'kickstart.plugins.lint' },
    -- { import = 'kickstart.plugins.neo-tree' },
  },
  -- Colorscheme used while plugins are being installed.
  install = { colorscheme = { 'habamax' } },
  -- Automatic update checks spawn one `git fetch` per plugin shortly after
  -- startup (~100 ms each on Windows), which competes with your first
  -- keystrokes. Update deliberately instead with `:Lazy update`.
  checker = { enabled = false },
}
