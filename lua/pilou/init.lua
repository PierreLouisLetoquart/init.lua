vim.g.have_nerd_font = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("pilou.config.lazy")
require("pilou.config.set")
require("pilou.config.keymaps")
require("pilou.config.autocmds")

vim.lsp.config("*", {
	capabilities = vim.lsp.protocol.make_client_capabilities(),
})
