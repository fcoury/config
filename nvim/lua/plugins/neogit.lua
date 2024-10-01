return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local neogit = require("neogit")

		neogit.setup({
			integrations = {
				diffview = true,
			},
		})

		vim.keymap.set("n", "<leader>io", neogit.open, { desc = "Open Neogit" })
		vim.keymap.set("n", "<leader>ic", ":Neogit commit<CR>", { desc = "Git commit" })
		vim.keymap.set("n", "<leader>ip", ":Neogit push<CR>", { desc = "Git push" })
		vim.keymap.set("n", "<leader>iP", ":Neogit pull<CR>", { desc = "Git pull" })
		vim.keymap.set("n", "<leader>ib", ":Telescope git_branches<CR>", { desc = "Git branches" })
	end,
}
