return {
	"pwntester/octo.nvim",
	requires = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("octo").setup({ enable_builtins = true })
		vim.cmd([[hi OctoEditable guibg=none]])
	end,
	keys = {
		{ "<leader>oic", "<cmd>Octo issue create<cr>", desc = "Octo issue create" },
		{ "<leader>oil", "<cmd>Octo issue list<cr>", desc = "Octo issue create" },
	},
}
