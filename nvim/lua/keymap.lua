local keymap = vim.keymap

-- remaps ; to act as :
keymap.set("n", ";", ":", { noremap = true })

keymap.set("n", "<leader>a", "ggVG", { desc = "select all" }) -- select all
keymap.set({ "n", "x" }, "<leader>p", '"0p', { desc = "paste and doesn't overwrite" }) -- paste not overwritten by delete
keymap.set("n", "U", "<C-r>", { noremap = true, desc = "redo" })
keymap.set("n", "H", "^", { noremap = true, desc = "move to beginning of line" })
keymap.set("n", "L", "$", { noremap = true, desc = "move to end of line" })

-- telescope
keymap.set("n", "<C-j>", "<cmd>Telescope buffers<cr>", { desc = "open buffers" })
keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "open buffers" })
keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics<cr>", { desc = "open diagnostics" })
keymap.set("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "open document symbols" })
keymap.set("n", "<leader>w", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "open workspace symbols" })
keymap.set("n", "<leader>k", "<cmd>Telescope lsp_references<cr>", { desc = "open references" })
keymap.set("n", "<C-t>", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "open document symbols" })

-- lsp and rust
keymap.set("n", "<leader>x", "<cmd>RustRunnables<cr>", { desc = "run rust runnables" })
-- keymap.set("n", "<leader>y", "<cmd>lua require'runst'.run_test()<cr>", { noremap = true, silent = true })

-- buffers
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "next buffer" })
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "previous buffer" })
-- keymap.set("n", "<leader>c", "<cmd>bd<cr>")
keymap.set("n", "<leader><leader>", "<cmd>b#<cr>", { desc = "switch to last buffer" })

-- splits
keymap.set("n", "|", "<cmd>vsplit<cr><c-w><c-w>", { desc = "split vertically" })
keymap.set("n", "_", "<cmd>split<cr>", { desc = "split horizontally" })
keymap.set("n", "=", "<cmd>wincmd =<cr>", { desc = "balance splits" })

-- lsp related
keymap.set("n", "<leader>,d", "<cmd>DiagnosticToggle<cr>", { desc = "toggle diagnostics" })

-- special commands
keymap.set(
	"n",
	"<leader>cl",
	"<cmd>CopyFileNameAndLine<cr>",
	{ noremap = true, silent = true, desc = "Copy current file name and line number" }
)

-- delete text (as opposed to saving it on the default register)
vim.api.nvim_set_keymap("n", "m", '"_x', { noremap = true, silent = true, desc = "delete text" })
vim.api.nvim_set_keymap("n", "mm", '"_dd', { noremap = true, silent = true, desc = "delete line" })
vim.api.nvim_set_keymap("v", "m", '"_x', { noremap = true, silent = true, desc = "delete text" })
vim.api.nvim_set_keymap("n", "mw", '"_dw', { noremap = true, silent = true, desc = "delete word" })
vim.api.nvim_set_keymap("n", "miw", '"_diw', { noremap = true, silent = true, desc = "delete inner word" })

--== Helper Functions ==--

-- disable arrows except in replace mode
function _G_disable_arrows()
	keymap.set({ "n", "v", "i" }, "<up>", "<nop>")
	keymap.set({ "n", "v", "i" }, "<down>", "<nop>")
	keymap.set({ "n", "v", "i" }, "<left>", "<nop>")
	keymap.set({ "n", "v", "i" }, "<right>", "<nop>")
end

function _G_enable_arrows()
	keymap.set({ "n", "v", "i" }, "<up>", "<up>")
	keymap.set({ "n", "v", "i" }, "<down>", "<down>")
	keymap.set({ "n", "v", "i" }, "<left>", "<left>")
	keymap.set({ "n", "v", "i" }, "<right>", "<right>")
end

vim.api.nvim_exec(
	[[
  augroup ArrowKeysInReplaceMode
    autocmd!
    autocmd ModeChanged * lua if vim.fn.mode() == "R" then _G_enable_arrows() else _G_disable_arrows() end
  augroup END
  ]],
	false
)

_G_disable_arrows()
