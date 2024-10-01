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
