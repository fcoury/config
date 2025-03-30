return {
	"folke/snacks.nvim",
	keys = {
		{
			"<C-p>",
			function()
				Snacks.picker.files({
					finder = "files",
					format = "file",
					show_empty = true,
					supports_live = true,
					-- In case you want to override the layout for this keymap
					-- layout = "vscode",
				})
			end,
			desc = "Find Files",
		},

		{
			"<leader>y",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},

		{
			"<leader>d",
			function()
				Snacks.picker.diagnostics()
			end,
		},

		{
			"<leader>e",
			function()
				Snacks.picker.diagnostics({
					severity = vim.diagnostic.severity.ERROR,
				})
			end,
			desc = "Errors",
		},

		{
			"<leader>k",
			function()
				Snacks.picker.lsp_references()
			end,
			desc = "Open references",
		},

		{
			"<C-t>",
			function()
				Snacks.picker.lsp_symbols()
			end,
		},

		{
			"<leader>g",
			function()
				Snacks.picker.grep()
			end,
			desc = "Find in Files",
		},

		{
			"<leader>,g",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},

		{
			"<leader>,b",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Git Branches",
		},

		{
			"<C-j>",
			function()
				Snacks.picker.buffers({
					-- buffers picker start in normal mode
					on_show = function()
						vim.cmd.stopinsert()
					end,
					sort_lastused = true,
					win = {
						input = {
							keys = {
								["d"] = "bufdelete",
							},
						},
						list = { keys = { ["d"] = "bufdelete" } },
					},
				})
			end,
			desc = "Open Buffers",
		},
	},
	opts = {
		picker = {
			win = {
				input = {
					keys = {
						-- to close the picker on ESC instead of going to normal mode,
						-- add the following keymap to your config
						["<Esc>"] = { "close", mode = { "n", "i" } },
						["<C-h>"] = { "history_back", mode = { "i", "n" } },
						["<C-l>"] = { "history_forward", mode = { "i", "n" } },
						-- I'm used to scrolling like this in LazyGit
						["J"] = { "preview_scroll_down", mode = { "i", "n" } },
						["K"] = { "preview_scroll_up", mode = { "i", "n" } },
						["H"] = { "preview_scroll_left", mode = { "i", "n" } },
						["L"] = { "preview_scroll_right", mode = { "i", "n" } },
					},
				},
			},
			formatters = {
				file = {
					filename_first = true, -- display filename before the file path
					truncate = 80,
				},
			},
		},
	},
}
