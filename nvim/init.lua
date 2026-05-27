vim.g.mapleader = " "
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.undofile = true
vim.opt.guicursor = ""
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.g.no_plugin_maps = true
vim.opt.scrolloff = 8

vim.pack.add({
	{ src = "https://github.com/tpope/vim-dadbod" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-completion" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-ui" },
	{ src = "https://github.com/cfrt-dev/rfc.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/mosheavni/yaml-companion.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/TheLeoP/powershell.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/dhruvasagar/vim-zoom" },
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/lewis6991/ts-install.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mbbill/undotree" },
	{ src = "https://github.com/mg979/vim-visual-multi" },
	{ src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("^9") },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/rose-pine/neovim" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/theprimeagen/harpoon" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/tpope/vim-surround" },
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/xiyaowong/transparent.nvim" },
})

require("ts-install").setup({
	auto_install = true,
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		if ft == "" then
			return
		end

		local lang = vim.treesitter.language.get_lang(ft)
		local ok, parsers = pcall(require, "nvim-treesitter.parsers")
		if not ok then
			return
		end
		if not parsers[lang] then
			return
		end

		pcall(vim.treesitter.start, args.buf, lang)
	end,
})

require("powershell").setup({
	bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
})
require("fidget").setup({})
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"buf",
		"clang-format",
		"clangd",
		"cssls",
		"docker_compose_language_service",
		"dockerls",
		"emmet_language_server",
		"emmet_ls",
		"gopls",
		"hlint",
		"lua_ls",
		"ols",
		"powershell_es",
		"pyright",
		"ruff",
		"svelte",
		"tailwindcss",
		"tinymist",
		"ts_ls",
		"yamlls",
		"sqruff",
	},
})

require("nvim-treesitter").setup({
	sync_install = false,
	auto_install = true,
	indent = {
		enable = true,
	},
	highlight = {
		enable = true,
	},
})
require("nvim-treesitter-textobjects").setup({
	select = {
		enable = true,
		lookahead = true,
		keymaps = {
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["at"] = "@comment.outer",
			["it"] = "@comment.inner",
			["al"] = "@loop.outer",
			["il"] = "@loop.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
		},
	},
})

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

local yaml_cfg = require("yaml-companion").setup({})
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

local map = vim.keymap.set

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

map("n", "<leader>u", vim.cmd.UndotreeToggle)
map("i", "<C-u>", "<nop>")

map("n", "<leader>a", mark.add_file)
map("n", "<C-e>", ui.toggle_quick_menu)
map("n", "<C-h>", function()
	ui.nav_file(1)
end)
map("n", "<C-j>", function()
	ui.nav_file(2)
end)
map("n", "<C-k>", function()
	ui.nav_file(3)
end)
map("n", "<C-l>", function()
	ui.nav_file(4)
end)

map("n", "<leader>f", "<cmd>:FormatWrite<cr>")
map("i", "<C-c>", "<Esc>")
map({ "n", "v" }, "<C-w>s", "<cmd>vsplit<CR>")
map({ "n", "v" }, "<C-w>e", "<cmd>split<CR>")
map("n", "<leader>pv", "<cmd>Oil<cr>")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<leader>T", "<cmd>tabnew<CR>")
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

map("n", "<C-w>n", "<cmd>tabnext<cr>")
map("n", "<C-w>p", "<cmd>tabprev<cr>")
map("n", "<C-w>-", "<nop>")

map("n", "<leader>gs", vim.cmd.Git)

vim.cmd.colorscheme("rose-pine")
require("tokyonight").setup({
	style = "storm",
	transparent = true,
	terminal_colors = true,
	styles = { sidebars = "dark", floats = "dark" },
})

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none", fg = "#89b4fa" })

for i = 1, 8 do
	map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end

local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
require("telescope").setup({
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
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
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

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<cr>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "vim-dadbod-completion" },
	}, {
		{ name = "buffer" },
	}),
})

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

map("n", "gd", vim.lsp.buf.definition)
map("n", "K", vim.lsp.buf.hover)
map("n", "<leader>vd", vim.diagnostic.open_float)
map("n", "<leader>vca", vim.lsp.buf.code_action)
map("n", "<leader>vrr", vim.lsp.buf.references)
map("n", "<leader>vrn", vim.lsp.buf.rename)
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

local trouble = require("trouble")
trouble.setup()

map("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>")
map("n", "[t", function()
	trouble.next({ skip_groups = true, jump = true })
end)
map("n", "]t", function()
	trouble.previous({ skip_groups = true, jump = true })
end)

local nvim_config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
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

local function pack_clean()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end
map("n", "<leader>pc", pack_clean)

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("cfrt", {})

autocmd("TextYankPost", {
	group = "cfrt",
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd("User", {
	pattern = "TelescopePreviewerLoaded",
	callback = function(_)
		vim.wo.number = true
	end,
})

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

require("rfc").setup()
map("n", "<leader>rf", "<cmd>RfcSearch<cr>")

vim.g.db_ui_use_nerd_fonts = 1

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
vim.g.db_ui_disable_info_notifications = 1
