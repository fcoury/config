return {
  n = {
    ['\\'] = false,
    [";"] = { ":", desc = "Remaps ; to :" },
    ["H"] = { "^", desc = "Beginning of the line" },
    ["L"] = { "$", desc = "End of the line" },
    ["<Leader>fp"] = { "<cmd>Telescope projects<CR>", desc = "Open project search" },
    ["<Leader>ln"] = { "<cmd>RustRunnables<cr>", desc = "Rust Runnables" },
    ["<Leader>ly"] = { function() require("rust-tools").hover_actions.hover_actions() end, desc = "Rust hover actions" },
    ["<C-\\>"] = { function() vim.lsp.buf.code_action() end, desc = "Code action" },
    ["<C-.>"] = { function() vim.lsp.buf.code_action() end, desc = "Code action" },
    ["<C-,>"] = { function() require("astronvim.utils.buffer").prev() end, desc = "Previous buffer" },
    ["<C-P>"] = { "<cmd>ToggleRoot<CR>", desc = "Toggles between project roots defined by .roots" },
    ["_"] = { "<cmd>split<cr>", desc = "Horizontal split" },
    ["|"] = { "<cmd>vsplit<cr>", desc = "Vertical split" },
    -- disabled mappings
    ["<C-Down>"] = false,
    ["<C-Up>"] = false,
    -- ["<C-x>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  },
  i = {
    ["<C-n>"] = false,
  },
  t = {
    ["<C-x>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  }
}
