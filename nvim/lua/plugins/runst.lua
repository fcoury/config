return {
	-- dir = "~/code/runst",
	as = "runst",
	"codersauce/runst.nvim",
	lazy = false,
	opts = {},
	config = function()
		require("runst").setup()
	end,
}
