return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"axelvc/template-string.nvim",
	},
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {
				"lua",
				"tsx",
				"typescript",
				"javascript",
				"html",
				"css",
				"json",
				"yaml",
				"regex",
				"rust",
				"markdown",
				"markdown_inline",
			},
			sync_install = false,
			auto_install = true,
			highlight = { enable = true, additional_vim_regex_highlighting = false },
			indent = { enable = true },
			autotag = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<cr>",
					node_incremental = "<cr>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})

		require("template-string").setup({})

		-- fold
		local opt = vim.opt
		opt.foldmethod = "expr"
		opt.foldexpr = "nvim_treesitter#foldexpr()"
		opt.foldenable = false
	end,
}
