return {
	"mrjones2014/legendary.nvim",
	dependencies = {
		"hinell/duplicate.nvim",
	},
	priority = 10000,
	lazy = false,
	config = function()
		local legendary = require("legendary")
		require("legendary").setup({
			extensions = {
				lazy_nvim = true,
				-- smart_splits = {},
			},
		})

		-- we no longer use telescope
		-- local builtin = require("telescope.builtin")

		legendary.keymaps({
			-- remaps ; to act as :
			{ ";", ":", mode = "n", opts = { noremap = true }, description = "Remap ; to :" },

			-- toggle Legendary
			{ "<leader>,l", "<cmd>Legendary<cr>", mode = "n", description = "Toggle Legendary" },

			-- git
			{
				"<leader>tb",
				"<cmd>Gitsigns toggle_current_line_blame<cr>",
				mode = "n",
				description = "Toggle Git blame",
			},
			{ "<leader>,gs", "<cmd>Git<cr>", mode = "n", description = "Git commands" },

			-- select all
			{ "<leader>a", "ggVG", mode = "n", description = "Select all" },

			-- paste not overwritten by delete
			-- { "<leader>p", '"0p', mode = { "n", "x" }, description = "Paste and doesn't overwrite" },

			-- redo
			{ "U", "<C-r>", mode = "n", opts = { noremap = true }, description = "Redo" },

			-- move to beginning/end of line
			-- { "H", "^", mode = "n", opts = { noremap = true }, description = "Move to beginning of line" },
			-- { "L", "$", mode = "n", opts = { noremap = true }, description = "Move to end of line" },

			-- telescope
			-- { "<C-j>", "<cmd>Telescope buffers<cr>", mode = "n", description = "Open buffers" },
			-- { "<leader>b", "<cmd>Telescope buffers<cr>", mode = "n", description = "Open buffers" },
			-- { "<leader>d", "<cmd>Telescope diagnostics<cr>", mode = "n", description = "Open diagnostics" },
			-- {
			-- 	"<leader>e",
			-- 	function()
			-- 		builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR })
			-- 	end,
			-- 	mode = "n",
			-- 	description = "Open errors",
			-- },
			-- {
			-- 	"<leader>s",
			-- 	"<cmd>Telescope lsp_document_symbols<cr>",
			-- 	mode = "n",
			-- 	description = "Open document symbols",
			-- },
			-- {
			-- 	"<leader>w",
			-- 	"<cmd>Telescope lsp_workspace_symbols<cr>",
			-- 	mode = "n",
			-- 	description = "Open workspace symbols",
			-- },
			-- { "<leader>k", "<cmd>Telescope lsp_references<cr>", mode = "n", description = "Open references" },
			-- { "<C-t>", "<cmd>Telescope lsp_document_symbols<cr>", mode = "n", description = "Open document symbols" },

			-- lsp and rust
			{ "<leader>x", "<cmd>RustRunnables<cr>", mode = "n", description = "Run Rust runnables" },

			-- buffers
			{ "]b", "<cmd>bnext<cr>", mode = "n", description = "Next buffer" },
			{ "[b", "<cmd>bprevious<cr>", mode = "n", description = "Previous buffer" },
			{ "<leader><leader>", "<cmd>b#<cr>", mode = "n", description = "Switch to last buffer" },

			-- splits
			{ "|", "<cmd>vsplit<cr><c-w><c-w>", mode = "n", description = "Split vertically" },
			{ "_", "<cmd>split<cr>", mode = "n", description = "Split horizontally" },
			{ "=", "<cmd>wincmd =<cr>", mode = "n", description = "Balance splits" },

			-- lsp related
			{ "<leader>,d", "<cmd>DiagnosticToggle<cr>", mode = "n", description = "Toggle diagnostics" },

			-- special commands
			{
				"<leader>cl",
				"<cmd>CopyFileNameAndLine<cr>",
				mode = "n",
				opts = { noremap = true, silent = true },
				description = "Copy current file name and line number",
			},
			{
				"<leader>cf",
				"<cmd>CopyRelativePathAndLine<cr>",
				mode = "n",
				opts = { noremap = true, silent = true },
				description = "Copy current relative path, file name and line number",
			},

			-- delete text
			{ "m", '"_x', mode = "n", opts = { noremap = true, silent = true }, description = "Delete text" },
			{ "mm", '"_dd', mode = "n", opts = { noremap = true, silent = true }, description = "Delete line" },
			{ "m", '"_x', mode = "v", opts = { noremap = true, silent = true }, description = "Delete text" },
			{ "mw", '"_dw', mode = "n", opts = { noremap = true, silent = true }, description = "Delete word" },
			{ "miw", '"_diw', mode = "n", opts = { noremap = true, silent = true }, description = "Delete inner word" },
			-- {
			-- 	"viq",
			-- 	'vi"',
			-- 	mode = "n",
			-- 	opts = { noremap = true, silent = true },
			-- 	description = "Visual selection inside quotes",
			-- },
			-- { "diq", 'di"', mode = "n", opts = { noremap = true, silent = true }, description = "Delete inside quote" },
			-- { "ciq", 'ci"', mode = "n", opts = { noremap = true, silent = true }, description = "Change inside quote" },

			-- text objects
			-- deprecated in favor of mini.ai
			-- {
			-- 	"iq",
			-- 	":lua select_inside_quotes()<CR>",
			-- 	mode = { "x", "o" },
			-- 	description = "Select inside double quotes",
			-- },
			-- {
			-- 	"aq",
			-- 	":lua select_around_quotes()<CR>",
			-- 	mode = { "x", "o" },
			-- 	description = "Select around double quotes",
			-- },

			-- conditional move
			{
				"j",
				"v:lua.conditional_move_j()",
				mode = "n",
				opts = { expr = true, noremap = true },
				description = "Conditional move j",
			},
			{
				"k",
				"v:lua.conditional_move_k()",
				mode = "n",
				opts = { expr = true, noremap = true },
				description = "Conditional move k",
			},

			-- duplicate
			{
				description = "Line: duplicate up",
				mode = { "n" },
				"<S-A-Up>",
				"<CMD>LineDuplicate -1<CR>",
			},
			{
				description = "Line: duplicate down",
				mode = { "n" },
				"<S-A-Down>",
				"<CMD>LineDuplicate +1<CR>",
			},
			{
				description = "Selection: duplicate up",
				mode = { "v" },
				"<S-A-Up>",
				"<CMD>VisualDuplicate -1<CR>",
			},
			{
				description = "Selection: duplicate down",
				mode = { "v" },
				"<S-A-Down>",
				"<CMD>VisualDuplicate +1<CR>",
			},
			-- project
			-- {
			-- 	description = "find a project based on patterns",
			-- 	mode = { "n" },
			-- 	"<leader>pp",
			-- 	"<CMD>Telescope neovim-project discover<CR>",
			-- },
		})
	end,
}
