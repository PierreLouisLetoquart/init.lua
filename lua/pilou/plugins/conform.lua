return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			cpp = { "clang-format" },
			css = { "prettier" },
			html = { "prettier" },
			javascript = { "biome", "prettier", stop_after_first = true },
			javascriptreact = { "biome", "prettier", stop_after_first = true },
			json = { "biome", "prettier" },
			lua = { "stylua" },
			markdown = { "prettier" },
			rust = { "rustfmt", lsp_format = "fallback" },
			typescript = { "biome", "prettier", stop_after_first = true },
			typescriptreact = { "biome", "prettier", stop_after_first = true },
			python = {
				-- To fix auto-fixable lint errors.
				"ruff_fix",
				-- To run the Ruff formatter.
				"ruff_format",
				-- To organize the imports.
				"ruff_organize_imports",
			},

			["_"] = { "trim_whitespace" },
		},
		format_on_save = {
			timeout_ms = 200,
			lsp_format = "fallback",
		},
		notify_no_formatters = true,
		formatters = {
			biome = {
				condition = function(ctx)
					return vim.fs.find("biome.json", { upward = true, path = ctx.filename })[1] ~= nil
				end,
			},
		},
	},
}
