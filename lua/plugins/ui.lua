-- Core UX / UI plugins.
--
-- Every plugin here declares its own lazy-loading trigger, so nothing in this
-- file costs startup time unless the trigger fires. `config` (the `.setup()`
-- call) runs on first load, not when Neovim starts.

return {
  ---------------------------------------------------------------------------
  -- Indentation
  ---------------------------------------------------------------------------

  -- Automatically detect the indentation of files you open.
  -- https://github.com/NMAC427/guess-indent.nvim
  {
    'NMAC427/guess-indent.nvim',
    event = 'BufReadPre',
    config = function() require('guess-indent').setup {} end,
  },

  ---------------------------------------------------------------------------
  -- Git
  ---------------------------------------------------------------------------

  -- Git signs in the gutter, plus hunk actions.
  -- Loaded when a buffer is read, which also defers the `git` process spawn.
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local gitsigns = require 'gitsigns'
      gitsigns.setup {
        signs = {
          add = { text = '+' }, ---@diagnostic disable-line: missing-fields
          change = { text = '~' }, ---@diagnostic disable-line: missing-fields
          delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
          topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
          changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
        },
        -- gitsigns.nvim's recommended keymaps:
        on_attach = function(bufnr)
          -- Navigation
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              gitsigns.nav_hunk 'next'
            end
          end, { desc = 'Jump to next git [c]hange', buf = bufnr })

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              gitsigns.nav_hunk 'prev'
            end
          end, { desc = 'Jump to previous git [c]hange', buf = bufnr })

          -- Visual mode actions
          vim.keymap.set('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk', buf = bufnr })
          vim.keymap.set('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk', buf = bufnr })
          -- Normal mode actions
          vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk', buf = bufnr })
          vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk', buf = bufnr })
          vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer', buf = bufnr })
          vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer', buf = bufnr })
          vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk', buf = bufnr })
          vim.keymap.set('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline', buf = bufnr })
          vim.keymap.set('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'git [b]lame line', buf = bufnr })
          vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index', buf = bufnr })
          vim.keymap.set('n', '<leader>hD', function() gitsigns.diffthis '~' end, { desc = 'git [D]iff against last commit', buf = bufnr })
          vim.keymap.set('n', '<leader>hQ', function() gitsigns.setqflist 'all' end, { desc = 'git hunk [Q]uickfix list (all files in repo)', buf = bufnr })
          vim.keymap.set('n', '<leader>hq', gitsigns.setqflist, { desc = 'git hunk [q]uickfix list (all changes in this file)', buf = bufnr })
          -- Toggles
          vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line', buf = bufnr })
          vim.keymap.set('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git intra-line [w]ord diff', buf = bufnr })
          -- Text object
          vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'text object [i]nside [h]unk', buf = bufnr })
        end,
      }
    end,
  },

  ---------------------------------------------------------------------------
  -- Keybind hints / colorscheme / comments
  ---------------------------------------------------------------------------

  -- Shows pending keybinds. Loads right after startup instead of during it.
  -- `delay = 0` still works: the plugin is ready before you can press a key.
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup {
        -- Delay between pressing a key and opening which-key (milliseconds)
        delay = 0,
        icons = { mappings = vim.g.have_nerd_font },
        -- Document existing key chains
        spec = {
          { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
          { 'gr', group = 'LSP Actions', mode = { 'n' } },
        },
      }
    end,
  },

  -- Colorscheme. Stays eager so the UI is never unstyled, but it is tiny.
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Other styles: 'tokyonight-storm', 'tokyonight-moon', 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    config = function() require('todo-comments').setup { signs = false } end,
  },

  ---------------------------------------------------------------------------
  -- mini.nvim
  ---------------------------------------------------------------------------
  -- Kept eager: the statusline and icons are visible on the very first frame
  -- and the handful of modules used here costs only a few milliseconds.
  {
    'nvim-mini/mini.nvim',
    lazy = false,
    config = function()
      -- If a nerd font is available, load the icons module for pretty icons in various plugins.
      if vim.g.have_nerd_font then
        require('mini.icons').setup()
        -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
        MiniIcons.mock_nvim_web_devicons()
      end

      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup {
        -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
        mappings = {
          around_next = 'aa',
          inside_next = 'ii',
        },
        n_lines = 500,
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      -- You could remove this setup call if you don't like it,
      -- and try some other statusline plugin.
      local statusline = require 'mini.statusline'
      -- Set `use_icons` to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
      -- ... and there is more! See https://github.com/nvim-mini/mini.nvim
    end,
  },

  ---------------------------------------------------------------------------
  -- On-demand extras
  ---------------------------------------------------------------------------

  -- Wrap text with Emmet abbreviations. Loads on first <leader>xe.
  {
    'olrtg/nvim-emmet',
    keys = {
      {
        '<leader>xe',
        function() require('nvim-emmet').wrap_with_abbreviation() end,
        mode = { 'n', 'v' },
        desc = 'Wrap with abbreviation',
      },
    },
  },

  -- Live preview of HTML/CSS in the browser. Only loaded by `:LivePreview`.
  {
    'brianhuster/live-preview.nvim',
    cmd = 'LivePreview',
    dependencies = {
      -- Picker used by live-preview.nvim to browse files. Telescope is this
      -- config's picker; the other pickers live-preview supports are optional.
      'nvim-telescope/telescope.nvim',
    },
  },
}
