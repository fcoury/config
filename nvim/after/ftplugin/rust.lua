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
vim.keymap.set("n", "<leader>RR", function()
	vim.cmd.RustLsp("reloadWorkspace")
	print("Reloaded Rust workspace")
end, { silent = true, buffer = bufnr, desc = "Reload Rust workspace" })

vim.keymap.set("n", "<leader>Rs", function()
	vim.cmd.RustLsp({ "rebuildProcMacros" })
	print("Rebuilt proc macros")
end, { silent = true, buffer = bufnr, desc = "Rebuild Rust proc macros" })

-- Command to force restart RustAnalyzer (handles both naming conventions)
vim.keymap.set("n", "<leader>Rr", function()
	-- Stop all rust-analyzer clients (rustaceanvim uses rust_analyzer, some configs use rust-analyzer)
	local clients = vim.lsp.get_clients({ name = "rust_analyzer" })
	if #clients == 0 then
		clients = vim.lsp.get_clients({ name = "rust-analyzer" })
	end

	if #clients == 0 then
		vim.notify("No rust-analyzer client found", vim.log.levels.WARN)
		return
	end

	-- Clear inlay hints before stopping to avoid stale col positions
	vim.lsp.inlay_hint.enable(false, { bufnr = 0 })

	for _, client in ipairs(clients) do
		client:stop(true) -- force stop
	end

	-- Small delay to ensure clean shutdown, then start LSP again
	vim.defer_fn(function()
		vim.cmd("LspStart rust_analyzer")
		vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
		vim.notify("RustAnalyzer restarted", vim.log.levels.INFO)
	end, 100)
end, { silent = true, buffer = bufnr, desc = "Restart RustAnalyzer (full)" })
