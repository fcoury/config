return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		vim.keymap.set("n", "]t", function()
			require("todo-comments").jump_next()
		end)

		vim.keymap.set("n", "[t", function()
			require("todo-comments").jump_prev()
		end)

		vim.keymap.set("n", "<leader>td", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })

		require("todo-comments").setup()
	end,
}
