return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "InsertEnter",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = false,
			keymap = {
				accept = "<M-l>",
				next = "<M-n>",
				prev = "<M-p>",
			},
		},
		panel = { enabled = false },
		filetypes = {
			markdown = true,
			help = true,
		},
	},
}
