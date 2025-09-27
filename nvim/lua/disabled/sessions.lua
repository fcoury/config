return {
	"echasnovski/mini.sessions",
	version = false,
	config = function()
		require("mini.sessions").setup({
			-- Directory to store session files
			directory = vim.fn.stdpath("data") .. "/sessions",

			-- File extension for session files
			file_extension = ".vim",

			-- Whether to save sessions automatically on Vim exit
			auto_save = true,

			-- Whether to load the last session on Vim start
			auto_load = true,
		})
	end,
}
