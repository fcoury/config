return {
	cmd = { "husk-lsp" },
	cmd_env = {
		HUSK_LSP_LOG = "debug", -- Options: error, warn, info, debug, trace
	},
	filetypes = { "husk" },
	root_markers = { ".git", "husk.toml" },
	settings = {
		husk = {
			-- Future settings go here
		},
	},
}
