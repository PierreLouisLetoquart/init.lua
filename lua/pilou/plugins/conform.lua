local function has_clang_format_config(ctx)
	return vim.fs.find({ ".clang-format", "_clang-format" }, { path = ctx.dirname, upward = true })[1] ~= nil
end

return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			c = { "clang_format" },
			cpp = { "clang_format" },
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
			clang_format = {
				condition = has_clang_format_config,
			},
		},
		format_on_save = function(bufnr)
			local ft = vim.bo[bufnr].filetype
			if
				(ft == "c" or ft == "cpp")
				and not has_clang_format_config({ dirname = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)) })
			then
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
