return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("bufferline").setup({
			options = {
				mode = "tabs", -- afficher les vrais tabs (ou 'buffers')
				separator_style = "thin", -- autres: 'thin', 'padded_slant'
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		})
	end,
}
