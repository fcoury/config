local keymap = vim.keymap

-- remaps ; to act as :
keymap.set("n", ";", ":", { noremap = true })

keymap.set("n", "<C-a>", "ggVG") -- select all
keymap.set({ "n", "x" }, "<leader>p", '"0p') -- paste not overwritten by delete
keymap.set("n", "<leader>w", "<cmd>w<cr>") -- quits
keymap.set("n", "<leader>q", "<cmd>q<cr>") -- quits

-- telescope
keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics<cr>")

-- buffers
keymap.set("n", "]b", "<cmd>bnext<cr>")
keymap.set("n", "[b", "<cmd>bprevious<cr>")
keymap.set("n", "<leader>c", "<cmd>bd<cr>")

-- splits
keymap.set("n", "|", "<cmd>vsplit<cr>")
keymap.set("n", "_", "<cmd>split<cr>")
keymap.set("n", "=", "<cmd>wincmd =<cr>")
