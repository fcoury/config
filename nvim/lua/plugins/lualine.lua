return {
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "dracula",
				},
				sections = {
					lualine_a = { "mode" },
					-- lualine_b = {'branch'},
					lualine_b = { "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "require'lsp-status'.status()" },
					lualine_y = { "fileformat", "filetype" },
					lualine_z = { "location" },
				},
			})
		end,
	},
}
