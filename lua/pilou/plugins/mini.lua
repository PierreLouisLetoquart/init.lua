return {
	"echasnovski/mini.nvim",
	config = function()
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })

		require("mini.icons").setup()
		require("mini.pairs").setup()

		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })

		-- 1. Remove Location (Line & Column)
		-- We set the function to return an empty string so nothing renders.
		statusline.section_location = function()
			return ""
		end

		statusline.section_filename = function()
			local path = vim.fn.expand("%:p:.") -- Path relative to CWD
			if path == "" then
				return "[No Name]"
			end

			local max_width = 30 -- Change this to adjust when truncation happens

			if #path > max_width then
				local filename = vim.fn.expand("%:t")
				local available_space = max_width - #filename - 4

				if available_space > 0 then
					local dir = vim.fn.expand("%:p:.:h")
					path = string.sub(dir, 1, available_space) .. ".../" .. filename
				else
					local keep = math.floor((max_width - 3) / 2)
					path = string.sub(path, 1, keep) .. "..." .. string.sub(path, -keep)
				end
			end

			return path
		end
	end,
}
