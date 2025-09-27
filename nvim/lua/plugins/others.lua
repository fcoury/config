return {
	-- https://github.com/mg979/vim-visual-multi
	-- Multiple cursors plugin for vim/neovim
	"mg979/vim-visual-multi",

	-- https://github.com/lukas-reineke/indent-blankline.nvim
	-- Indent guides for Neovim
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		cond = not_vscode,
		opts = {
			indent = {
				char = "│", -- Character to use for indent lines
				highlight = { "IblIndent" }, -- Highlight group
			},
			scope = {
				highlight = { "IblScope" }, -- Highlight group for scope
			},
		},
	},

	-- https://github.com/romainl/vim-cool
	-- A very simple plugin that makes hlsearch more useful.
	{ "romainl/vim-cool", lazy = false },

	-- https://github.com/Zeioth/garbage-day.nvim
	-- Garbage collector that stops inactive LSP clients to free RAM
	-- {
	-- 	"zeioth/garbage-day.nvim",
	-- 	dependencies = "neovim/nvim-lspconfig",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		-- your options here
	-- 	},
	-- },
}
