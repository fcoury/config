-- configures lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- configures nvim
require("vim-options")

-- neovide options
require("neovide")

-- key mappings
require("keymap")

-- custom commands
require("commands")

-- load plugins with lazy.nvim
-- require("lazy").setup("plugins")
require("lazy").setup({
	spec = {
		-- import plugins
		{ import = "plugins" },
	},
	checker = {
		enabled = false,
		notify = false,
	},
	change_detection = {
		enabled = true,
		notify = false,
	},
})

vim.lsp.enable("rust-analyzer")
