return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = false,
			},
			indent = {
				enable = true,
				priority = 10,
				style = { vim.api.nvim_get_hl(0, { name = "Whitespace" }) },
				use_treesitter = false,
				chars = {
					"│",
				},
				ahead_lines = 50,
				delay = 100,
			},
			line_num = {
				enable = true,
			},
			blank = {
				enable = true,
			},
		})
	end,
}
