return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("rustaceanvim.neotest"),
			},
			log_level = vim.log.levels.DEBUG,
			log_file = vim.fn.stdpath("data") .. "/neotest.log",
		})

		-- keybindings
		vim.api.nvim_set_keymap("n", "<leader>tu", "<cmd>Neotest summary<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>tn", "<cmd>Neotest run<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap(
			"n",
			"<leader>tf",
			"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>ta",
			"<cmd>lua require('neotest').run.attach()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>tp",
			"<cmd>lua require('neotest').run.last()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap("n", "<leader>to", "<cmd>Neotest output<CR>", { noremap = true, silent = true })
	end,
}
