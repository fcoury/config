-- Add this temporarily to see what's happening
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "rust_analyzer" then
			print("Rust-analyzer settings:", vim.inspect(client.config.settings))
		end
	end,
})

-- vim.lsp.config("rust-analyzer", {
-- 	settings = {
-- 		["rust-analyzer"] = {
-- 			cargo = {
-- 				allFeatures = true,
-- 				extraEnv = { RUSTFLAGS = "-C debuginfo=0" },
-- 			},
-- 			files = {
-- 				excludeDirs = {
-- 					".git",
-- 					".venv",
-- 					".terraform",
-- 					"target",
-- 					"node_modules",
-- 					"gistia-design-system/node_modules",
-- 				},
-- 				watcher = "client",
-- 			},
-- 			procMacro = {
-- 				ignored = {
-- 					leptos_macro = {
-- 						-- optional: --
-- 						-- "component",
-- 						"server",
-- 					},
-- 				},
-- 			},
-- 			cache = {
-- 				warmup = true,
-- 			},
-- 		},
-- 	},
-- })
