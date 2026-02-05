return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		require("telescope").setup({
			defaults = require("telescope.themes").get_ivy(),
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		local entry_display = require("telescope.pickers.entry_display")
		local make_entry = require("telescope.make_entry")
		local Path = require("plenary.path")
		local utils = require("telescope.utils")

		local filename_first_entry_maker = function(opts)
			opts = opts or {}
			local gen = make_entry.gen_from_file(opts)
			local cwd = utils.path_expand(opts.cwd or vim.loop.cwd())
			local disable_devicons = opts.disable_devicons

			local displayer = entry_display.create({
				separator = " ",
				items = {
					{ width = 2 },
					{ width = opts.fname_width or 30 },
					{ remaining = true },
				},
			})

			local make_display = function(entry)
				local full = entry.value
				local abs = full
				if not Path:new(full):is_absolute() then
					abs = Path:new({ cwd, full }):absolute()
				end
				local rel = Path:new(abs):make_relative(cwd)
				local filename = utils.path_tail(rel)
				local parent = vim.fn.fnamemodify(rel, ":h")
				if parent == "." then
					parent = ""
				end

				local icon, icon_hl = utils.get_devicons(full, disable_devicons)
				return displayer({
					{ icon, icon_hl },
					filename,
					{ parent, "TelescopeResultsComment" },
				})
			end

			return function(line)
				local entry = gen(line)
				entry.display = make_display
				return entry
			end
		end

		local find_files_filename_first = function(opts)
			opts = opts or {}
			opts.entry_maker = filename_first_entry_maker(opts)
			builtin.find_files(opts)
		end
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", find_files_filename_first, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch [B]uffers" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

		vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, { desc = "[G]o to the [D]efinition" })
		vim.keymap.set("n", "<leader>gi", builtin.lsp_implementations, { desc = "[G]o to the [I]mplementation" })
		vim.keymap.set("n", "<leader>gr", builtin.lsp_references, { desc = "[G]o to [R]eferences (fuzzy)" })

		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })

		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}
