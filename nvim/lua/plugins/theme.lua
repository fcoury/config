-- nightfox
-- return {
-- 	"EdenEast/nightfox.nvim",
-- 	init = function()
-- 		vim.cmd("colorscheme terafox")
-- 	end,
-- }

-- rose-pine
-- return { "rose-pine/neovim", as = "rose-pine" }

-- gruvbox
-- return {
-- 	"morhetz/gruvbox",
-- 	lazy = false,
-- 	init = function()
-- 		vim.cmd("colorscheme gruvbox")
-- 	end,
-- }

-- lackluster
return {
	"slugbyte/lackluster.nvim",
	lazy = false,
	priority = 1000,
	init = function()
		-- vim.cmd.colorscheme("lackluster")
		vim.cmd.colorscheme("lackluster")
		-- vim.cmd.colorscheme("lackluster-mint")
		-- vim.cmd.colorscheme("lackluster-night")
	end,
}

-- kanagawa
-- return {
-- 	"rebelot/kanagawa.nvim",
-- 	lazy = false,
-- 	config = function()
-- 		require("kanagawa").setup()
-- 		vim.cmd.colorscheme("kanagawa-dragon")
-- 	end,
-- }

-- catpuccin
-- return {
-- 	"catppuccin/nvim",
-- 	lazy = false,
-- 	name = "catppuccin",
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd.colorscheme("catppuccin-mocha")
-- 	end,
-- }
