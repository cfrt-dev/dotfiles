local nvim_config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h:h")
local default_sqruff_config = nvim_config_dir .. "/.sqruff"

require("conform").setup({
	format_on_save = {
		timeout_ms = 5000,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		c = { "clang-format" },
		cpp = { "clang-format" },
		go = { "gofmt" },
		html = { "biome" },
		javascript = { "biome" },
		javascriptreact = { "biome" },
		json = { "jq" },
		lua = { "stylua" },
		odin = { "odin" },
		python = { "ruff_format" },
		sh = { "shfmt" },
		typescript = { "biome" },
		typescriptreact = { "biome" },
		sql = { "sqruff" },
		["_"] = { "trim_whitespace" },
	},
	formatters = {
		["clang-format"] = {
			prepend_args = { "-style=file", "-fallback-style=LLVM" },
		},
		sqruff = {
			exit_codes = { 0, 1 },
			args = function(_, ctx)
				local project_config = vim.fs.find(".sqruff", {
					path = vim.fs.dirname(ctx.filename),
					upward = true,
				})[1]

				if project_config then
					return { "fix", "$FILENAME" }
				end

				return { "--config", default_sqruff_config, "fix", "$FILENAME" }
			end,
		},
	},
})

vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ bufnr = 0 })
end)
