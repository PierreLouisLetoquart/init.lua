return {
	{ "williamboman/mason.nvim", opts = {} },
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = {
				"html",
				"ruff",
				"pyright",
				"rust_analyzer",
				"lua_ls",
				"biome",
				"ts_ls",
				"tailwindcss",
			},
			servers = {
				ruff_lsp = {},
				pyright = {
					settings = {
						python = {
							analysis = {
								autoImportCompletions = true,
								typeCheckingMode = "off",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace", -- "openFilesOnly",
							},
						},
					},
				},
			},
			setup = {
				pyright = function(_, _)
					local lsp_utils = require("base.lsp.utils")
					lsp_utils.on_attach(function(client, bufnr)
						local map = function(mode, lhs, rhs, desc)
							if desc then
								desc = desc
							end
							vim.keymap.set(
								mode,
								lhs,
								rhs,
								{ silent = true, desc = desc, buffer = bufnr, noremap = true }
							)
						end
            -- stylua: ignore
            if client.name == "pyright" then
              map("n", "<leader>lo", "<cmd>PyrightOrganizeImports<cr>",  "Organize Imports" )
              map("n", "<leader>lC", function() require("dap-python").test_class() end,  "Debug Class" )
              map("n", "<leader>lM", function() require("dap-python").test_method() end,  "Debug Method" )
              map("v", "<leader>lE", function() require("dap-python").debug_selection() end, "Debug Selection" )
            end
					end)
				end,
			},
		},
	},
}
