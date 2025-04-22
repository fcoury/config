return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
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
								extraEnv = { RUSTFLAGS = "-C debuginfo=0" },
							},
							files = {
								excludeDirs = {
									".git",
									".venv",
									".terraform",
									"target",
									"node_modules",
									"gistia-design-system/node_modules",
								},
								watcher = "client",
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
							cache = {
								warmup = true,
							},
						},
					},
				},
			}
		end,
	},
}
