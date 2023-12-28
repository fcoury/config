-- basic vim configuration
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set signcolumn=yes") -- reserves gutter space for signs
vim.cmd("set backupcopy=yes")
vim.cmd("set splitbelow")

-- system clipboard integration
vim.cmd("set clipboard+=unnamedplus")

-- format options
--     tc = wrap text and comments using textwidth,
--     r = continue comments when pressing enter,
--     q = continue comments when pressing o or O,
--     n = indent past formatlistpat, not gq
vim.opt.formatoptions = "tcrqn"

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
