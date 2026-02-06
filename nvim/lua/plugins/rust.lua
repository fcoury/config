return {
	{
		"mrcjkb/rustaceanvim",
		version = "^7",
		lazy = false,
		opts = {
			server = {
				on_attach = function(client, bufnr)
					vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#575B6E", italic = true })
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

					vim.api.nvim_buf_create_user_command(bufnr, "LspCargoReload", function()
						local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })
						for _, c in ipairs(clients) do
							vim.notify("Reloading Cargo Workspace")
							c.request("rust-analyzer/reloadWorkspace", nil, function(err)
								if err then
									error(tostring(err))
								end
								vim.notify("Cargo workspace reloaded")
							end, 0)
						end
					end, { desc = "Reload current cargo workspace" })
				end,
				capabilities = {
					general = { positionEncodings = { "utf-16" } },
					experimental = {
						serverStatusNotification = true,
					},
				},
				default_settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							targetDir = "target/rust-analyzer",
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
						diagnostics = {
							enable = true,
							experimental = { enable = false },
							refreshSupport = false,
						},
						procMacro = {
							ignored = {
								leptos_macro = { "server" },
							},
						},
						lru = { capacity = 128 },
						cache = { warmup = true },
						workspace = { refreshTime = 150 },
						buildScripts = {
							enable = true,
							rebuildOnSave = false,
						},
						check = {
							command = "clippy",
							extraArgs = { "--no-deps" },
						},
					},
				},
			},
			tools = {
				hover_actions = {
					auto_focus = true,
					ui_select_fallback = true,
				},
			},
		},
		config = function(_, opts)
			vim.g.rustaceanvim = opts
		end,
	},
	{ "rhaiscript/vim-rhai", ft = "rhai" },
}
