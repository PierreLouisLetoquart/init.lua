return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },
			-- Allows extra capabilities provided by blink.cmp
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("random-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					local ok, builtin = pcall(require, "telescope.builtin")
					if ok then
						map("grr", builtin.lsp_references, "[G]oto [R]eferences")
						map("gri", builtin.lsp_implementations, "[G]oto [I]mplementation")
						map("grd", builtin.lsp_definitions, "[G]oto [D]efinition")
						map("gO", builtin.lsp_document_symbols, "Open Document Symbols")
						map("gW", builtin.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
						map("grt", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")
					end

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					if client and client.name == "ruff" then
						client.server_capabilities.hoverProvider = false
					end

					if client and (client.name == "vtsls" or client.name == "ts_ls") then
						-- vtsls code actions may return this VS Code-only follow-up command.
						-- Registering a local no-op handler avoids noisy unsupported-command errors.
						client.commands = client.commands or {}
						client.commands["_typescript.didOrganizeImports"] = function() end

						local source_action = function(only)
							return function()
								vim.lsp.buf.code_action({
									apply = true,
									context = {
										only = only,
										diagnostics = {},
									},
								})
							end
						end

						local lsp_organize_imports =
							source_action({ "source.organizeImports.ts", "source.organizeImports" })
						local biome_filetypes = {
							javascript = true,
							javascriptreact = true,
							typescript = true,
							typescriptreact = true,
						}
						local organize_imports = function()
							local ft = vim.bo[event.buf].filetype
							if biome_filetypes[ft] then
								local ok, conform = pcall(require, "conform")
								if ok then
									local info = conform.get_formatter_info("biome-organize-imports", event.buf)
									if info.available then
										conform.format({
											bufnr = event.buf,
											formatters = { "biome-organize-imports" },
											lsp_format = "never",
											timeout_ms = 1000,
										})
										return
									end
								end
							end

							lsp_organize_imports()
						end

						map("<leader>co", organize_imports, "Organize Imports")
						map("<leader>cM", source_action({ "source.addMissingImports.ts" }), "Add Missing Imports")
						map("<leader>cu", source_action({ "source.removeUnused.ts" }), "Remove Unused Imports")
						map("<leader>cD", source_action({ "source.fixAll.ts" }), "Fix All TypeScript")
					end

					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local highlight_augroup = vim.api.nvim_create_augroup("random-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("random-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "random-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client and client:supports_method("textDocument/inlayHint", event.buf) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				copilot = { enabled = false }, -- copilot.lua only works with its own copilot lsp server
				pyright = {
					settings = {
						pyright = {
							disableOrganizeImports = true,
						},
						python = {
							analysis = {
								ignore = { "*" },
							},
						},
					},
				},
				rust_analyzer = {},
				vtsls = {
					settings = {
						complete_function_calls = true,
						vtsls = {
							autoUseWorkspaceTsdk = true,
							enableMoveToFileCodeAction = true,
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
						typescript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								autoImports = true,
								completeFunctionCalls = true,
							},
							preferences = {
								includePackageJsonAutoImports = "on",
								importModuleSpecifierPreference = "non-relative",
							},
						},
						javascript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								autoImports = true,
								completeFunctionCalls = true,
							},
							preferences = {
								includePackageJsonAutoImports = "on",
								importModuleSpecifierPreference = "non-relative",
							},
						},
					},
				},
				tailwindcss = {
					settings = {
						tailwindCSS = {
							classFunctions = { "cn", "cva", "clsx", "tw", "twMerge" },
						},
					},
				},
				ruff = {},
			}

			local ensure_installed = {
				"pyright",
				"rust-analyzer",
				"vtsls",
				"tailwindcss-language-server",
				"ruff",
				"lua-language-server",
				"stylua",
			}

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			for name, server in pairs(servers) do
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				vim.lsp.config(name, server)
				vim.lsp.enable(name)
			end

			vim.lsp.config("lua_ls", {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
							path = { "lua/?.lua", "lua/?/init.lua" },
						},
						workspace = {
							checkThirdParty = false,
							-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
							--  See https://github.com/neovim/nvim-lspconfig/issues/3189
							library = vim.api.nvim_get_runtime_file("", true),
						},
					})
				end,
				settings = {
					Lua = {},
				},
			})
			vim.lsp.enable("lua_ls")
		end,
	},
}
