-- autopairs
-- https://github.com/windwp/nvim-autopairs
--
-- lazy.nvim spec: enable by uncommenting
-- `{ import = "kickstart.plugins.autopairs" }` in lua/config/lazy.lua

return {
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end,
  },
}
