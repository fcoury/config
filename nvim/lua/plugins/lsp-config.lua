return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "biome", "tsserver", "html" },
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"lua-language-server",
					"stylua",
					"eslint_d",
					"prettierd",
					"biome",
					"prettierd",
					"rust-analyzer",
					"html-lsp",
					"css-lsp",
					"emmet-ls",
					"htmx-lsp",
					"ruff-lsp",
					"pyright",
				},
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
		opts = {},
	},
	{
		"felpafel/inlay-hint.nvim",
		event = "LspAttach",
		config = true,
	},
	{
		"neovim/nvim-lspconfig",
		depends = { "nvim-lua/lsp-status.nvim" },
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.tsserver.setup({})
			lspconfig.zls.setup({})
			lspconfig.html.setup({})
			lspconfig.cssls.setup({})
			lspconfig.emmet_ls.setup({})
			lspconfig.htmx.setup({})
			lspconfig.pyright.setup({})
			lspconfig.ruff.setup({})

			-- cpp setup
			lspconfig.clangd.setup({
				cmd = { "clangd", "--background-index" },
				filetypes = { "c", "cpp", "objc", "objcpp" },
				root_dir = function()
					return vim.loop.cwd()
				end,
				settings = {},
			})

			local keymap = vim.keymap
			keymap.set("n", "[d", vim.diagnostic.goto_prev)
			keymap.set("n", "]d", vim.diagnostic.goto_next)

			-- Define the color
			-- local bg_color = "#1f2335"
			local bg_color = "#252739"
			local fg_color = "white" -- For the border foreground color

			-- Create an autocmd that sets the highlight groups when the colorscheme changes
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg_color })
					vim.api.nvim_set_hl(0, "FloatBorder", { fg = fg_color, bg = bg_color })
				end,
			})

			-- Trigger the autocmd to apply the color immediately
			vim.cmd("doautocmd ColorScheme")

			local lsp_handlers = vim.lsp.handlers

			-- Define the border style
			local border_style = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

			-- Wrap the original handlers with a border
			lsp_handlers["textDocument/hover"] = function(err, result, ctx, config)
				config = config or {}
				config.border = border_style
				config.focusable = false
				vim.lsp.handlers.hover(err, result, ctx, config)
			end

			lsp_handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
				config = config or {}
				config.border = border_style
				vim.lsp.handlers.signature_help(err, result, ctx, config)
			end

			-- lsp actions with telescope
			local builtin = require("telescope.builtin")

			-- emmet lsp
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = false

			lspconfig.emmet_ls.setup({
				-- on_attach = on_attach,
				capabilities = capabilities,
				filetypes = {
					"css",
					"eruby",
					"html",
					"javascript",
					"javascriptreact",
					"less",
					"sass",
					"scss",
					"svelte",
					"pug",
					"typescriptreact",
					"vue",
				},
				init_options = {
					html = {
						options = {
							-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
							["bem.enabled"] = true,
						},
					},
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "D", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", builtin.lsp_references, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},
}
