-- display git changes in the sign column
return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			current_line_blame = false,
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				-- map("n", "]c", function()
				-- 	if vim.wo.diff then
				-- 		return "]c"
				-- 	end
				-- 	vim.schedule(function()
				-- 		gs.next_hunk()
				-- 	end)
				-- 	return "<Ignore>"
				-- end, { expr = true })
				--
				-- map("n", "[c", function()
				-- 	if vim.wo.diff then
				-- 		return "[c"
				-- 	end
				-- 	vim.schedule(function()
				-- 		gs.prev_hunk()
				-- 	end)
				-- 	return "<Ignore>"
				-- end, { expr = true })

				-- Actions
				-- re-enabled 01-31-2026 harpoon is gone
				-- disabled 09-14-2024 due to conflict with Harpoon
				map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
				map({ "n", "v" }, "<leader>hr", ":Gitsigns stage_hunk<CR>")
				map("n", "<leader>hS", gs.stage_buffer)
				map("n", "<leader>ha", gs.stage_hunk)
				map("n", "<leader>hu", gs.undo_stage_hunk)
				map("n", "<leader>hR", gs.reset_buffer)
				map("n", "<leader>hp", gs.preview_hunk)
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end)
				map("n", "<leader>tB", gs.toggle_current_line_blame)
				map("n", "<leader>hd", gs.diffthis)
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end)

				-- Text objects
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		})
	end,
}
