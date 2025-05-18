-- Rust specific keymaps
local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set("n", "<leader>ca", function()
	-- vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
	vim.lsp.buf.code_action()
end, { silent = true, buffer = bufnr, desc = "Rust code actions" })
vim.keymap.set(
	"n",
	"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
	function()
		vim.cmd.RustLsp({ "hover", "actions" })
	end,
	{ silent = true, buffer = bufnr, desc = "Rust hover actions" }
)

-- Add keymaps to help with stale RustAnalyzer
vim.keymap.set("n", "<leader>rr", function()
	vim.cmd.RustLsp("reloadWorkspace")
	print("Reloaded Rust workspace")
end, { silent = true, buffer = bufnr, desc = "Reload Rust workspace" })

vim.keymap.set("n", "<leader>rs", function()
	vim.cmd.RustLsp({ "rebuildProcMacros" })
	print("Rebuilt proc macros")
end, { silent = true, buffer = bufnr, desc = "Rebuild Rust proc macros" })

-- Command to force restart RustAnalyzer
vim.keymap.set("n", "<leader>rR", function()
	vim.lsp.stop_client(vim.lsp.get_active_clients({ name = "rust-analyzer" }))
	vim.cmd.e()
	print("Restarted RustAnalyzer")
end, { silent = true, buffer = bufnr, desc = "Restart RustAnalyzer" })
