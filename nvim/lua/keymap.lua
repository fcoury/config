local keymap = vim.keymap

-- remaps ; to act as :
keymap.set("n", ";", ":", { noremap = true })

keymap.set("n", "<C-a>", "ggVG") -- select all
keymap.set({ "n", "x" }, "<leader>p", '"0p') -- paste not overwritten by delete
keymap.set("n", "<leader>w", "<cmd>w<cr>") -- save current file
keymap.set("n", "<leader>q", "<cmd>q<cr>") -- quit

-- telescope
keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics<cr>")
keymap.set("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>")

-- lsp and rust
keymap.set("n", "<leader>x", "<cmd>RustRunnables<cr>")

-- buffers
keymap.set("n", "]b", "<cmd>bnext<cr>")
keymap.set("n", "[b", "<cmd>bprevious<cr>")
keymap.set("n", "<leader>c", "<cmd>bd<cr>")
keymap.set("n", "<leader><leader>", "<cmd>b#<cr>")

-- splits
keymap.set("n", "|", "<cmd>vsplit<cr>")
keymap.set("n", "_", "<cmd>split<cr>")
keymap.set("n", "=", "<cmd>wincmd =<cr>")
