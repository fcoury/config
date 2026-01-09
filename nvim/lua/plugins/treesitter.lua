return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- nvim-treesitter doesn't support lazy loading
		build = ":TSUpdate",
		dependencies = {
			"axelvc/template-string.nvim",
		},
		config = function()
			-- New nvim-treesitter API - just handles parser installation
			-- Highlighting, indentation, and folds are now built into Neovim
			local ts = require("nvim-treesitter")

			-- Install parsers (async, will run in background)
			ts.install({
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
			})

			-- Enable treesitter highlighting for all supported filetypes
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					-- Check if treesitter parser exists for this filetype
					local ok = pcall(vim.treesitter.start, args.buf)
					if not ok then return end
				end,
			})

			require("template-string").setup({})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "V",
					},
				},
			})

			-- Select keymaps
			vim.keymap.set({ "x", "o" }, "am", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@call.outer", "textobjects")
			end, { desc = "Select outer part of a function call" })
			vim.keymap.set({ "x", "o" }, "im", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@call.inner", "textobjects")
			end, { desc = "Select inner part of a function call" })
			vim.keymap.set({ "x", "o" }, "af", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end, { desc = "Select outer part of a function" })
			vim.keymap.set({ "x", "o" }, "if", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end, { desc = "Select inner part of a function" })
			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end, { desc = "Select outer part of a class" })
			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end, { desc = "Select inner part of a class" })
			vim.keymap.set({ "x", "o" }, "ak", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects")
			end, { desc = "Select outer part of a comment" })
			vim.keymap.set({ "x", "o" }, "ik", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@comment.inner", "textobjects")
			end, { desc = "Select inner part of a comment" })

			-- Swap keymaps
			vim.keymap.set("n", "<leader>na", function()
				require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
			end, { desc = "Swap parameter with next" })
			vim.keymap.set("n", "<leader>pa", function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
			end, { desc = "Swap parameter with previous" })
			vim.keymap.set("n", "<leader>nm", function()
				require("nvim-treesitter-textobjects.swap").swap_next("@function.outer")
			end, { desc = "Swap function with next" })
			vim.keymap.set("n", "<leader>pm", function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@function.outer")
			end, { desc = "Swap function with previous" })

			-- Move keymaps
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@call.outer", "textobjects")
			end, { desc = "Next function call start" })
			vim.keymap.set({ "n", "x", "o" }, "]f", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next function def start" })
			vim.keymap.set({ "n", "x", "o" }, "]c", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
			end, { desc = "Next class start" })
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@call.outer", "textobjects")
			end, { desc = "Previous function call start" })
			vim.keymap.set({ "n", "x", "o" }, "[f", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Previous function def start" })
			vim.keymap.set({ "n", "x", "o" }, "[c", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
			end, { desc = "Previous class start" })
		end,
	},
}
