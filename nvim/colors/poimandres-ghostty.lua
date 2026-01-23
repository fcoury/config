-- Poimandres Ghostty theme for Neovim
-- Based on https://github.com/LucidMach/poimandres-ghostty

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "poimandres-ghostty"
vim.o.termguicolors = true

local colors = {
	bg = "#1b1e28",
	fg = "#a6accd",
	cursor = "#e4f0fb",
	selection_bg = "#2a2e3f",
	selection_fg = "#f8f8f2",
	-- Palette
	black = "#1b1e28",
	red = "#d0679d",
	green = "#5de4c7",
	yellow = "#fffac2",
	blue = "#89ddff",
	magenta = "#d2a6ff",
	cyan = "#add7ff",
	white = "#ffffff",
	bright_black = "#6c6f93",
	-- Extra colors for UI
	line = "#232530",
	comment = "#6c6f93",
	accent = "#5de4c7",
}

local hl = function(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- Editor
hl("Normal", { fg = colors.fg, bg = colors.bg })
hl("NormalFloat", { fg = colors.fg, bg = colors.bg })
hl("Cursor", { fg = colors.bg, bg = colors.cursor })
hl("CursorLine", { bg = colors.line })
hl("CursorLineNr", { fg = colors.accent, bg = colors.line })
hl("CursorColumn", { bg = colors.line })
hl("ColorColumn", { bg = colors.line })
hl("LineNr", { fg = colors.bright_black })
hl("SignColumn", { fg = colors.bright_black, bg = colors.bg })
hl("VertSplit", { fg = colors.selection_bg })
hl("WinSeparator", { fg = colors.selection_bg })
hl("StatusLine", { fg = colors.fg, bg = colors.selection_bg })
hl("StatusLineNC", { fg = colors.bright_black, bg = colors.bg })
hl("Pmenu", { fg = colors.fg, bg = colors.selection_bg })
hl("PmenuSel", { fg = colors.bg, bg = colors.accent })
hl("PmenuSbar", { bg = colors.selection_bg })
hl("PmenuThumb", { bg = colors.bright_black })
hl("TabLine", { fg = colors.bright_black, bg = colors.bg })
hl("TabLineFill", { bg = colors.bg })
hl("TabLineSel", { fg = colors.fg, bg = colors.selection_bg })
hl("Visual", { bg = colors.selection_bg })
hl("VisualNOS", { bg = colors.selection_bg })
hl("Search", { fg = colors.bg, bg = colors.yellow })
hl("IncSearch", { fg = colors.bg, bg = colors.accent })
hl("MatchParen", { fg = colors.accent, bold = true })
hl("Folded", { fg = colors.bright_black, bg = colors.selection_bg })
hl("FoldColumn", { fg = colors.bright_black, bg = colors.bg })
hl("NonText", { fg = colors.selection_bg })
hl("SpecialKey", { fg = colors.selection_bg })
hl("Directory", { fg = colors.blue })
hl("Title", { fg = colors.magenta, bold = true })
hl("ErrorMsg", { fg = colors.red })
hl("WarningMsg", { fg = colors.yellow })
hl("ModeMsg", { fg = colors.fg })
hl("MoreMsg", { fg = colors.accent })
hl("Question", { fg = colors.accent })
hl("EndOfBuffer", { fg = colors.bg })

-- Syntax
hl("Comment", { fg = colors.comment, italic = true })
hl("Constant", { fg = colors.yellow })
hl("String", { fg = colors.green })
hl("Character", { fg = colors.green })
hl("Number", { fg = colors.yellow })
hl("Boolean", { fg = colors.yellow })
hl("Float", { fg = colors.yellow })
hl("Identifier", { fg = colors.fg })
hl("Function", { fg = colors.blue })
hl("Statement", { fg = colors.magenta })
hl("Conditional", { fg = colors.magenta })
hl("Repeat", { fg = colors.magenta })
hl("Label", { fg = colors.cyan })
hl("Operator", { fg = colors.cyan })
hl("Keyword", { fg = colors.magenta })
hl("Exception", { fg = colors.red })
hl("PreProc", { fg = colors.cyan })
hl("Include", { fg = colors.magenta })
hl("Define", { fg = colors.magenta })
hl("Macro", { fg = colors.magenta })
hl("PreCondit", { fg = colors.magenta })
hl("Type", { fg = colors.cyan })
hl("StorageClass", { fg = colors.magenta })
hl("Structure", { fg = colors.cyan })
hl("Typedef", { fg = colors.cyan })
hl("Special", { fg = colors.cyan })
hl("SpecialChar", { fg = colors.yellow })
hl("Tag", { fg = colors.red })
hl("Delimiter", { fg = colors.fg })
hl("SpecialComment", { fg = colors.comment })
hl("Debug", { fg = colors.red })
hl("Underlined", { fg = colors.blue, underline = true })
hl("Ignore", { fg = colors.bright_black })
hl("Error", { fg = colors.red })
hl("Todo", { fg = colors.bg, bg = colors.yellow, bold = true })

-- Diff
hl("DiffAdd", { fg = colors.green, bg = colors.bg })
hl("DiffChange", { fg = colors.yellow, bg = colors.bg })
hl("DiffDelete", { fg = colors.red, bg = colors.bg })
hl("DiffText", { fg = colors.blue, bg = colors.bg })

-- Git
hl("gitcommitComment", { fg = colors.comment, italic = true })
hl("gitcommitUntracked", { fg = colors.comment, italic = true })
hl("gitcommitDiscarded", { fg = colors.comment, italic = true })
hl("gitcommitSelected", { fg = colors.comment, italic = true })
hl("gitcommitHeader", { fg = colors.magenta })
hl("gitcommitSelectedType", { fg = colors.blue })
hl("gitcommitUnmergedType", { fg = colors.blue })
hl("gitcommitDiscardedType", { fg = colors.blue })
hl("gitcommitBranch", { fg = colors.yellow, bold = true })
hl("gitcommitUntrackedFile", { fg = colors.cyan })
hl("gitcommitUnmergedFile", { fg = colors.red, bold = true })
hl("gitcommitDiscardedFile", { fg = colors.red, bold = true })
hl("gitcommitSelectedFile", { fg = colors.green, bold = true })

-- Diagnostics
hl("DiagnosticError", { fg = colors.red })
hl("DiagnosticWarn", { fg = colors.yellow })
hl("DiagnosticInfo", { fg = colors.blue })
hl("DiagnosticHint", { fg = colors.cyan })
hl("DiagnosticUnderlineError", { sp = colors.red, undercurl = true })
hl("DiagnosticUnderlineWarn", { sp = colors.yellow, undercurl = true })
hl("DiagnosticUnderlineInfo", { sp = colors.blue, undercurl = true })
hl("DiagnosticUnderlineHint", { sp = colors.cyan, undercurl = true })

-- LSP
hl("LspReferenceText", { bg = colors.selection_bg })
hl("LspReferenceRead", { bg = colors.selection_bg })
hl("LspReferenceWrite", { bg = colors.selection_bg })
hl("LspInlayHint", { fg = colors.bright_black })

-- Treesitter
hl("@variable", { fg = colors.fg })
hl("@variable.builtin", { fg = colors.red })
hl("@variable.parameter", { fg = colors.fg })
hl("@variable.member", { fg = colors.fg })
hl("@constant", { fg = colors.yellow })
hl("@constant.builtin", { fg = colors.yellow })
hl("@constant.macro", { fg = colors.yellow })
hl("@module", { fg = colors.cyan })
hl("@label", { fg = colors.cyan })
hl("@string", { fg = colors.green })
hl("@string.escape", { fg = colors.yellow })
hl("@string.special", { fg = colors.yellow })
hl("@character", { fg = colors.green })
hl("@character.special", { fg = colors.yellow })
hl("@number", { fg = colors.yellow })
hl("@number.float", { fg = colors.yellow })
hl("@boolean", { fg = colors.yellow })
hl("@type", { fg = colors.cyan })
hl("@type.builtin", { fg = colors.cyan })
hl("@type.definition", { fg = colors.cyan })
hl("@attribute", { fg = colors.cyan })
hl("@property", { fg = colors.fg })
hl("@function", { fg = colors.blue })
hl("@function.builtin", { fg = colors.blue })
hl("@function.macro", { fg = colors.magenta })
hl("@function.method", { fg = colors.blue })
hl("@constructor", { fg = colors.cyan })
hl("@operator", { fg = colors.cyan })
hl("@keyword", { fg = colors.magenta })
hl("@keyword.function", { fg = colors.magenta })
hl("@keyword.operator", { fg = colors.cyan })
hl("@keyword.return", { fg = colors.magenta })
hl("@keyword.conditional", { fg = colors.magenta })
hl("@keyword.repeat", { fg = colors.magenta })
hl("@keyword.import", { fg = colors.magenta })
hl("@keyword.exception", { fg = colors.magenta })
hl("@punctuation.delimiter", { fg = colors.fg })
hl("@punctuation.bracket", { fg = colors.fg })
hl("@punctuation.special", { fg = colors.cyan })
hl("@comment", { fg = colors.comment, italic = true })
hl("@tag", { fg = colors.red })
hl("@tag.attribute", { fg = colors.cyan })
hl("@tag.delimiter", { fg = colors.fg })
hl("@markup.heading", { fg = colors.magenta, bold = true })
hl("@markup.raw", { fg = colors.green })
hl("@markup.link", { fg = colors.blue })
hl("@markup.link.url", { fg = colors.blue, underline = true })
hl("@markup.list", { fg = colors.red })

-- Telescope
hl("TelescopeNormal", { fg = colors.fg, bg = colors.bg })
hl("TelescopeBorder", { fg = colors.bright_black, bg = colors.bg })
hl("TelescopePromptNormal", { fg = colors.fg, bg = colors.selection_bg })
hl("TelescopePromptBorder", { fg = colors.selection_bg, bg = colors.selection_bg })
hl("TelescopePromptTitle", { fg = colors.bg, bg = colors.accent })
hl("TelescopePreviewTitle", { fg = colors.bg, bg = colors.magenta })
hl("TelescopeResultsTitle", { fg = colors.bg, bg = colors.blue })
hl("TelescopeSelection", { fg = colors.fg, bg = colors.selection_bg })
hl("TelescopeMatching", { fg = colors.accent, bold = true })

-- NeoTree
hl("NeoTreeNormal", { fg = colors.fg, bg = colors.bg })
hl("NeoTreeNormalNC", { fg = colors.fg, bg = colors.bg })
hl("NeoTreeDirectoryName", { fg = colors.blue })
hl("NeoTreeDirectoryIcon", { fg = colors.blue })
hl("NeoTreeRootName", { fg = colors.magenta, bold = true })
hl("NeoTreeFileName", { fg = colors.fg })
hl("NeoTreeGitAdded", { fg = colors.green })
hl("NeoTreeGitModified", { fg = colors.yellow })
hl("NeoTreeGitDeleted", { fg = colors.red })
hl("NeoTreeGitConflict", { fg = colors.red, bold = true })
hl("NeoTreeGitUntracked", { fg = colors.bright_black })
hl("NeoTreeIndentMarker", { fg = colors.selection_bg })

-- GitSigns
hl("GitSignsAdd", { fg = colors.green })
hl("GitSignsChange", { fg = colors.yellow })
hl("GitSignsDelete", { fg = colors.red })

-- Indent Blankline
hl("IblIndent", { fg = colors.selection_bg })
hl("IblScope", { fg = colors.bright_black })
