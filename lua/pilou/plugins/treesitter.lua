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
		-- Falls back to auto-installing the parser if missing.
		local ignored_filetypes = { oil = true }

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				if ignored_filetypes[vim.bo.filetype] then
					return
				end
				if not pcall(vim.treesitter.start) then
					local lang = vim.treesitter.language.get_lang(vim.bo.filetype) or vim.bo.filetype
					require("nvim-treesitter").install({ lang })
				end
			end,
		})
	end,
}
