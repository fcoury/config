return {
	"ray-x/web-tools.nvim",
	config = function()
		require("web-tools").setup({
			keymaps = {
				rename = nil,
				repeat_rename = ".",
			},
		})
	end,
}
