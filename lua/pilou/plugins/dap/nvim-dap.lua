return {
	"mfussenegger/nvim-dap",
	lazy = true,
	-- Copied from https://www.johntobin.ie/blog/debugging_in_neovim_with_nvim-dap/
	-- and modify
	keys = {
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "[d]ebugger Toggle [B]reakpoint",
		},

		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "[d]ebugger [C]ontinue",
		},

		{
			"<leader>dC",
			function()
				require("dap").run_to_cursor()
			end,
			desc = "[d]ebugger Run to [C]ursor",
		},

		{
			"<leader>dT",
			function()
				require("dap").terminate()
			end,
			desc = "[d]ebugger [T]erminate",
		},
	},
	config = function()
		local dap = require("dap")
		local utils = require("dap.utils")

		-- Configure adapters
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = { "/home/pl/js-debug/src/dapDebugServer.js", "${port}" },
			},
		}

		-- Configure debug configurations
		dap.configurations["typescript"] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file (npx tsx)",
				cwd = "${workspaceFolder}",
				runtimeExecutable = "npx",
				runtimeArgs = { "tsx", "${file}" },
				sourceMaps = true,
				skipFiles = { "<node_internals>/**", "**/node_modules/**" },
			},
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-node",
				request = "attach",
				name = "Attach to process ID",
				processId = utils.pick_process,
				cwd = "${workspaceFolder}",
			},
		}
		dap.configurations.javascript = dap.configurations.typescript
	end,
}
