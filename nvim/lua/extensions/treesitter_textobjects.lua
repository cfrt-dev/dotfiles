require("nvim-treesitter-textobjects").setup({
	select = {
		enable = true,
		lookahead = true,
		keymaps = {
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["at"] = "@comment.outer",
			["it"] = "@comment.inner",
			["al"] = "@loop.outer",
			["il"] = "@loop.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
		},
	},
})
