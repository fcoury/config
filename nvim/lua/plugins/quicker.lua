-- better quickfix and loclist
-- love to do grep then :copen with this and change matches in place
return {
	"stevearc/quicker.nvim",
	event = "FileType qf",
	---@module "quicker"
	---@type quicker.SetupOptions
	opts = {},
	keys = {
		{
			"<leader>q",
			mode = { "n" },
			function()
				require("quicker").toggle()
			end,
			desc = "Toggle quickfix",
		},
		{
			"<leader>l",
			mode = { "n" },
			function()
				require("quicker").toggle({ loclist = true })
			end,
			desc = "Toggle loclist",
		},
	},
	config = function()
		require("quicker").setup()
	end,
}
