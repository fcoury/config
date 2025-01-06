return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim",
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
			-- auto close file on selection
			event_handlers = {
				{
					event = "file_open_requested",
					handler = function()
						-- auto close
						-- vim.cmd("Neotree close")
						-- OR
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		})
	end,
}
