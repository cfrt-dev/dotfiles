local map = vim.keymap.set

vim.lsp.enable({
	"ols",
	"lua_ls",
	"cssls",
	"svelte",
	"tinymist",
	"clangd",
	"ruff",
	"powershell_es",
	"dockerls",
	"docker_compose_language_service",
	"hlint",
	"tailwindcss",
	"ts_ls",
	"gopls",
	"emmet_language_server",
	"emmet_ls",
	"pyright",
	"buf",
})

local yaml_cfg = require("extensions.yaml_companion")
vim.lsp.config("yamlls", yaml_cfg)
vim.lsp.enable("yamlls")

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = {
				globals = { "vim", "require" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = { enable = false },
			format = {
				enable = true,
				defaultConfig = {
					indent_style = "space",
					indent_size = "2",
				},
			},
		},
	},
})

map("n", "gd", vim.lsp.buf.definition)
map("n", "K", vim.lsp.buf.hover)
map("n", "<leader>vca", vim.lsp.buf.code_action)
map("n", "<leader>vrr", vim.lsp.buf.references)
map("n", "<leader>vrn", vim.lsp.buf.rename)
