return {
	"ojroques/nvim-osc52",
	opts = { silent = true, trim = false },
	config = function(_, opts)
		require("osc52").setup(opts)
		-- Send normal/visual yanks to local clipboard via OSC52
		local function copy()
			if vim.v.event.operator == "y" and vim.v.event.regname == "" then
				require("osc52").copy_register('"')
			end
		end
		vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
	end,
}
