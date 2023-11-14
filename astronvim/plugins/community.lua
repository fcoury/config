return {
  "AstroNvim/astrocommunity",
  {
    { import = "astrocommunity.completion.copilot-lua" },
    { import = "astrocommunity.pack.rust" },
    { import = "astrocommunity.project.project-nvim" },
    { import = "astrocommunity.test.neotest" },
    {
      "copilot.lua",
      opts = {
        suggestion = {
          enabled = true,
          keymap = {
            accept = "<C-l>",
          },
        },
      },
    },
  },
}
