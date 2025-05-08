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
				ensure_installed = { "lua_ls", "rust_analyzer", "biome", "ts_ls", "html" },
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"biome",
					"codelldb",
					"css-lsp",
					-- "emmet-ls",
					"eslint_d",
					"html-lsp",
					"htmx-lsp",
					"lua-language-server",
					"prettierd",
					"pyright",
					"ruff",
					"rust-analyzer",
					"stylua",
					"debugpy",
					"yamlls",
					"zls",
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
			lspconfig.ts_ls.setup({})
			lspconfig.zls.setup({})
			lspconfig.html.setup({})
			lspconfig.cssls.setup({})
			-- lspconfig.emmet_ls.setup({})
			lspconfig.htmx.setup({})
			lspconfig.pyright.setup({})
			lspconfig.ruff.setup({})
			lspconfig.yamlls.setup({})

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
			-- local bg_color = "#252739"
			-- local fg_color = "white" -- For the border foreground color

			-- Create an autocmd that sets the highlight groups when the colorscheme changes
			-- vim.api.nvim_create_autocmd("ColorScheme", {
			-- 	pattern = "*",
			-- 	callback = function()
			-- 		vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg_color })
			-- 		vim.api.nvim_set_hl(0, "FloatBorder", { fg = fg_color, bg = bg_color })
			-- 	end,
			-- })

			-- Trigger the autocmd to apply the color immediately
			-- vim.cmd("doautocmd ColorScheme")

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

			-- temporary fix for rust analyzer cancelation
			for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
				local default_diagnostic_handler = vim.lsp.handlers[method]
				vim.lsp.handlers[method] = function(err, result, context, config)
					if err ~= nil and err.code == -32802 then
						return
					end
					return default_diagnostic_handler(err, result, context, config)
				end
			end

			-- lsp actions with telescope
			-- local builtin = require("telescope.builtin")

			-- emmet lsp
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = false

			-- lspconfig.emmet_ls.setup({
			-- 	-- on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	filetypes = {
			-- 		"css",
			-- 		"eruby",
			-- 		"html",
			-- 		"javascriptreact",
			-- 		"less",
			-- 		"sass",
			-- 		"scss",
			-- 		"svelte",
			-- 		"pug",
			-- 		"typescriptreact",
			-- 		"vue",
			-- 	},
			-- 	init_options = {
			-- 		html = {
			-- 			options = {
			-- 				-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
			-- 				["bem.enabled"] = true,
			-- 			},
			-- 		},
			-- 	},
			-- })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.bum, desc = "Go to declaration" })
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.bum, desc = "Go to definition" })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.bum, desc = "Show hover information" })
					vim.keymap.set(
						"n",
						"D",
						vim.diagnostic.open_float,
						{ buffer = ev.bum, desc = "Open diagnostic window" }
					)
					vim.keymap.set(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						{ buffer = ev.bum, desc = "Go to implementation" }
					)
					vim.keymap.set(
						"n",
						"<C-A-k>",
						vim.lsp.buf.signature_help,
						{ buffer = ev.bum, desc = "Show signature help" }
					)
					vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = ev.bum, desc = "Rename symbol" })
					vim.keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						{ buffer = ev.bum, desc = "Open code actions" }
					)
					-- vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = ev.bum, desc = "Show references" })
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, { buffer = ev.bum, desc = "Format document" })
				end,
			})
		end,
	},
}
