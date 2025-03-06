return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"jay-babu/mason-nvim-dap.nvim",
		"mfussenegger/nvim-dap",
		"theHamsta/nvim-dap-virtual-text",
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap-python",
		"leoluz/nvim-dap-go",
		"nvim-neotest/nvim-nio",
	},

	config = function()
		require("nvim-dap-virtual-text").setup()
		require("dap-python").setup()
		require("dap-go").setup()
		require("mason-nvim-dap").setup({
			ensure_installed = { "cppdbg", "codelldb" },
			handlers = {},
		})

		local dap, ui = require("dap"), require("dapui")
		ui.setup()

		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
		vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)

		vim.keymap.set("n", "<leader>?", function()
			ui.eval(nil, { enter = true })
		end)

		vim.keymap.set("n", "<F1>", dap.continue)
		vim.keymap.set("n", "<F2>", dap.step_into)
		vim.keymap.set("n", "<F3>", dap.step_over)
		vim.keymap.set("n", "<F4>", dap.step_out)
		vim.keymap.set("n", "<F5>", dap.step_back)
		vim.keymap.set("n", "<F6>", dap.restart)

		dap.listeners.before.attach.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			ui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			ui.close()
		end
	end,
}
