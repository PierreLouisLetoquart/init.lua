vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.hxm",
	callback = function()
		vim.bo.filetype = "lua"
		-- vim.diagnostic.disable(0)
	end,
})
