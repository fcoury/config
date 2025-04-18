if vim.g.neovide then
	vim.o.guifont = "FantasqueSansM Nerd Font Mono:h22"

	-- vim.g.neovide_transparency = 0.95
	vim.g.neovide_scale_factor = 1
	vim.g.neovide_floating_blur_amount_x = 8.0
	vim.g.neovide_floating_blur_amount_y = 8.0
	vim.g.neovide_cursor_animation_length = 0.05
	vim.g.neovide_cursor_trail_size = 0

	-- Use the system clipboard
	vim.keymap.set({ "n", "v" }, "<D-v>", '"+p')
	vim.keymap.set("i", "<D-v>", "<C-r>+")
	vim.keymap.set("c", "<D-v>", "<C-r>+")
	vim.keymap.set("v", "<D-c>", '"+y')
end
