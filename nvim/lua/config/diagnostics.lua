local map = vim.keymap.set

vim.diagnostic.config({
	virtual_text = true,
	status = {},
	signs = false,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		header = "",
		prefix = "",
	},
	jump = {
		on_jump = function(diagnostic, _)
			vim.diagnostic.open_float({ diagnostic })
		end,
	},
})

map("n", "<leader>vd", vim.diagnostic.open_float)
map("n", "[d", function()
	vim.diagnostic.jump({ count = 1 })
end)
map("n", "]d", function()
	vim.diagnostic.jump({ count = -1 })
end)
map("n", "[c", "<cmd>cnext<cr>")
map("n", "]c", "<cmd>cprev<cr>")
map("n", "<space>ld", function()
	vim.diagnostic.setqflist()
end)
