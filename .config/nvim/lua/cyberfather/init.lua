require("cyberfather.set")
require("cyberfather.remap")

require("cyberfather.lazy_init")

local augroup = vim.api.nvim_create_augroup
local CyberFatherRTGroup = augroup("CyberFatherRT", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = CyberFatherRTGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
	group = CyberFatherRTGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
	end,
})

autocmd("BufRead", {
	group = CyberFatherRTGroup,
	pattern = "go.mod",
	callback = function()
		vim.opt.filetype = "gomod"
	end,
})

for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
	vim.api.nvim_set_hl(0, group, {})
end

vim.loader.enable()

vim.keymap.set("n", "<C-s><C-s>", "<cmd>S3Edit<cr>")
vim.keymap.set("n", "<M-j>", "<cmd>cnext<cr>")

-- Lua function to manually match YAML content with Dockerfile highlights
-- Prerequisite: Your Neovim setup is already configured with Tree-sitter and the necessary parsers.

local utils = require("nvim-treesitter.ts_utils")

local function highlight_dockerfile()
	-- Fetch current buffer and ensure it's a YAML file.
	local bufnr = vim.api.nvim_get_current_buf()

	-- Get the tree-sitter parser for YAML
	local parser = vim.treesitter.get_parser(bufnr, "yaml")
	local tree = parser:parse()[1]
	local lang_tree = tree:root()

	-- Traversing the tree to find the 'content' node
	local function find_content_node(node)
		for child in node:iter_children() do
			if child:type() == "block_node" then
				for subchild in child:iter_children() do
					if subchild:type() == "block_mapping_pair" then
						local key_node = subchild:named_child(0)
						if key_node and utils.get_node_text(key_node, bufnr)[1] == "content" then
							return subchild:named_child(1)
						end
					end
				end
			end
		end
	end

	-- Get the content node
	local content_node = find_content_node(lang_tree)

	-- If we found the content node, apply Dockerfile highlighting
	if content_node then
		local start_row, start_col, end_row, end_col = content_node:range()

		-- Set tree-sitter Dockerfile highlighting over the specified range
		vim.treesitter.highlighter.new(bufnr, lang_tree, { "dockerfile" }, {
			start_row = start_row,
			start_col = start_col,
			end_row = end_row,
			end_col = end_col,
		})
	end
end

-- Command to invoke the function
vim.api.nvim_create_user_command("HighlightDockerfile", highlight_dockerfile, {})

-- Automatically highlight Dockerfile when opening a YAML file
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*.yaml",
	callback = function()
		highlight_dockerfile()
	end,
})

local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		require("go.format").goimports()
	end,
	group = format_sync_grp,
})

vim.api.nvim_create_augroup("YamlIndent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "YamlIndent",
	pattern = "yaml",
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.expandtab = true
	end,
})

vim.api.nvim_create_augroup("HelmIndent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "HelmIndent",
	pattern = "helm",
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.expandtab = true
	end,
})
