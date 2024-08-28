return {
	"mrcjkb/rustaceanvim",
	version = "^5",
	lazy = false,
	config = function()
		vim.g.rustaceanvim = {
			server = {
				default_settings = {
					["rust-analyzer"] = {
						files = {
							excludeDirs = {
								"node_modules",
								"gistia-design-system/node_modules",
							},
						},
					},
				},
			},
		}
	end,
}
