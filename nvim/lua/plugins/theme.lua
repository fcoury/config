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

return {
	-- lackluster
	{
		"slugbyte/lackluster.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			-- vim.cmd.colorscheme("lackluster")
			-- vim.cmd.colorscheme("lackluster")
			-- vim.cmd.colorscheme("lackluster-mint")
			-- vim.cmd.colorscheme("lackluster-night")
		end,
	},
	{ "cocopon/iceberg.vim" },
	{ "sainnhe/everforest" },
	{ "rebelot/kanagawa.nvim" },
	{ "EdenEast/nightfox.nvim" },
	{ "rose-pine/neovim", as = "rose-pine" },
	{ "morhetz/gruvbox" },
	{ "AlexvZyl/nordic.nvim" },
	{ "catppuccin/nvim" },
	{
		"zaldih/themery.nvim",
		lazy = false,
		config = function()
			require("themery").setup({
				themes = {
					"lackluster",
					"lackluster-dark",
					"lackluster-hack",
					"lackluster-mint",
					"lackluster-night",
					"iceberg",
					"everforest",
					"kanagawa",
					"kanagawa-dragon",
					"kanagawa-wave",
					"kanagawa-lotus",
					"nightfox",
					"terafox",
					"rose-pine-main",
					"rose-pine-dawn",
					"rose-pine-moon",
					"nordic",
					"gruvbox",
					"catppuccin-mocha",
					"catppuccin-frappe",
					"catppuccin-macchiato",
					"catppuccin-latte",
				},
				livePreview = true,
			})

			-- 		vim.api.nvim_create_autocmd("ColorScheme", {
			-- 			pattern = "*",
			-- 			callback = function()
			-- 				vim.api.nvim_set_hl(0, "LspInlayHint", {
			-- 					fg = vim.api.nvim_get_hl_by_name("LspInlayHint", true).foreground, -- Retain the current foreground color
			-- 					bg = "NONE", -- Set background to NONE for transparency
			-- 					blend = vim.api.nvim_get_hl_by_name("LspInlayHint", true).blend, -- Retain the current blend value
			-- 				})
			-- 			end,
			-- 		})

			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					local current_colorscheme = vim.g.colors_name or ""
					if current_colorscheme:match("^rose%-pine") then
						vim.api.nvim_set_hl(0, "LspInlayHint", {
							fg = "#6e6a86", -- Keep the original foreground color
							bg = "NONE", -- Set background to NONE for transparency
							blend = 10, -- Keep the original blend value
						})
					end
				end,
			})
		end,
	},
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
