return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- A list of parser names, or "all"
			ensure_installed = {
				"vimdoc",
				"javascript",
				"typescript",
				"c",
				"lua",
				"rust",
				"jsdoc",
				"bash",
				"python",
			},

			sync_install = false,
			auto_install = true,
			indent = {
				enable = true,
			},

			highlight = {
				enable = true,
				disable = { "latex" },
				additional_vim_regex_highlighting = { "markdown" },
			},

			textobjects = {
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
						-- ["ai"] = "@conditional.outer",
						-- ["ii"] = "@conditional.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
			},
		})

		local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()

		treesitter_parser_config.just = {
			install_info = {
				url = "https://github.com/IndianBoy42/tree-sitter-just",
				files = { "src/parser.c", "src/scanner.c" },
				branch = "main",
			},
		}

		treesitter_parser_config.templ = {
			install_info = {
				url = "https://github.com/vrischmann/tree-sitter-templ.git",
				files = { "src/parser.c", "src/scanner.c" },
				branch = "master",
			},
		}

		-- vim.wo.foldmethod = 'expr'
		-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

		vim.treesitter.language.register("just", "just")
		vim.treesitter.language.register("templ", "templ")
	end,
}
