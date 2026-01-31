-- Configuration toggle for rust-analyzer behavior
local rust_config = {
	-- Toggle between proactive (true) and manual (false) proc-macro rebuilding
	-- Proactive: auto-rebuilds on save, more CPU but seamless external edits
	-- Manual: you control rebuilds via <leader>Rr, less resource usage
	proactive_rebuild = true,
}

return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,
		ft = { "rust" },
		opts = {
			server = {
				on_attach = function(client, bufnr)
					vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#575B6E", italic = true })
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

					-- Add your custom command
					vim.api.nvim_buf_create_user_command(bufnr, "LspCargoReload", function()
						local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })
						for _, client in ipairs(clients) do
							vim.notify("Reloading Cargo Workspace")
							client.request("rust-analyzer/reloadWorkspace", nil, function(err)
								if err then
									error(tostring(err))
								end
								vim.notify("Cargo workspace reloaded")
							end, 0)
						end
					end, { desc = "Reload current cargo workspace" })
				end,
				capabilities = {
					-- Ensure consistent position encoding with Copilot
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
							watcher = "client", -- detect external file changes via Neovim
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
							rebuildOnSave = rust_config.proactive_rebuild,
						},
						check = {
							command = "check",
						},
						checkOnSave = {
							enable = true,
							command = "check",
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
	-- {
	-- 	"mrcjkb/rustaceanvim",
	-- 	version = "^6",
	-- 	lazy = false,
	-- 	ft = { "rust" },
	-- 	opts = {
	-- 		server = {
	-- 			on_attach = function(client, bufnr)
	-- 				vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#575B6E", italic = true })
	-- 				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	-- 			end,
	-- 			capabilities = {
	-- 				offsetEncoding = { "utf-8", "utf-16" },
	-- 				positionEncodings = { "utf-8", "utf-16" },
	-- 			},
	-- 			default_settings = {
	-- 				["rust-analyzer"] = {
	-- 					cargo = {
	-- 						allFeatures = true,
	-- 						targetDir = "target/rust-analyzer",
	-- 						extraEnv = { RUSTFLAGS = "-C debuginfo=0" },
	-- 					},
	-- 					checkOnSave = {
	-- 						enable = true,
	-- 						command = "check",
	-- 						extraArgs = { "--target-dir", "target/rust-analyzer" },
	-- 					},
	-- 					files = {
	-- 						excludeDirs = {
	-- 							".git",
	-- 							".venv",
	-- 							".terraform",
	-- 							"target",
	-- 							"node_modules",
	-- 							"gistia-design-system/node_modules",
	-- 						},
	-- 						watcher = "client",
	-- 					},
	-- 					diagnostics = {
	-- 						enable = true,
	-- 						experimental = { enable = false },
	-- 						refreshSupport = false,
	-- 					},
	-- 					procMacro = {
	-- 						ignored = {
	-- 							leptos_macro = { "server" },
	-- 						},
	-- 					},
	-- 					cache = { warmup = true },
	-- 					workspace = { refreshTime = 150 },
	-- 					buildScripts = {
	-- 						enable = true,
	-- 						rebuildOnSave = false,
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- 	config = function(_, opts)
	-- 		vim.g.rustaceanvim = opts
	-- 	end,
	-- },
}
