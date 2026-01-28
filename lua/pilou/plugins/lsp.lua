return {
	{ "williamboman/mason.nvim", opts = {} },
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = {
				"html",
				"ruff",
				"pyright",
				"prettier",
				"rust_analyzer",
				"lua_ls",
				"biome",
				"ts_ls",
				"tailwindcss",
			},
		},
	},
}
