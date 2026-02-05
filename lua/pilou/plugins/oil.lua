return {
	"stevearc/oil.nvim",
	opts = {
		columns = {
			"icon",
			"size",
			"mtime",
		},
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		view_options = {
			is_hidden_file = function(name, bufnr)
				local m = name:match("^%.") or name:match("__pycache__$")
				return m ~= nil
			end,
		},
	},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
}
