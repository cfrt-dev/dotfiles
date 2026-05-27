local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local map = vim.keymap.set

telescope.setup({
	defaults = {
		mapping = {
			i = {
				["<esc>"] = actions.close,
			},
		},
		file_ignore_patterns = { "node_modules", "target" },
		preview = { treesitter = true, wrap = false },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = {
			"", -- top
			"", -- right
			"", -- bottom
			"", -- left
			"", -- top-left
			"", -- top-right
			"", -- bottom-right
			"", -- bottom-left
		},
		path_displays = { "smart" },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
			horizontal = {
				preview_width = 0.5,
			},
		},
	},
	pickers = {
		buffers = {
			mapping = {
				i = {
					["<C-d>"] = actions.delete_buffer + actions.move_to_top,
				},
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
		},
	},
})

telescope.load_extension("ui-select")
telescope.load_extension("fzf")

map("n", "<leader>pg", builtin.live_grep)
map("n", "<leader>pf", builtin.find_files)
map("n", "<leader>pa", builtin.builtin)
map("n", "<leader>pc", builtin.colorscheme)
map("n", "<leader>vh", builtin.help_tags)
map("n", "<leader>d", builtin.diagnostics)

vim.api.nvim_create_autocmd("User", {
	pattern = "TelescopePreviewerLoaded",
	callback = function(_)
		vim.wo.number = true
	end,
})
