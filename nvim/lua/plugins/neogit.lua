return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{ "<leader>io", mode = { "n" }, ":Neogit<CR>", desc = "Open Neogit", silent = true },
		{ "<leader>ic", mode = { "n" }, ":Neogit commit<CR>", desc = "Git commit", silent = true },
		{ "<leader>ip", mode = { "n" }, ":Neogit push<CR>", desc = "Git push", silent = true },
		{ "<leader>iP", mode = { "n" }, ":Neogit pull<CR>", desc = "Git pull", silent = true },
		{
			"<leader>ib",
			mode = { "n" },
			":Telescope git_branches<CR>",
			desc = "Git branches",
			silent = true,
		},
	},
	config = true,
}
