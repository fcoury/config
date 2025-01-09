-- enables global and treesitter based folding
return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	keys = {
		{
			"zR",
			"<cmd>lua require('ufo').openAllFolds()<cr>",
			mode = "n",
			desc = "Open all folds",
		},
		{
			"zM",
			"<cmd>lua require('ufo').closeAllFolds()<cr>",
			mode = "n",
			desc = "Close all folds",
		},
	},
	config = function()
		vim.o.foldcolumn = "0" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		require("ufo").setup({
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
		})
	end,
}
