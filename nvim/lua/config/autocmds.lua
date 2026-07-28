local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("cfrt", {})

autocmd("BufWritePre", {
	group = "cfrt",
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = function()
		vim.lsp.buf.code_action({
			context = { only = { "source.organizeImports.biome" }, diagnostics = {} },
			apply = true,
			sync = true,
		})
	end,
})

autocmd("TextYankPost", {
	group = "cfrt",
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})
