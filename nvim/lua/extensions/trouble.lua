local trouble = require("trouble")
local map = vim.keymap.set

trouble.setup()

map("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>")
map("n", "[t", function()
	trouble.next({ skip_groups = true, jump = true })
end)
map("n", "]t", function()
	trouble.previous({ skip_groups = true, jump = true })
end)
