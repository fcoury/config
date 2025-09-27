return {
	"dmtrKovalenko/fff.nvim",
	build = "cargo build --release",
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {
		-- pass here all the options
	},
	keys = {
		{
			"<leader>ff", -- try it if you didn't it is a banger keybinding for a picker
			function()
				require("fff").find_files()
			end,
			desc = "Toggle FFF",
		},
	},
}
