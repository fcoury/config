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
		-- { "<leader>e", mode = { "n" }, ":Neotree filesystem reveal left<CR>", desc = "Open file tree", silent = true },
	},
	config = function()
		require("neo-tree").setup({
			window = {
				position = "left",
				width = 30,
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
				},
			},
			buffers = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
			},
			-- look and feel
			default_component_configs = {
				git_status = {
					symbols = {
						-- Change type
						added = "✚", -- NOTE: you can set any of these to an empty string to not show them
						deleted = "✖",
						modified = "",
						renamed = "",
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "",
						staged = "",
						conflict = "",
					},
					align = "right",
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

				{
					event = "neo_tree_popup_input_ready",
					---@param args { bufnr: integer, winid: integer }
					handler = function(args)
						vim.cmd("stopinsert")
						vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
					end,
				},
			},
		})
	end,
}
