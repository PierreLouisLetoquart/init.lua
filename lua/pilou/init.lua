vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

require("pilou.config.lazy")
require("pilou.config.set")
require("pilou.config.keymaps")
require("pilou.config.autocmds")
require("pilou.config.diagnostics")
