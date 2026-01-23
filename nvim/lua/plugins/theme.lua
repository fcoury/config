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
	{ "fcancelinha/nordern.nvim", branch = "master", priority = 1000 },
	{ "rmehri01/onenord.nvim" },
	{ "catppuccin/nvim" },
	{ "yorumicolors/yorumi.nvim" },
	{
		"baliestri/aura-theme",
		lazy = false,
		priority = 1000,
		config = function(plugin)
			vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
		end,
	},
	{
		"uloco/bluloco.nvim",
		lazy = false,
		priority = 1000,
		dependencies = { "rktjmp/lush.nvim" },
	},
	{
		"zenbones-theme/zenbones.nvim",
		dependencies = "rktjmp/lush.nvim",
		lazy = false,
		priority = 1000,
	},
	{ "nyoom-engineering/oxocarbon.nvim" },
	{ "bluz71/vim-moonfly-colors" },
	{ "bluz71/vim-nightfly-colors" },
	{ "Shatur/neovim-ayu" },
	{ "ribru17/bamboo.nvim" },
	-- from this reddit discussion:
	-- https://www.reddit.com/r/neovim/comments/1hnfvk5/comment/m41bzyk/?context=3&share_id=A_1wRGroXytW-uBkw54s6&utm_medium=ios_app&utm_name=ioscss&utm_source=share&utm_term=10
	{ "gbprod/nord.nvim" },
	{ "sam4llis/nvim-tundra" },
	{ "ramojus/mellifluous.nvim" },
	{ "wtfox/jellybeans.nvim" },
	{ "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
	{
		"tahayvr/matteblack.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("matteblack")
		end,
	},
	{ "datsfilipe/vesper.nvim" },
	{
		"oskarnurm/koda.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- require("koda").setup({ transparent = true })
			vim.cmd("colorscheme koda")
		end,
	},
	{
		"webhooked/kanso.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanso").setup({})
		end,
	},
	-- Popular themes
	{ "navarasu/onedark.nvim" },
	{ "Mofiqul/dracula.nvim" },
	{ "craftzdog/solarized-osaka.nvim" },
	{ "projekt0n/github-nvim-theme" },
	{ "scottmckendry/cyberdream.nvim" },
	{ "olivercederborg/poimandres.nvim" },
	{ "maxmx03/fluoromachine.nvim" },
	{ "Mofiqul/vscode.nvim" },
	{ "sainnhe/sonokai" },
	{ "sainnhe/edge" },
	{ "oxfist/night-owl.nvim" },
	{ "Hiroya-W/sequoia-moonlight.nvim" },
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
					"vesper",
					"nord",
					"nordic",
					"nordern",
					"onenord",
					"zenbones",
					"zenwritten",
					"neobones",
					"rosebones",
					"forestbones",
					"nordbones",
					"seoulbones",
					"duckbones",
					"zenburned",
					"kanagawabones",
					"bamboo",
					"bluloco-dark",
					"bluloco-light",
					"aura-dark",
					"aura-dark-soft-text",
					"aura-soft-dark",
					"aura-soft-dark-soft-text",
					"oxocarbon",
					"moonfly",
					"nightfly",
					"yorumi",
					"iceberg",
					"everforest",
					"kanagawa",
					"kanagawa-dragon",
					"kanagawa-wave",
					"kanagawa-lotus",
					"nightfox",
					"terafox",
					"tokyonight",
					"tokyonight-night",
					"tokyonight-storm",
					"tokyonight-moon",
					"rose-pine-main",
					"rose-pine-dawn",
					"rose-pine-moon",
					"gruvbox",
					"catppuccin-mocha",
					"catppuccin-macchiato",
					"catppuccin-frappe",
					"catppuccin-latte",
					"tundra",
					"mellifluous",
					"jellybeans",
					"jellybeans-muted",
					"jellybeans-mono",
					"matteblack",
					"koda",
					{
						name = "kanso",
						colorscheme = "kanso",
						before = [[
							require("kanso").setup({})
						]],
					},
					-- onedark
					"onedark",
					-- dracula
					"dracula",
					"dracula-soft",
					-- solarized-osaka
					"solarized-osaka",
					"solarized-osaka-day",
					-- github
					"github_dark",
					"github_dark_default",
					"github_dark_dimmed",
					"github_dark_high_contrast",
					"github_light",
					"github_light_default",
					-- cyberdream
					"cyberdream",
					-- poimandres
					"poimandres",
					-- fluoromachine
					"fluoromachine",
					-- vscode
					"vscode",
					-- sonokai
					"sonokai",
					-- edge
					"edge",
					-- night-owl
					"night-owl",
					-- sequoia-moonlight
					"sequoia",
					-- custom poimandres based on ghostty theme
					"poimandres-ghostty",
				},
				livePreview = true,
			})

			-- Always removes the background color of inlay hints
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					vim.api.nvim_set_hl(0, "LspInlayHint", {
						fg = vim.api.nvim_get_hl_by_name("LspInlayHint", true).foreground, -- Retain the current foreground color
						bg = "NONE", -- Set background to NONE for transparency
						blend = vim.api.nvim_get_hl_by_name("LspInlayHint", true).blend, -- Retain the current blend value
					})
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
