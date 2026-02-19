return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"vim",
			"vimdoc",
			"lua",
			"luadoc",
			"query",
			"bash",
			"c",
			"diff",
			"html",
			"css",
			"xml",
			"json",
			"toml",
			"yaml",
			"markdown",
			"markdown_inline",
			"javascript",
			"jsdoc",
			"typescript",
			"tsx",
			"python",
			"rust",
		})

		-- Enable TS highlighting for any filetype with a parser installed.
		-- Silently no-ops for filetypes without a parser.
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
