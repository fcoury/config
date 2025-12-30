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
	opts = {},
	config = function(_, opts)
		-- Configure navic to handle LSP reattachments gracefully
		require("nvim-navic").setup({
			lsp = {
				auto_attach = true,
				preference = nil, -- no preference, attach to first available
			},
			highlight = true,
			safe_output = true, -- prevents errors from breaking the winbar
		})
		require("barbecue").setup(opts)
	end,
}
