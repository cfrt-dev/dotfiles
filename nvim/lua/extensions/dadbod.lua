vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_disable_info_notifications = 1

vim.keymap.set("n", "<leader>db", "<cmd>DBUIToggle<CR>", {
	desc = "Toggle Dadbod UI",
})

local function load_dadbod_ui()
	vim.cmd.packadd("vim-dadbod")
	vim.cmd.packadd("vim-dadbod-ui")
	vim.cmd.packadd("vim-dadbod-completion")
end

for _, cmd in ipairs({
	"DBUI",
	"DBUIToggle",
	"DBUIAddConnection",
	"DBUIFindBuffer",
}) do
	vim.api.nvim_create_user_command(cmd, function(opts)
		load_dadbod_ui()

		vim.cmd(cmd .. " " .. table.concat(opts.fargs, " "))
	end, {
		nargs = "*",
		complete = "file",
	})
end
