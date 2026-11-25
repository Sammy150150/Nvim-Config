-- Treesitter: syntax highlighting, folds and indentation.
--
-- Eager (`lazy = false`) because highlighting is needed for the first buffer.
-- What is *not* done at startup anymore: running the installer machinery when
-- every parser is already present.
--
-- Parsers are compiled by `:TSUpdate` through the `build` hook; `CC` is set to
-- `gcc` in init.lua before plugins load.

-- Basic parsers that should always be available.
local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'

      -- Cached list of installed parsers. Refreshed after an auto-install so
      -- the `FileType` callback does not have to rescan the parser directory.
      local installed = ts.get_installed 'parsers'

      -- Only invoke the installer when something is actually missing.
      local missing = vim.tbl_filter(function(parser) return not vim.tbl_contains(installed, parser) end, parsers)
      if #missing > 0 then ts.install(missing) end

      local available_parsers = ts.get_available()

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        -- Check if the buffer is valid (might not be after install completes)
        if not vim.api.nvim_buf_is_valid(buf) then return end

        -- Check if a parser exists and load it
        if not vim.treesitter.language.add(language) then return end

        -- Enable syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- Enable treesitter based folds
        -- For more info on folds see `:help folds`
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- vim.wo.foldmethod = 'expr'

        -- Check if treesitter indentation is available for this language, and if so enable it
        -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
        local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

        -- Enable treesitter based indentation
        if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
      end

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          if vim.tbl_contains(installed, language) then
            -- Enable the parser if it is already installed
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
            ts.install(language):await(function()
              installed = ts.get_installed 'parsers'
              treesitter_try_attach(buf, language)
            end)
          else
            -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },
}
