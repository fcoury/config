return {
  n = {
    ['\\'] = false,
    [";"] = { ":", desc = "Remaps ; to :" },
    ["H"] = { "^", desc = "Beginning of the line" },
    ["L"] = { "$", desc = "End of the line" },
    ["<Leader>fp"] = { "<cmd>Telescope projects<CR>", desc = "Open project search" },
    ["<Leader>ln"] = { "<cmd>RustRunnables<cr>", desc = "Rust Runnables" },
    ["<Leader>lx"] = { require("rust-tools").hover_actions.hover_actions(), desc = "Rust hover actions" },
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
