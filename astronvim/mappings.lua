return {
  n = {
    [";"] = { ":", desc = "Remaps ; to :" },
    ["="] = { "<cmd>wincmd =<cr>", desc = "Equal splits" },
    ["H"] = { "^", desc = "Beginning of the line" },
    ["L"] = { "$", desc = "End of the line" },
    ["_"] = { "<cmd>split<cr>", desc = "Horizontal split" },
    ["|"] = { "<cmd>vsplit<cr>", desc = "Vertical split" },
    ['\\'] = false,

    ["<Leader>."] = { function() require("telescope.builtin").find_files({ cwd = ".." }) end, desc = "Find files on parent" },
    ["<Leader>fp"] = { "<cmd>Telescope projects<CR>", desc = "Open project search" },
    ["<Leader>ln"] = { "<cmd>RustRunnables<cr>", desc = "Rust Runnables" },
    ["<Leader>ly"] = { function() require("rust-tools").hover_actions.hover_actions() end, desc = "Rust hover actions" },
    ["<Leader>zn"] = { "<cmd>ZellijNewPane<CR>", desc = "New Zellij pane" },

    ["<C-,>"] = { function() require("astronvim.utils.buffer").prev() end, desc = "Previous buffer" },
    ["<C-.>"] = { function() vim.lsp.buf.code_action() end, desc = "Code action" },
    ["<C-P>"] = { "<cmd>ToggleRoot<CR>", desc = "Toggles between project roots defined by .roots" },
    -- ["<C-\\>"] = { function() vim.lsp.buf.code_action() end, desc = "Code action" },
    ["<C-\\>"] = { function() require("rust-tools").hover_actions.hover_actions() end, desc = "Rust hover actions" },
    ["<C-;>"] = { function() require("telescope.builtin").find_files() end, desc = "Find files" },

    ["<M-Left>"] = { "<cmd>ZellijNavigateLeft<CR>", desc = "Navigate left on windows or Zellij panes" },
    ["<M-Right>"] = { "<cmd>ZellijNavigateRight<CR>", desc = "Navigate right on windows or Zellij panes" },

    -- disabled mappings
    ["<C-Up>"] = false,
    ["<C-Down>"] = false,
    -- ["<C-x>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  },
  i = {
    ["<C-n>"] = false,
  },
  t = {
    ["<C-x>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  }
}
