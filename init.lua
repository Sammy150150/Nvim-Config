vim.cmd([[
  autocmd FileType python map <buffer> <F9> :w<CR>:exec '!py' shellescape(@%, 1)<CR>
  autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!py' shellescape(@%, 1)<CR>
  set hidden
]])

vim.g.netrw_keepdir = 0

-- Tell the `tree-sitter` CLI to use gcc for compiling parsers.
-- Must be set before plugins load: lazy.nvim runs `:TSUpdate` as the
-- nvim-treesitter build step. Without this, tree-sitter defaults to
-- MSVC's `cl.exe`, which is not installed on this machine.
vim.env.CC = "gcc"

-- Git for Windows bundles `unzip`, which Neovim's zip support and mason look
-- for. Append its usr/bin instead of prepending it, so the MSYS tools it
-- contains cannot shadow the Windows ones earlier on PATH.
if vim.fn.executable('unzip') == 0 and vim.fn.executable('git') == 1 then
  local git_usr_bin = vim.fs.dirname(vim.fs.dirname(vim.fn.exepath('git'))) .. '/usr/bin'
  if (vim.uv or vim.loop).fs_stat(git_usr_bin .. '/unzip.exe') then
    vim.env.PATH = vim.env.PATH .. ';' .. git_usr_bin
  end
end

-- plenary.nvim (loaded by telescope.nvim) still calls the deprecated
-- `vim.F.if_nil`, which shows up as a warning in `:checkhealth`. Plenary is
-- archived upstream, so point the alias at the non-deprecated implementation.
-- TODO: remove once telescope/plenary no longer use `vim.F.if_nil`.
if vim.nonnil then
  vim.F.if_nil = vim.nonnil
end

-- Cache compiled Lua modules. Must run before any plugin module is required.
vim.loader.enable()

-- Set to true if you have a Nerd Font installed and selected in the terminal.
-- Must be set before plugin configs run (mini.icons, which-key, ...), because
-- lazy-loaded plugins are configured before the rest of init.lua executes.
vim.g.have_nerd_font = false

-- Bootstraps lazy.nvim and loads `lua/plugins/*.lua` (mostly lazily, on demand).
require("config.lazy")

vim.g.mapleader = " "          -- Sets global leader to Space
vim.g.maplocalleader = " "    -- Sets local leader (e.g., to backslash or comma)

vim.opt.tabstop = 4        -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 4    -- Number of spaces inserted for a <Tab> while editing
vim.opt.shiftwidth = 4     -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.showmode = true

-- NOTE: 'shell' must be a shell (cmd.exe, pwsh.exe, bash, ...), not a terminal
-- emulator: `:!`, `:terminal`, and `vim.fn.system()` pass shell arguments to it.
-- Leave it at the default (cmd.exe) unless you deliberately configure a shell.

--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- ============================================================
-- SECTION 1: OPTIONS
-- Core Neovim settings, leaders, options
-- ============================================================
do
  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- [[ Setting options ]]
  --  See `:help vim.o`
  -- NOTE: You can change these options as you wish!
  --  For more options, you can see `:help option-list`

  -- Hybrid line numbers: absolute number on the cursor line,
  -- relative numbers on all other lines (helps with jumps like 5j).
  vim.o.number = true
  vim.o.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim: every yank copies to the system
  --  clipboard and every paste reads from it, so Neovim shares copy/paste
  --  with other applications. Remove this option if you want your OS clipboard
  --  to remain independent.
  --  See `:help 'clipboard'`
  vim.o.clipboard = 'unnamedplus'

  -- Enable break indent
  vim.o.breakindent = true

  -- Enable undo/redo changes even after closing and reopening a file
  vim.o.undofile = true

  -- Reload a file from disk when it changed outside of Neovim, as long as the
  --  buffer has no unsaved changes. This only takes effect when Neovim checks
  --  the file, which the `kickstart-autoread` autocmd below takes care of.
  --  See `:help 'autoread'`
  vim.o.autoread = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.o.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  --
  --  Notice listchars is set using `vim.opt` instead of `vim.o`.
  --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
  --   See `:help lua-options`
  --   and `:help lua-guide-options`
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 10

  -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- See `:help 'confirm'`
  vim.o.confirm = true
end

-- ============================================================
-- SECTION 2: KEYMAPS & AUTOCMDS
-- basic keymaps, basic autocmds
-- ============================================================
do
  -- [[ Basic Keymaps ]]
  --  See `:help vim.keymap.set()`

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic Config & Keymaps
  --  See `:help vim.diagnostic.Opts`
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Can switch between these as you prefer
    virtual_text = true, -- Text shows up at the end of the line
    virtual_lines = false, -- Text shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- TIP: Disable arrow keys in normal mode
  -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
  -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
  -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
  -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
  -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  -- Reload buffers whose files were changed by another program.
  --  Neovim only re-reads a file when it checks it, so run `:checktime` when
  --  Neovim regains focus (e.g. after editing in another app) and when a
  --  buffer is entered. `CursorHold` covers terminals that don't report focus
  --  changes. Unsaved buffers are left alone and Neovim warns instead.
  --  See `:help 'autoread'`, `:help :checktime` and `:help FileChangedShell`
  vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
    desc = 'Reload files changed outside of Neovim',
    group = vim.api.nvim_create_augroup('kickstart-autoread', { clear = true }),
    callback = function()
      -- `:checktime` is not allowed in the command-line window
      if vim.fn.getcmdwintype() ~= '' then return end
      vim.cmd.checktime()
    end,
  })
end

-- ============================================================
-- SECTION 3: PLUGIN MANAGER INTRO
-- lazy.nvim intro, build hooks
-- ============================================================
do
  -- [[ Intro to `lazy.nvim` ]]
  -- lazy.nvim is the plugin manager used by this configuration.
  --  It is bootstrapped and set up in `lua/config.lazy`, which is
  --  loaded at the top of this file via `require("config.lazy")`.
  --
  --  Plugin specs live in `lua/plugins/*.lua`, one file per area (UI, search,
  --  LSP, formatting, completion, treesitter). Each plugin's `.setup()` runs
  --  from that spec's `config`, which lazy.nvim calls on first load.
  --
  --  Declare the lazy-loading trigger (`event`, `cmd`, `keys`, `ft`) next to
  --  the spec so the plugin only loads when it is actually needed.
  --
  --  Useful commands:
  --    :Lazy          - open the lazy.nvim UI
  --    :Lazy update   - update all plugins
  --    :Lazy sync     - install missing, update, and clean removed plugins
  --    :Lazy clean     - remove plugins that are no longer in the spec
  --
  --  Build steps (e.g. compiling telescope-fzf-native, TSUpdate for
  --  treesitter) are handled by lazy.nvim's `build` hooks declared in
  --  `lua/plugins/*.lua`, so no autocmd is needed here.
end

-- ============================================================
-- SECTION 4: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
-- Plugin configuration lives in `lua/plugins/*.lua`, next to each plugin's
-- lazy-loading trigger:
--   lua/plugins/ui.lua         guess-indent, gitsigns, which-key, tokyonight,
--                              todo-comments, mini.nvim, live-preview, emmet
-- Keeping `.setup()` there lets lazy.nvim defer loading until the plugin is
-- actually needed (keypress, command, event) instead of paying for it at start.

-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION
-- Telescope setup, keymaps, LSP picker mappings
-- ============================================================
-- Telescope is configured in `lua/plugins/telescope.lua` and loaded on demand
-- (`:Telescope`, or one of the <leader>s* keymaps declared in that spec).

-- ============================================================
-- SECTION 6: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
do
  -- [[ LSP Configuration ]]
  -- Brief aside: **What is LSP?**
  --
  -- LSP is an initialism you've probably heard, but might not understand what it is.
  --
  -- LSP stands for Language Server Protocol. It's a protocol that helps editors
  -- and language tooling communicate in a standardized fashion.
  --
  -- In general, you have a "server" which is some tool built to understand a particular
  -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
  -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
  -- processes that communicate with some "client" - in this case, Neovim!
  --
  -- LSP provides Neovim with features like:
  --  - Go to definition
  --  - Find references
  --  - Autocompletion
  --  - Symbol Search
  --  - and more!
  --
  -- Thus, Language Servers are external tools that must be installed separately from
  -- Neovim. This is where `mason` and related plugins come into play.
  --
  -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  -- and elegantly composed help section, `:help lsp-vs-treesitter`

  -- fidget.nvim is configured in `lua/plugins/lsp.lua` and loads on `LspAttach`.

  --  This function gets run when an LSP attaches to a particular buffer.
  --    That is to say, every time a new file is opened that is associated with
  --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --    function will be executed to configure the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Rename the variable under your cursor.
      --  Most Language Servers support renaming across files, etc.
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --  See `:help lsp-config` for information about keys and how to configure
  ---@type table<string, vim.lsp.Config>
  -- Language servers are declared in `lua/config/servers.lua` so that
  -- mason-tool-installer can reuse the same list. See `lua/plugins/lsp.lua`.
  local servers = require 'config.servers'

  -- mason.nvim and mason-lspconfig are configured in `lua/plugins/lsp.lua`.
  -- They stay eager because `mason.setup()` is what puts `mason/bin` on PATH;
  -- mason-tool-installer (the tool auto-installer) loads on VeryLazy.

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
-- conform.nvim is configured in `lua/plugins/formatting.lua` and loads on
-- `BufWritePre` or <leader>f.

-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
-- LuaSnip and blink.cmp are configured in `lua/plugins/completion.lua` and
-- load on `InsertEnter`.

-- ============================================================
-- SECTION 9: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
-- nvim-treesitter is configured in `lua/plugins/treesitter.lua`. It stays
-- eager (`lazy = false`) because highlighting is needed on the first buffer,
-- but parser installation only runs when parsers are actually missing.

-- ============================================================
-- SECTION 10: OPTIONAL EXAMPLES / NEXT STEPS
-- kickstart.plugins.* examples
-- ============================================================
do
  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  They are lazy.nvim specs - to enable one, uncomment its `{ import = ... }`
  --  line in `lua/config/lazy.lua` (you will need to restart nvim).
  --
  -- { import = 'kickstart.plugins.debug' }
  -- { import = 'kickstart.plugins.indent_line' }
  -- { import = 'kickstart.plugins.lint' }
  -- { import = 'kickstart.plugins.autopairs' }
  -- { import = 'kickstart.plugins.neo-tree' }

  -- NOTE: You can add your own plugins, configuration, etc. in `lua/custom/plugins/*.lua`.
  --
  -- The main plugin specs live in `lua/plugins/*.lua` and are imported by
  -- `lua/config/lazy.lua`. To add a plugin, drop a spec file in that directory
  -- (or add it to an existing one) and pick a lazy-loading trigger.
  --
  -- For independent modules, uncomment the convenience loader:
  -- require 'custom.plugins'
  --
  -- `custom.plugins` automatically loads files from that directory, but their
  -- order is unspecified. If plugins depend on each other, keep them in the same
  -- file and put their `setup()` calls in the required order.
  --
  -- If separate modules need a specific order, require them explicitly instead:
  -- require 'custom.plugins.colorscheme'
  -- require 'custom.plugins.ui'
  -- require 'custom.plugins.git'
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

