return {
	"someone-stole-my-name/yaml-companion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local cfg = require("yaml-companion").setup({})
		-- vim.lsp.config("yamlls")
		require("telescope").load_extension("yaml_schema")
	end,
}
