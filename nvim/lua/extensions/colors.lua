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
