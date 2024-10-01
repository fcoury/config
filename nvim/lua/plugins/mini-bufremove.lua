return {
	"echasnovski/mini.bufremove",
	version = false,
	config = function()
		require("mini.bufremove").setup()
		vim.api.nvim_create_user_command("Bd", "lua MiniBufremove.unshow()", {})
	end,
}
