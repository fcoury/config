return {
  colorscheme = "nightfox",
  -- colorscheme = "tokyonight-night",

  -- add new user interface icon
  icons = {
    --   VimIcon = "",
    --   ScrollText = "",
    --   GitBranch = "",
    GitAdd = "",
    -- GitChange = "",
    GitDelete = "",
  },

  heirline = {
    separators = {
      left = { "", " " }, -- separator for the left side of the statusline
      right = { " ", "" }, -- separator for the right side of the statusline
      tab = { "", "" },
    },
    attributes = {
      mode = { bold = true },
    },
  }
}
