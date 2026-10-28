-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- telescope-fzf-native compiles a C extension with `make`, so it is
-- only included when `make` is available on this system; otherwise
-- telescope falls back to its built-in sorter.
local telescope = {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-telescope/telescope-ui-select.nvim",
  },
}
if vim.fn.executable("make") == 1 then
  telescope.dependencies[#telescope.dependencies + 1] = { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
end

-- The single source of truth for all plugins in this configuration.
-- Plugin configuration (`.setup()` calls) lives in init.lua.
local spec = {
  -- import your plugins from lua/plugins/*.lua
  { import = "plugins" },

  -- Optional kickstart example plugins - uncomment to enable them:
  -- { import = "kickstart.plugins.autopairs" },
  -- { import = "kickstart.plugins.debug" },
  -- { import = "kickstart.plugins.indent_line" },
  -- { import = "kickstart.plugins.lint" },
  -- { import = "kickstart.plugins.neo-tree" },

  -- [[ Core UX / UI ]]
  "NMAC427/guess-indent.nvim",
  "lewis6991/gitsigns.nvim",
  "folke/which-key.nvim",
  "folke/tokyonight.nvim",
  "folke/todo-comments.nvim",
  "nvim-mini/mini.nvim",

  -- [[ Fuzzy finder ]]
  "nvim-lua/plenary.nvim",
  telescope,

  -- [[ LSP ]]
  "j-hui/fidget.nvim",
  "neovim/nvim-lspconfig",
  "mason-org/mason.nvim",
  "mason-org/mason-lspconfig.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",

  -- [[ Formatting ]]
  "stevearc/conform.nvim",

  -- [[ Snippets & autocompletion ]]
  { "L3MON4D3/LuaSnip", version = "2.*", dependencies = { "rafamadriz/friendly-snippets" } },
  { "saghen/blink.cmp", version = "1.*" },

  -- [[ Treesitter ]]
  -- `build = ':TSUpdate'` compiles the parsers after install/update.
  { "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate" },

  -- [[ Misc ]]
  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
    end,
  },
  {
    "brianhuster/live-preview.nvim",
    dependencies = {
      -- You can choose one of the following pickers
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
      "echasnovski/mini.pick",
      "folke/snacks.nvim",
    },
  },
}

-- Setup lazy.nvim
require("lazy").setup({
  spec = spec,
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
