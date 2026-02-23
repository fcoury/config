local local_path = vim.fn.expand("~/code-external/fff.nvim")
local use_local = vim.fn.isdirectory(local_path) == 1

return {
	"dmtrKovalenko/fff.nvim",
	dir = use_local and local_path or nil,
	build = not use_local and function()
		require("fff.download").download_or_build_binary()
	end or nil,
	lazy = false,
	keys = {
		{
			"<leader>g",
			function()
				require("fff").live_grep()
			end,
			desc = "Live grep (fff)",
		},
	},
}
