return {
  n = {
    ['\\'] = { false, desc = "Disable \\ so multi-cursor can work" },
    [";"] = { ":", desc = "Remaps ; to :" },
    ["H"] = { "^", desc = "Beginning of the line" },
    ["L"] = { "$", desc = "End of the line" },
    ["<C-x>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  },
  i = {
    ["<C-n>"] = false,
  },
  t = {
    ["<C-x>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  }
}
