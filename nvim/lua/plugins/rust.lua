return {
	{
		"mrcjkb/rustaceanvim",
		version = "^7",
		lazy = false,
		dependencies = { "felpafel/inlay-hint.nvim" },
		opts = {
			server = {
				on_attach = function(client, bufnr)
					if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end

					vim.api.nvim_buf_create_user_command(bufnr, "LspCargoReload", function()
						vim.notify("Reloading Cargo workspace")
						vim.cmd.RustLsp("reloadWorkspace")
					end, { desc = "Reload current cargo workspace" })
				end,
				default_settings = {
					["rust-analyzer"] = {
						cargo = {
							features = "all",
							targetDir = "target/rust-analyzer",
							buildScripts = {
								enable = true,
								rebuildOnSave = false,
							},
						},
						files = {
							exclude = {
								".git",
								".venv",
								".terraform",
								"target",
								"node_modules",
								"gistia-design-system/node_modules",
							},
						},
						diagnostics = {
							enable = true,
							experimental = { enable = false },
						},
						procMacro = {
							ignored = {
								leptos_macro = { "server" },
							},
						},
						inlayHints = {
							parameterHints = { enable = false },
						},
						lru = { capacity = 128 },
						check = {
							command = "clippy",
							extraArgs = { "--no-deps" },
							workspace = false,
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
