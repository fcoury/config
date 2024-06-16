local keymap = vim.keymap

-- remaps ; to act as :
keymap.set("n", ";", ":", { noremap = true })

-- disable arrows
keymap.set({ "n", "v", "i" }, "<up>", "<nop>")
keymap.set({ "n", "v", "i" }, "<down>", "<nop>")
keymap.set({ "n", "v", "i" }, "<left>", "<nop>")
keymap.set({ "n", "v", "i" }, "<right>", "<nop>")

keymap.set("n", "<leader>a", "ggVG") -- select all
keymap.set({ "n", "x" }, "<leader>p", '"0p') -- paste not overwritten by delete
-- keymap.set("n", "<leader>w", "<cmd>w<cr>") -- save current file
keymap.set("n", "<leader>q", "<cmd>q<cr>") -- quit
keymap.set("n", "U", "<C-r>", { noremap = true })
keymap.set("n", "H", "^", { noremap = true })
keymap.set("n", "L", "$", { noremap = true })

-- telescope
keymap.set("n", "<C-j>", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics<cr>")
keymap.set("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>")
keymap.set("n", "<leader>w", "<cmd>Telescope lsp_workspace_symbols<cr>")
keymap.set("n", "<leader>k", "<cmd>Telescope lsp_references<cr>")
keymap.set("n", "<C-t>", "<cmd>Telescope lsp_document_symbols<cr>")

-- lsp and rust
keymap.set("n", "<leader>x", "<cmd>RustRunnables<cr>")
-- keymap.set("n", "<leader>y", "<cmd>lua require'runst'.run_test()<cr>", { noremap = true, silent = true })

-- buffers
keymap.set("n", "]b", "<cmd>bnext<cr>")
keymap.set("n", "[b", "<cmd>bprevious<cr>")
keymap.set("n", "<leader>c", "<cmd>bd<cr>")
keymap.set("n", "<leader><leader>", "<cmd>b#<cr>")

-- splits
keymap.set("n", "|", "<cmd>vsplit<cr><c-w><c-w>")
keymap.set("n", "_", "<cmd>split<cr>")
keymap.set("n", "=", "<cmd>wincmd =<cr>")
