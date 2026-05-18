return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	event = {
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		-- refer to `:h file-pattern` for more examples
		"BufReadPre "
			.. vim.fn.expand("~")
			.. "~/Vault/**/*.md",
		"BufNewFile " .. vim.fn.expand("~") .. "~/Vault/**/*.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		workspaces = {
			{
				name = "Vault",
				path = "~/Vault",
			},
		},
		completion = {
			nvim_cmp = true,
		},

		follow_url_func = function(url)
			vim.ui.open(url)
		end,
	},
}
