return {
	{
		"catppuccin/nvim",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				background = {
					light = "latte",
					dark = "mocha",
				},
				auto_integrations = true,
				float = {
					transparent = false,
					solid = true,
				},
				integrations = {
					blink_cmp = {
						style = "bordered",
					},
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{ -- auto theme toggle synced on system
		"f-person/auto-dark-mode.nvim",
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.api.nvim_set_option_value("background", "dark", {})
				vim.cmd("colorscheme catppuccin")
			end,
			set_light_mode = function()
				vim.api.nvim_set_option_value("background", "light", {})
				vim.cmd("colorscheme catppuccin-latte")
			end,
		},
	},
}
