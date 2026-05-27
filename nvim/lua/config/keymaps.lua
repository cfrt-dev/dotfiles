local map = vim.keymap.set

map("i", "<C-u>", "<nop>")
map("i", "<C-c>", "<Esc>")

map({ "n", "v" }, "<C-w>s", "<cmd>vsplit<CR>")
map({ "n", "v" }, "<C-w>e", "<cmd>split<CR>")
map("n", "<C-w>n", "<cmd>tabnext<cr>")
map("n", "<C-w>p", "<cmd>tabprev<cr>")
map("n", "<C-w>-", "<nop>")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<leader>T", "<cmd>tabnew<CR>")
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

for i = 1, 8 do
	map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end

map("n", "<leader>st", function()
	local bufname = vim.api.nvim_buf_get_name(0)
	local ssh_cmd
	local ssh_path
	if vim.startswith(bufname, "oil-ssh://") then
		local ok, url = pcall(require("oil.adapters.ssh").parse_url, bufname)
		if ok then
			ssh_cmd = require("oil.adapters.ssh.connection").create_ssh_command(url)
			ssh_path = url.path
		else
			vim.notify(url, vim.log.levels.ERROR)
			return
		end
	end

	vim.cmd.vnew()
	if ssh_cmd then
		local term_id = vim.fn.jobstart(ssh_cmd, { term = true })
		if term_id <= 0 then
			vim.notify("Failed to start ssh terminal", vim.log.levels.ERROR)
			return
		end
		if ssh_path and ssh_path ~= "" then
			vim.api.nvim_chan_send(term_id, string.format("cd %s\n", vim.fn.shellescape(ssh_path)))
		end
	else
		vim.cmd.term()
	end
	vim.cmd.startinsert()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 15)
end)
