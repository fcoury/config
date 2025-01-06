return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	keys = {
		{ "<C-e>", mode = { "n" }, ":Neotree filesystem toggle left<CR>", desc = "Toggle file tree", silent = true },
		{ "<leader>e", mode = { "n" }, ":Neotree filesystem reveal left<CR>", desc = "Open file tree", silent = true },
	},
	config = function()
		require("neo-tree").setup({
			window = {
				width = 35,
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
			},
			buffers = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
			},
		})
	end,
}
