return {
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
		config = function()
			vim.g.rustaceanvim = {
				server = {
					---@diagnostic disable-next-line: unused-local
					on_attach = function(client, bufnr)
						vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#575B6E", italic = true })
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

						-- overrides the default lsp hover with our Rust specialized one
						vim.keymap.set("n", "K", function()
							print("K")
							vim.cmd.RustLsp({ "hover", "actions" })
						end, { silent = true, buffer = bufnr, desc = "Show hover information" })
					end,
					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
							},
							files = {
								excludeDirs = {
									"node_modules",
									"gistia-design-system/node_modules",
								},
							},
							procMacro = {
								ignored = {
									leptos_macro = {
										-- optional: --
										-- "component",
										"server",
									},
								},
							},
						},
					},
				},
			}
		end,
	},
}
