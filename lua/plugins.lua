return {
  -- todo: change for copilot.lua
  'github/copilot.vim',
  -- theme inspired from vscode tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
  -- gc to comment
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  }
}
