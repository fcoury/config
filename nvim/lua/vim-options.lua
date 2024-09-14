-- basic vim configuration
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set backupcopy=yes")
vim.cmd("set splitbelow")

-- enables highlight for current line
vim.opt.cursorline = true

-- system clipboard integration
vim.cmd("set clipboard+=unnamedplus")

-- format options
--     tc = wrap text and comments using textwidth,
--     r = continue comments when pressing enter,
--     q = continue comments when pressing o or O,
--     n = indent past formatlistpat, not gq
vim.opt.formatoptions = "tcrqn"

-- enable smart indenting (https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
vim.opt.breakindent = true -- indent wrapped lines

-- case insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- persist undo history
vim.opt.undofile = true

-- 24-bit colors
vim.opt.termguicolors = true

-- gutter space for sign column
vim.opt.signcolumn = "yes"

-- keep 8 lines above and below cursor
vim.opt.scrolloff = 3

-- add a column line at 80 characters
-- vim.opt.colorcolumn = "80"

-- line numbering
vim.wo.relativenumber = true -- show relative line numbers
vim.wo.number = true -- show line numbers

-- leader
vim.g.mapleader = " " -- set leader to space

-- gutter signs
vim.fn.sign_define({
	{
		name = "DiagnosticSignError",
		text = "",
		texthl = "DiagnosticSignError",
		linehl = "ErrorLine",
	},
	{
		name = "DiagnosticSignWarn",
		text = "",
		texthl = "DiagnosticSignWarn",
		linehl = "WarningLine",
	},
	{
		name = "DiagnosticSignInfo",
		text = "",
		texthl = "DiagnosticSignInfo",
		linehl = "InfoLine",
	},
	{
		name = "DiagnosticSignHint",
		text = "",
		texthl = "DiagnosticSignHint",
		linehl = "HintLine",
	},
})

-- diagnostics
vim.diagnostic.config({
	float = {
		border = "rounded",
	},
})

-- identation
-- Set indentation for HTML files to 2 spaces
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "html",
-- 	callback = function()
-- 		vim.opt_local.shiftwidth = 2
-- 		vim.opt_local.softtabstop = 2
-- 		vim.opt_local.expandtab = true
-- 	end,
-- })
