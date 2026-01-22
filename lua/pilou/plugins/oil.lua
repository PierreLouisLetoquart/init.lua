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
	},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
}
