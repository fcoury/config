-- shows breadcrumbs in the statusline
return {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	cond = not_vscode,
	version = "*",
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		-- configurations go here
	},
}
