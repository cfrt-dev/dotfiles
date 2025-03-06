return {
	"mrcjkb/rustaceanvim",
	-- version = "^4", -- Recommended
	lazy = false, -- This plugin is already lazy
	config = function()
		vim.g.rustaceanvim = {
			server = {
				cmd = function()
					local mason_registry = require("mason-registry")
					local ra_binary = mason_registry.is_installed("rust-analyzer")
							-- This may need to be tweaked, depending on the operating system.
							and mason_registry.get_package("rust-analyzer"):get_install_path() .. "/rust-analyzer"
						or "rust-analyzer"
					return { ra_binary } -- You can add args to the list, such as '--log-file'
				end,
			},
		}
		local bufnr = vim.api.nvim_get_current_buf()
		vim.keymap.set("n", "<leader>vca", function()
			vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
			-- or vim.lsp.buf.codeAction() if you don't want grouping.
		end, { silent = true, buffer = bufnr })
	end,
}
