return {
	"Wansmer/treesj",
	config = function()
		local tsj = require("treesj")
		tsj.setup({
			use_default_keymaps = false,
		})
		vim.keymap.set("n", "<leader>j", tsj.toggle, { desc = "Toggle join/split formatting" })
		vim.keymap.set("n", "<leader>J", function()
			tsj.toggle({ split = { recursive = true } })
		end, { desc = "Toggle join/split formatting recursively" })
	end,
}
