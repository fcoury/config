return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {
		-- Sessions stored per directory + git branch
		branch = true,
	},
	init = function()
		-- Auto-restore session when opening nvim without file arguments
		vim.api.nvim_create_autocmd("VimEnter", {
			nested = true,
			callback = function()
				-- Only restore if no files were passed as arguments
				if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
					require("persistence").load()
				end
			end,
		})
		-- Detect if stdin was used
		vim.api.nvim_create_autocmd("StdinReadPre", {
			callback = function()
				vim.g.started_with_stdin = true
			end,
		})
	end,
	keys = {
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Restore session (current dir)",
		},
		{
			"<leader>qS",
			function()
				require("persistence").select()
			end,
			desc = "Select session",
		},
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore last session",
		},
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "Stop session saving",
		},
	},
}
