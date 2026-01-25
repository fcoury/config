return {
	"coffebar/neovim-project",
	cond = not vim.g.neovide,
	opts = {
		projects = { -- define project roots
			"~/code/*",
			"~/code-external/*",
			"~/.config/*",
		},
	},
	init = function()
		-- enable saving the state of plugins in the session
		vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
	end,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "Shatur/neovim-session-manager" },
	},
	lazy = false,
	priority = 100,
}
