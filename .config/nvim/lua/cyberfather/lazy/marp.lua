return {
	"mpas/marp-nvim",
	config = function()
		require("marp").setup({
			port = 9523,
			wait_for_response_timeout = 30,
			wait_for_response_delay = 1,
		})
	end,
}
