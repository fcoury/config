return {
  n = {
    ['\\'] = false,
    [";"] = { ":", desc = "Remaps ; to :" },
    ["H"] = { "^", desc = "Beginning of the line" },
    ["L"] = { "$", desc = "End of the line" },
    ["<Leader>fp"] = { "<cmd>Telescope projects<CR>", desc = "Open project search" },
    -- ["<C-x>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    ["<Leader>ln"] = { "<cmd>RustRunnables<cr>", desc = "Rust Runnables" },
    ["<Leader>lx"] = { require("rust-tools").hover_actions.hover_actions(), desc = "Rust hover actions" },
    ["<C-Down>"] = false,
    ["<C-Up>"] = false,
  },
  i = {
    ["<C-n>"] = false,
  },
  t = {
    ["<C-x>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  }
}
