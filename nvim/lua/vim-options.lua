-- basic vim configuration
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set backupcopy=yes")
vim.cmd("set splitbelow")

-- grep with ripgrep
vim.opt.grepprg = "rg --vimgrep --smart-case --follow"
vim.opt.grepformat = "%f:%l:%c:%m"

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
-- vim.wo.relativenumber = true -- show relative line numbers
vim.wo.number = true -- show line numbers

-- leader
vim.g.mapleader = " " -- set leader to space
vim.g.maplocalleader = "," -- set local leader to space

-- Rounded border
vim.o.winborder = "rounded"

-- diagnostics
vim.diagnostic.config({
	-- underline = false,
	virtual_lines = false,
	virtual_text = { current_line = false },
	float = {
		border = "rounded",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
		texthl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "ErrorLine",
			[vim.diagnostic.severity.WARN] = "WarningLine",
			[vim.diagnostic.severity.INFO] = "InfoLine",
			[vim.diagnostic.severity.HINT] = "HintLine",
		},
	},
})

-- Utility functions
_G.not_vscode = function()
	return vim.g.vscode == nil
end

-- attempt to highlight text/babel within html
-- vim.filetype.add({
-- 	extension = {
-- 		html = {
-- 			pattern = {
-- 				'<script\\s+type="text/babel"\\s*>.-</script>', -- Matches <script type="text/babel"> tags
-- 			},
-- 		},
-- 	},
-- })

-- another attempt
-- vim.cmd([[
--   augroup BabelSyntax
--     autocmd!
--     autocmd FileType html syntax include @JS syntax/javascript.vim
--     autocmd FileType html syntax region babelScript matchgroup=htmlScriptTag start=+<script[^>]*type="text/babel"[^>]*>+ keepend end=+</script>+ contains=@JS,htmlScriptTag
--   augroup END
-- ]])

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

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dts",
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.expandtab = true
	end,
})

-- Fix cursorline not extending full width in fish files
-- Fish syntax has highlights linking to Normal which breaks CursorLine priority
-- See: https://github.com/neovim/neovim/issues/9019
vim.api.nvim_create_autocmd("FileType", {
	pattern = "fish",
	callback = function()
		vim.schedule(function()
			-- Set explicit fg color to break the link to Normal
			local fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg
			vim.api.nvim_set_hl(0, "fish_color_param", { fg = fg })
			vim.api.nvim_set_hl(0, "fish_color_normal", { fg = fg })
			vim.api.nvim_set_hl(0, "fish_color_option", { fg = fg })
		end)
	end,
})

-- Temporary hack to avoid double borders with Telescope
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "TelescopeFindPre",
-- 	callback = function()
-- 		vim.opt_local.winborder = "none"
-- 		vim.api.nvim_create_autocmd("WinLeave", {
-- 			once = true,
-- 			callback = function()
-- 				vim.opt_local.winborder = "rounded"
-- 			end,
-- 		})
-- 	end,
-- })
