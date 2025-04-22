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
