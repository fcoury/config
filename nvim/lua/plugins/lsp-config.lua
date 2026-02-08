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
				automatic_enable = false,
				ensure_installed = { "lua_ls", "biome", "ts_ls", "html" },
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"deno",
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
					-- rust_analyzer managed by rustup, not Mason (avoid binary conflicts)
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
		config = true,
	},
	{
		"neovim/nvim-lspconfig",
		depends = { "nvim-lua/lsp-status.nvim" },
		init_options = {
			userLanguages = {
				rust = "html",
			},
		},
		config = function()
			local lsp = vim.lsp
			if not (lsp and lsp.config) then
				vim.notify("Neovim 0.11+ with vim.lsp.config is required for this configuration", vim.log.levels.ERROR)
				return
			end

			-- Unify positionEncodings across all LSP clients to avoid mixed encodings
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.general = capabilities.general or {}
			capabilities.general.positionEncodings = { "utf-16" }

			local server_list = {
				"lua_ls",
				"zls",
				"html",
				"cssls",
				-- "emmet_ls",
				"htmx",
				"pyright",
				"ruff",
				"yamlls",
				"ts_ls",
				"clangd",
				"husk_lsp",
			}

			lsp.config("ts_ls", {
				single_file_support = false,
				capabilities = capabilities,
			})

			lsp.config("clangd", {
				cmd = { "clangd", "--background-index" },
				filetypes = { "c", "cpp", "objc", "objcpp" },
				root_dir = function(_)
					local uv = vim.uv or vim.loop
					return uv.cwd()
				end,
				settings = {},
				capabilities = capabilities,
			})

			for _, server in ipairs(server_list) do
				-- Ensure capabilities are set for all servers
				lsp.config(server, { capabilities = capabilities })
				lsp.enable(server)
			end

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
			-- for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
			-- 	local default_diagnostic_handler = vim.lsp.handlers[method]
			-- 	vim.lsp.handlers[method] = function(err, result, context, config)
			-- 		if err ~= nil and err.code == -32802 then
			-- 			return
			-- 		end
			-- 		return default_diagnostic_handler(err, result, context, config)
			-- 	end
			-- end

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
					local buffer = ev.buf
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buffer, desc = "Go to declaration" })
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer, desc = "Go to definition" })
					-- vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "Show hover information" })
					vim.keymap.set(
						"n",
						"D",
						vim.diagnostic.open_float,
						{ buffer = buffer, desc = "Open diagnostic window" }
					)
					vim.keymap.set(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						{ buffer = buffer, desc = "Go to implementation" }
					)
					vim.keymap.set(
						"n",
						"<C-A-k>",
						vim.lsp.buf.signature_help,
						{ buffer = buffer, desc = "Show signature help" }
					)
					vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = buffer, desc = "Rename symbol" })
					vim.keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						{ buffer = buffer, desc = "Open code actions" }
					)
					-- vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = buffer, desc = "Show references" })
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, { buffer = buffer, desc = "Format document" })
				end,
			})
		end,
	},
}
