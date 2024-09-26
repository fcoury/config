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

		vim.keymap.set("n", "<leader>io", neogit.open)
		vim.keymap.set("n", "<leader>ic", ":Neogit commit<CR>")
		vim.keymap.set("n", "<leader>ip", ":Neogit push<CR>")
		vim.keymap.set("n", "<leader>iP", ":Neogit pull<CR>")
		vim.keymap.set("n", "<leader>ib", ":Telescope git_branches<CR>")
	end,
}
