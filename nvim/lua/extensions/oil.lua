local detail = false

local function input_archive_name(default_name, extension, callback)
	local width = math.min(math.max(#default_name + 2, 40), math.max(vim.o.columns - 4, 20))
	local bufnr = vim.api.nvim_create_buf(false, true)
	local winid = vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		width = width,
		height = 1,
		row = math.floor((vim.o.lines - 3) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " Archive name ",
	})

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { default_name })
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].bufhidden = "wipe"
	local dot_col = #default_name - #extension - 1
	vim.api.nvim_win_set_cursor(winid, { 1, math.max(dot_col, 0) })

	local function close()
		if vim.api.nvim_win_is_valid(winid) then
			vim.api.nvim_win_close(winid, true)
		end
	end

	local function confirm()
		local archive_name = vim.trim(vim.api.nvim_get_current_line())
		close()
		callback(archive_name)
	end

	local function cancel()
		close()
		callback(nil)
	end

	vim.keymap.set({ "i", "n" }, "<CR>", confirm, { buffer = bufnr, nowait = true })
	vim.keymap.set({ "i", "n" }, "<Esc>", cancel, { buffer = bufnr, nowait = true })
	vim.keymap.set({ "i", "n" }, "<C-c>", cancel, { buffer = bufnr, nowait = true })
	vim.cmd.startinsert()
end

local function oil_archive_selected()
	local oil = require("oil")
	local current_dir = oil.get_current_dir()
	if not current_dir then
		vim.notify("Cannot archive: not in a local directory", vim.log.levels.WARN)
		return
	end

	local entries = {}
	local range = require("oil.util").get_visual_range()
	if range then
		for lnum = range.start_lnum, range.end_lnum do
			local entry = oil.get_entry_on_line(0, lnum)
			if entry and entry.name ~= ".." then
				table.insert(entries, entry)
			end
		end
	else
		local entry = oil.get_cursor_entry()
		if entry and entry.name ~= ".." then
			table.insert(entries, entry)
		end
	end

	if #entries == 0 then
		vim.notify("No Oil entries selected to archive", vim.log.levels.WARN)
		return
	end

	local archive_base = entries[1].name
	if #entries > 1 then
		archive_base = vim.fn.fnamemodify(current_dir:gsub("/$", ""), ":t")
		if archive_base == "" then
			archive_base = "archive"
		end
	end

	local formats = {
		{
			name = "tar.gz",
			extension = "tar.gz",
			command = function(archive_name)
				return { "tar", "-czf", archive_name, "--" }
			end,
		},
		{
			name = "7z",
			extension = "7z",
			command = function(archive_name)
				return { "7z", "a", archive_name, "--" }
			end,
		},
		{
			name = "zip",
			extension = "zip",
			command = function(archive_name)
				return { "zip", "-r", archive_name, "--" }
			end,
		},
		{
			name = "tar.bz",
			extension = "tar.bz",
			command = function(archive_name)
				return { "tar", "-cjf", archive_name, "--" }
			end,
		},
		{
			name = "tar.xz",
			extension = "tar.xz",
			command = function(archive_name)
				return { "tar", "-cJf", archive_name, "--" }
			end,
		},
	}

	vim.ui.select(formats, {
		prompt = "Archive format",
		format_item = function(format)
			return format.name
		end,
	}, function(format)
		if not format then
			return
		end

		local uv = vim.uv or vim.loop
		local function joinpath(dir, name)
			return dir:gsub("/$", "") .. "/" .. name
		end

		local archive_name = archive_base .. "." .. format.extension
		local archive_path = joinpath(current_dir, archive_name)
		local index = 1
		while uv.fs_stat(archive_path) do
			archive_name = string.format("%s-%d.%s", archive_base, index, format.extension)
			archive_path = joinpath(current_dir, archive_name)
			index = index + 1
		end

		input_archive_name(archive_name, format.extension, function(input_name)
			if not input_name then
				return
			end
			if input_name == "" then
				vim.notify("Archive name cannot be empty", vim.log.levels.WARN)
				return
			end
			archive_name = input_name
			archive_path = joinpath(current_dir, archive_name)
			if uv.fs_stat(archive_path) then
				vim.notify("Archive already exists: " .. archive_name, vim.log.levels.WARN)
				return
			end

			local cmd = format.command(archive_name)
			for _, entry in ipairs(entries) do
				table.insert(cmd, entry.name)
			end

			vim.system(cmd, { cwd = current_dir, text = true }, function(result)
				vim.schedule(function()
					if result.code == 0 then
						require("oil.actions").refresh.callback()
						vim.notify("Created archive: " .. archive_name, vim.log.levels.INFO)
					else
						local message = vim.trim(result.stderr ~= "" and result.stderr or result.stdout)
						if message == "" then
							message = cmd[1] .. " exited with code " .. result.code
						end
						vim.notify("Failed to create archive: " .. message, vim.log.levels.ERROR)
					end
				end)
			end)
		end)
	end)
end

require("oil").setup({
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	columns = {
		"icon",
	},
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-s>"] = { "actions.select", opts = { vertical = true } },
		["<C-t>"] = { "actions.select", opts = { tab = true } },
		["<C-p>"] = "actions.preview",
		["<C-l>"] = "actions.refresh",
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["`"] = { "actions.cd", mode = "n" },
		["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
		["ga"] = {
			desc = "Create tar.gz archive",
			callback = oil_archive_selected,
			mode = { "n", "x" },
		},
		["gh"] = {
			desc = "Open home directory",
			callback = function()
				require("oil").open(vim.fn.expand("~"))
			end,
			mode = "n",
		},
		["gd"] = {
			desc = "Toggle file detail view",
			callback = function()
				detail = not detail
				if detail then
					require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
				else
					require("oil").set_columns({ "icon" })
				end
			end,
		},
	},
	use_default_keymaps = false,
	float = {
		max_width = 0.3,
		max_height = 0.6,
		border = "rounded",
	},
	skip_confirm_for_simple_edits = true,
})

vim.keymap.set("n", "<leader>pv", "<cmd>Oil<cr>")
