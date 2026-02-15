return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local parsers = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"python",
			"typescript",
			"tsx",
			"toml",
			"javascript",
			"jsdoc",
			"json",
			"rust",
			"xml",
			"yaml",
		}
		require("nvim-treesitter").install(parsers)

		local filetypes = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"markdown",
			"python",
			"typescript",
			"typescriptreact",
			"javascript",
			"javascriptreact",
			"toml",
			"json",
			"rust",
			"xml",
			"yaml",
		}

		vim.api.nvim_create_autocmd("FileType", {
			pattern = filetypes,
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
