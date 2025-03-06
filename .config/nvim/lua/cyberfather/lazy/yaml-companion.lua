return {
	"someone-stole-my-name/yaml-companion.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local cfg = require("yaml-companion").setup({})
		require("lspconfig")["yamlls"].setup(cfg)
		require("telescope").load_extension("yaml_schema")
	end,
}
