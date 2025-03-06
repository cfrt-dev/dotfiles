return {
	{
		dependencies = { "nvim-telescope/telescope.nvim" },
		"CyberFatherRT/license.nvim",
		config = function()
			local license = require("license")
			license.setup("CyberFatherRT")

			vim.keymap.set("n", "<leader>gl", function()
				license.paste_license()
			end)
		end,
	},
	{
		"CyberFatherRT/rfc.nvim",
		config = function()
			local rfc = require("rfc")
			rfc.setup({
				rfc_dir = vim.fn.expand("$HOME/.local/share/nvim/rfc.nvim"),
			})

			vim.keymap.set("n", "<leader>rf", function()
				rfc.list_rfcs()
			end)
		end,
	},
	{
		"CyberFatherRT/compile.nvim",
		config = function()
			require("compile")
		end,
	},
}
