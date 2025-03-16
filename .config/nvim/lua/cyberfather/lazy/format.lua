return {
	"mhartington/formatter.nvim",
	config = function()
		local util = require("formatter.util")

		local c = function()
			return {
				exe = "clang-format",
				args = {
					[[--style="{IndentWidth: 4, TabWidth: 4}"]],
					"--assume-filename",
					util.escape_path(util.get_current_buffer_file_path()),
				},
				stdin = true,
			}
		end

		local yaml = function()
			return {
				exe = "prettier",
				args = {
					"--tab-width",
					"2",
					"--stdin-filepath",
					util.escape_path(util.get_current_buffer_file_path()),
				},
				stdin = true,
				try_node_modules = false,
			}
		end

		require("formatter").setup({
			logging = true,
			log_level = vim.log.levels.WARN,
			filetype = {
				rust = require("formatter.filetypes.rust").rustfmt,
				cpp = c,
				c = c,
				kotlin = require("formatter.filetypes.kotlin").ktlint,
				sh = require("formatter.filetypes.sh").shfmt,
				lua = require("formatter.filetypes.lua").stylua,
				python = require("formatter.filetypes.python").ruff,
				svelte = require("formatter.defaults.biome"),
				typescriptreact = require("formatter.defaults.biome"),
				typescript = require("formatter.defaults.biome"),
				javascript = require("formatter.defaults.biome"),
				tex = require("formatter.defaults.latexindent"),
				yaml = yaml,
				html = require("formatter.defaults.biome"),
				css = require("formatter.defaults.biome"),
				proto = require("formatter.filetypes.proto").buf_format,
				ruby = require("formatter.filetypes.ruby").rubocop,
				json = require("formatter.defaults.biome"),
				jsonc = require("formatter.defaults.biome"),
			},
		})

		local augroup = vim.api.nvim_create_augroup
		local autocmd = vim.api.nvim_create_autocmd
		augroup("__formatter__", { clear = true })
		autocmd("BufWritePost", {
			group = "__formatter__",
			command = ":FormatWrite",
		})
	end,
}
