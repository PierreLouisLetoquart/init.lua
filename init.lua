vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.netrw_banner = 0

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ {import = "plugins"}, {import = "plugins.lsp"} })

require("core.options")
require("core.keymaps")
