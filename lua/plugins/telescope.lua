-- Fuzzy finder (files, grep, LSP symbols, ...).
--
-- Loaded on demand: either through `:Telescope` (`cmd`) or through one of the
-- `keys` below. That keeps telescope, its config and plenary out of startup.

local dependencies = {
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
}

-- telescope-fzf-native compiles a C extension with `make`, so it is only
-- included when `make` is available on this system; otherwise telescope falls
-- back to its built-in sorter.
if vim.fn.executable 'make' == 1 then dependencies[#dependencies + 1] = { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } end

-- Resolved on first use, never at startup.
local function builtin() return require 'telescope.builtin' end
local function themes() return require 'telescope.themes' end

return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    cmd = 'Telescope',
    dependencies = dependencies,
    keys = {
      { '<leader>sh', function() builtin().help_tags() end, desc = '[S]earch [H]elp' },
      { '<leader>sk', function() builtin().keymaps() end, desc = '[S]earch [K]eymaps' },
      { '<leader>sf', function() builtin().find_files() end, desc = '[S]earch [F]iles' },
      { '<leader>ss', function() builtin().builtin() end, desc = '[S]earch [S]elect Telescope' },
      { '<leader>sw', function() builtin().grep_string() end, mode = { 'n', 'v' }, desc = '[S]earch current [W]ord' },
      { '<leader>sg', function() builtin().live_grep() end, desc = '[S]earch by [G]rep' },
      { '<leader>sd', function() builtin().diagnostics() end, desc = '[S]earch [D]iagnostics' },
      { '<leader>sr', function() builtin().resume() end, desc = '[S]earch [R]esume' },
      { '<leader>s.', function() builtin().oldfiles() end, desc = '[S]earch Recent Files ("." for repeat)' },
      { '<leader>sc', function() builtin().commands() end, desc = '[S]earch [C]ommands' },
      { '<leader><leader>', function() builtin().buffers() end, desc = '[ ] Find existing buffers' },
      -- Fuzzily search in the current buffer, without a previewer.
      {
        '<leader>/',
        function()
          builtin().current_buffer_fuzzy_find(themes().get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        desc = '[/] Fuzzily search in current buffer',
      },
      -- Live grep, restricted to the buffers that are already open.
      {
        '<leader>s/',
        function()
          builtin().live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        desc = '[S]earch [/] in Open Files',
      },
      -- Shortcut for searching your Neovim configuration files.
      {
        '<leader>sn',
        function() builtin().find_files { cwd = vim.fn.stdpath 'config', follow = true } end,
        desc = '[S]earch [N]eovim files',
      },
    },
    config = function()
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- Telescope-based LSP pickers, added when an LSP attaches to a buffer.
      -- If you later switch picker plugins, this is where to update these mappings.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf
          local pickers = require 'telescope.builtin'

          -- Find references for the word under your cursor.
          vim.keymap.set('n', 'grr', pickers.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

          -- Jump to the implementation of the word under your cursor.
          -- Useful when your language has ways of declaring types without an actual implementation.
          vim.keymap.set('n', 'gri', pickers.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

          -- Jump to the definition of the word under your cursor.
          -- This is where a variable was first declared, or where a function is defined, etc.
          -- To jump back, press <C-t>.
          vim.keymap.set('n', 'grd', pickers.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

          -- Fuzzy find all the symbols in your current document.
          -- Symbols are things like variables, functions, types, etc.
          vim.keymap.set('n', 'gO', pickers.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

          -- Fuzzy find all the symbols in your current workspace.
          -- Similar to document symbols, except searches over your entire project.
          vim.keymap.set('n', 'gW', pickers.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

          -- Jump to the type of the word under your cursor.
          -- Useful when you're not sure what type a variable is and you want to see
          -- the definition of its *type*, not where it was *defined*.
          vim.keymap.set('n', 'grt', pickers.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
      })
    end,
  },
}
