return {
  -- theme inspired from vscode tokyonight
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme tokyonight-night]])
  end,
}
