return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"]t",
			mode = "n",
			function()
				require("todo-comments").jump_next()
			end,
			desc = "Jump to next TODO",
		},
		{
			"[t",
			mode = "n",
			function()
				require("todo-comments").jump_prev()
			end,
			desc = "Jump to previous TODO",
		},
		{ "<leader>td", "<cmd>TodoTelescope<cr>", mode = "n", desc = "Search TODOs" },
	},
	config = function()
		require("todo-comments").setup()
	end,
}
