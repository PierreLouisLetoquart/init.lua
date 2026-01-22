vim.api.nvim_create_autocmd("LspAttach", {
	buffer = 0,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "lua_ls" then
			client.stop(true)
		end
	end,
})
