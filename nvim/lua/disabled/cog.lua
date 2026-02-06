return {
	dir = "/Users/fcoury/code-external/cog/cog.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"j-hui/fidget.nvim",
		"MeanderingProgrammer/render-markdown.nvim",
	},
	config = function()
		require("cog").setup({
			debug = {
				session_updates = true,
				session_updates_path = "/tmp/cog-session-updates.log",
			},
			backend = {
				bin_path = "/Users/fcoury/code-external/cog/cog-agent/target/release/cog-agent",
				auto_start = true,
			},
			adapters = {
				codex = {
					command = { "/Users/fcoury/.local/bin/codex-acp" },
				},
			},
			file_operations = {
				auto_apply = true,
			},
		})
	end,
}
