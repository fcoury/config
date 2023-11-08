return {
  "AstroNvim/astrocommunity",
  {
    { import = "astrocommunity.pack.rust" },
    { import = "astrocommunity.completion.copilot-lua" },
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
    { import = "astrocommunity.test.neotest" },
  },
}
