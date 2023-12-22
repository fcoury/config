return {
  "simrat39/rust-tools.nvim",
  dependencies = {
    "neovim/nvim-lspconfig"
  },
  config = function()
    local rt = require("rust-tools")
    rt.setup({
      on_attach = function(_, bufnr)
        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
        -- vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
      end,
      server = {
        settings = {
          ["rust-analyzer"] = {
            files = {
              excludeDirs = {
                "node_modules",
                "gistia-design-system/node_modules"
              }
            }
          }
        }
      }
    })
    rt.inlay_hints.enable()
  end
}
