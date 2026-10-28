-- Add indentation guides even on blank lines
--
-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help ibl`
--
-- lazy.nvim spec: enable by uncommenting
-- `{ import = "kickstart.plugins.indent_line" }` in lua/config/lazy.lua

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function() require("ibl").setup {} end,
  },
}
