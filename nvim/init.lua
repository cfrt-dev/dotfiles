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
		["*"] = { "codespell" },
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
		-- vim.wo.wrap = true
	end,
})

map("n", "<space>st", function()
	vim.cmd.vnew()
	vim.cmd.term()
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
