return {
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("catppuccin-frappe")
		-- require("catppuccin").setup({
		-- 	flavor = "frappe",
		-- 	integrations = {
		-- 		cmp = true,
		-- 		gitsigns = true,
		-- 		nvimtree = true,
		-- 		treesitter = true,
		-- 		fidget = true,
		-- 	},
		-- })
	end,
}
