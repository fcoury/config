-- A tiny Neovim plugin that adds subtle animations to yank operations.
return {
	"rachartier/tiny-glimmer.nvim",
	event = "TextYankPost",
	opts = {
		-- your configuration
	},
}
