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
