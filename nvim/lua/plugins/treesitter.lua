return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"axelvc/template-string.nvim",
		"nvim-treesitter/nvim-treesitter-textobjects",
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
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				-- This is the critical line that is now in the single, correct config
				disable = { "husk" },
			},
			indent = { enable = true },

			-- Configuration moved from the old treesitter-textobjects.lua file
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["am"] = { query = "@call.outer", desc = "Select outer part of a function call" },
						["im"] = { query = "@call.inner", desc = "Select inner part of a function call" },
						["af"] = {
							query = "@function.outer",
							desc = "Select outer part of a method/function definition",
						},
						["if"] = {
							query = "@function.inner",
							desc = "Select inner part of a method/function definition",
						},
						["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
						["ak"] = { query = "@comment.outer", desc = "Select outer part of a comment" },
						["ik"] = { query = "@comment.inner", desc = "Select inner part of a comment" },
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
						["<leader>nm"] = "@function.outer", -- swap function with next
					},
					swap_previous = {
						["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
						["<leader>pm"] = "@function.outer", -- swap function with previous
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = { query = "@call.outer", desc = "Next function call start" },
						["]f"] = { query = "@function.outer", desc = "Next method/function def start" },
						["]c"] = { query = "@class.outer", desc = "Next class start" },
						["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
						["]l"] = { query = "@loop.outer", desc = "Next loop start" },
						["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["]M"] = { query = "@call.outer", desc = "Next function call end" },
						["]F"] = { query = "@function.outer", desc = "Next method/function def end" },
						["]C"] = { query = "@class.outer", desc = "Next class end" },
						["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
						["]L"] = { query = "@loop.outer", desc = "Next loop end" },
					},
					goto_previous_start = {
						["[m"] = { query = "@call.outer", desc = "Prev function call start" },
						["[f"] = { query = "@function.outer", desc = "Prev method/function def start" },
						["[c"] = { query = "@class.outer", desc = "Prev class start" },
						["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
						["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
					},
					goto_previous_end = {
						["[M"] = { query = "@call.outer", desc = "Prev function call end" },
						["[F"] = { query = "@function.outer", desc = "Prev method/function def end" },
						["[C"] = { query = "@class.outer", desc = "Prev class end" },
						["[I"] = { "@conditional.outer", desc = "Prev conditional end" },
						["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
					},
				},
			},
		})

		require("template-string").setup({})
	end,
}
