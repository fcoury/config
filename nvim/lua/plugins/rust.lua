return {
	{
		"mrcjkb/rustaceanvim",
		version = "^7",
		lazy = false,
		dependencies = { "fcoury/inlay-hint.nvim" },
		opts = {
			server = {
				on_attach = function(client, bufnr)
					local root_dir = client.config.root_dir or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))

					if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end

					vim.api.nvim_buf_create_user_command(bufnr, "LspCargoReload", function()
						vim.notify("Reloading Cargo workspace")
						vim.cmd.RustLsp("reloadWorkspace")
					end, { desc = "Reload current cargo workspace" })

					vim.api.nvim_buf_create_user_command(bufnr, "LspCargoClippy", function()
						if vim.fn.executable("cargo") ~= 1 then
							vim.notify("cargo executable not found", vim.log.levels.ERROR)
							return
						end

						vim.notify("Running cargo clippy")
						vim.system({
							"cargo",
							"clippy",
							"--workspace",
							"--all-targets",
							"--all-features",
							"--no-deps",
							"--message-format=short",
						}, { cwd = root_dir, text = true }, function(result)
							vim.schedule(function()
								if result.code == 0 then
									vim.notify("cargo clippy finished")
									return
								end

								local output = table.concat(vim.tbl_filter(function(line)
									return line ~= nil and line ~= ""
								end, { result.stdout, result.stderr }), "\n")

								vim.notify(output ~= "" and output or "cargo clippy failed", vim.log.levels.WARN)
							end)
						end)
					end, { desc = "Run cargo clippy for the current workspace" })

					vim.keymap.set("n", "<leader>Rc", "<cmd>LspCargoClippy<cr>", {
						buffer = bufnr,
						desc = "Run cargo clippy",
					})
				end,
				default_settings = {
					["rust-analyzer"] = {
						cargo = {
							features = "all",
							allTargets = false,
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
						checkOnSave = true,
						check = {
							command = "check",
							allTargets = false,
							workspace = true,
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
