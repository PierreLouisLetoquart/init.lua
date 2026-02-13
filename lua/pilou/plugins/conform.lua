return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
			typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
			json = { "biome", "prettierd", "prettier", stop_after_first = true },
			jsonc = { "biome", "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		},
		formatters = {
			biome = {
				require_cwd = true,
			},
		},
		format_on_save = function(bufnr)
			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end
		end,
		notify_no_formatters = true,
	},
}
