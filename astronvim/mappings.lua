return {
  n = {
    ['\\'] = false,
    -- ['\\'] = { false, desc = "Disable \\ so multi-cursor can work" },
    [";"] = { ":", desc = "Remaps ; to :" },
    ["H"] = { "^", desc = "Beginning of the line" },
    ["L"] = { "$", desc = "End of the line" },
    -- ["<C-x>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    ["<C-x>"] = { "<cmd>RustRunnables<cr>", desc = "Rust Runnables" },
    ["<C-space>"] = { require("rust-tools").hover_actions.hover_actions(), desc = "Rust hover actions" },
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
