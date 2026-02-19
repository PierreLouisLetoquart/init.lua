return {
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						vim.tbl_map(function(type)
							require("luasnip.loaders.from_" .. type).lazy_load()
						end, { "vscode", "snipmate", "lua" })

						require("luasnip").filetype_extend(
							"typescriptreact",
							{ "html", "javascript", "javascriptreact", "typescript" }
						)
						require("luasnip").filetype_extend("typescript", { "tsdoc", "javascript" })
						require("luasnip").filetype_extend("javascript", { "jsdoc" })
						require("luasnip").filetype_extend("lua", { "luadoc" })
						require("luasnip").filetype_extend("python", { "pydoc" })
						require("luasnip").filetype_extend("rust", { "rustdoc" })
					end,
				},
			},
			opts = {},
		},
	},
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		keymap = {
			preset = "enter",
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			documentation = { auto_show = false, auto_show_delay_ms = 500 },
			menu = { border = "rounded" },
		},
		sources = {
			default = { "lsp", "path", "snippets" },
		},
		snippets = { preset = "luasnip" },
		-- See :h blink-cmp-config-fuzzy for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
		signature = { enabled = true, window = { border = "rounded" } },
	},
}
