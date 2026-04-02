-- Termy Dark theme for Neovim
-- Ported from Zed theme by lassejlv
-- https://gist.github.com/lassejlv/5f4218a1b9f7c28180085f70f9a65090

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "termy-dark"
vim.o.termguicolors = true

local colors = {
	bg = "#070a14",
	fg = "#e8ecf8",
	surface = "#0b1020",
	element = "#151c2d",
	hover = "#1d2538",
	active = "#30385a",
	border = "#232a3b",
	active_line = "#111830",
	line_nr = "#5f6f99",
	active_line_nr = "#9fa9d6",
	muted = "#95a0c5",
	placeholder = "#69749b",
	-- Syntax palette
	keyword = "#ff9cb1",
	func = "#8ac5ff",
	method = "#96e4ff",
	string = "#9df0a7",
	type = "#ffe28a",
	operator = "#b8bff0",
	punctuation = "#9fa9d6",
	bracket = "#69749b",
	delimiter = "#84bbf3",
	tag = "#ff8fa3",
	variable_special = "#ff8fa3",
	-- Semantic
	error = "#ff6f8d",
	warning = "#ffe28a",
	info = "#8ac5ff",
	hint = "#1abc9c",
	success = "#9df0a7",
	modified = "#e0af68",
	deleted = "#ff8fa3",
	conflict = "#ff9e64",
	created = "#73daca",
	-- Cursor / selection
	cursor = "#7aa2f7",
	selection = "#1a2240",
	search = "#3d59a1",
}

local hl = function(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- Editor
hl("Normal", { fg = colors.fg, bg = colors.bg })
hl("NormalFloat", { fg = colors.fg, bg = colors.surface })
hl("FloatBorder", { fg = colors.border, bg = colors.surface })
hl("Cursor", { fg = colors.bg, bg = colors.cursor })
hl("CursorLine", { bg = colors.active_line })
hl("CursorLineNr", { fg = colors.active_line_nr, bg = colors.active_line })
hl("CursorColumn", { bg = colors.active_line })
hl("ColorColumn", { bg = colors.active_line })
hl("LineNr", { fg = colors.line_nr })
hl("SignColumn", { fg = colors.line_nr, bg = colors.bg })
hl("VertSplit", { fg = colors.border })
hl("WinSeparator", { fg = colors.border })
hl("StatusLine", { fg = colors.fg, bg = colors.surface })
hl("StatusLineNC", { fg = colors.muted, bg = colors.bg })
hl("Pmenu", { fg = colors.fg, bg = colors.surface })
hl("PmenuSel", { fg = colors.bg, bg = colors.cursor })
hl("PmenuSbar", { bg = colors.border })
hl("PmenuThumb", { bg = colors.active })
hl("TabLine", { fg = colors.muted, bg = colors.bg })
hl("TabLineFill", { bg = colors.bg })
hl("TabLineSel", { fg = colors.fg, bg = colors.surface })
hl("Visual", { bg = colors.search })
hl("VisualNOS", { bg = colors.search })
hl("Search", { fg = colors.fg, bg = colors.search })
hl("IncSearch", { fg = colors.bg, bg = colors.cursor })
hl("CurSearch", { fg = colors.bg, bg = colors.cursor })
hl("MatchParen", { fg = colors.warning, bold = true })
hl("Folded", { fg = colors.muted, bg = colors.element })
hl("FoldColumn", { fg = colors.line_nr, bg = colors.bg })
hl("NonText", { fg = colors.border })
hl("SpecialKey", { fg = colors.border })
hl("Directory", { fg = colors.func })
hl("Title", { fg = colors.func, bold = true })
hl("ErrorMsg", { fg = colors.error })
hl("WarningMsg", { fg = colors.warning })
hl("ModeMsg", { fg = colors.fg })
hl("MoreMsg", { fg = colors.success })
hl("Question", { fg = colors.success })
hl("EndOfBuffer", { fg = colors.bg })
hl("WildMenu", { fg = colors.bg, bg = colors.cursor })
hl("WinBar", { fg = colors.fg, bg = colors.bg })
hl("WinBarNC", { fg = colors.muted, bg = colors.bg })

-- Syntax
hl("Comment", { fg = colors.placeholder, italic = true })
hl("Constant", { fg = colors.keyword })
hl("String", { fg = colors.string })
hl("Character", { fg = colors.string })
hl("Number", { fg = colors.keyword })
hl("Boolean", { fg = colors.keyword })
hl("Float", { fg = colors.keyword })
hl("Identifier", { fg = colors.fg })
hl("Function", { fg = colors.func })
hl("Statement", { fg = colors.keyword })
hl("Conditional", { fg = colors.keyword })
hl("Repeat", { fg = colors.keyword })
hl("Label", { fg = colors.type })
hl("Operator", { fg = colors.operator })
hl("Keyword", { fg = colors.keyword })
hl("Exception", { fg = colors.keyword })
hl("PreProc", { fg = colors.keyword })
hl("Include", { fg = colors.keyword })
hl("Define", { fg = colors.keyword })
hl("Macro", { fg = colors.keyword })
hl("PreCondit", { fg = colors.keyword })
hl("Type", { fg = colors.type })
hl("StorageClass", { fg = colors.keyword })
hl("Structure", { fg = colors.type })
hl("Typedef", { fg = colors.type })
hl("Special", { fg = colors.method })
hl("SpecialChar", { fg = colors.func })
hl("Tag", { fg = colors.tag })
hl("Delimiter", { fg = colors.delimiter })
hl("SpecialComment", { fg = colors.placeholder, italic = true })
hl("Debug", { fg = colors.error })
hl("Underlined", { fg = colors.func, underline = true })
hl("Ignore", { fg = colors.placeholder })
hl("Error", { fg = colors.error })
hl("Todo", { fg = colors.bg, bg = colors.warning, bold = true })

-- Diff
hl("DiffAdd", { fg = colors.created, bg = "#0d1a1a" })
hl("DiffChange", { fg = colors.modified, bg = "#1a1610" })
hl("DiffDelete", { fg = colors.deleted, bg = "#1a0d12" })
hl("DiffText", { fg = colors.info, bg = "#0d1520" })

-- Git
hl("gitcommitComment", { fg = colors.placeholder, italic = true })
hl("gitcommitUntracked", { fg = colors.placeholder, italic = true })
hl("gitcommitDiscarded", { fg = colors.placeholder, italic = true })
hl("gitcommitSelected", { fg = colors.placeholder, italic = true })
hl("gitcommitHeader", { fg = colors.keyword })
hl("gitcommitSelectedType", { fg = colors.func })
hl("gitcommitUnmergedType", { fg = colors.func })
hl("gitcommitDiscardedType", { fg = colors.func })
hl("gitcommitBranch", { fg = colors.type, bold = true })
hl("gitcommitUntrackedFile", { fg = colors.method })
hl("gitcommitUnmergedFile", { fg = colors.error, bold = true })
hl("gitcommitDiscardedFile", { fg = colors.error, bold = true })
hl("gitcommitSelectedFile", { fg = colors.string, bold = true })

-- Diagnostics
hl("DiagnosticError", { fg = colors.error })
hl("DiagnosticWarn", { fg = colors.warning })
hl("DiagnosticInfo", { fg = colors.info })
hl("DiagnosticHint", { fg = colors.hint })
hl("DiagnosticUnderlineError", { sp = colors.error, undercurl = true })
hl("DiagnosticUnderlineWarn", { sp = colors.warning, undercurl = true })
hl("DiagnosticUnderlineInfo", { sp = colors.info, undercurl = true })
hl("DiagnosticUnderlineHint", { sp = colors.hint, undercurl = true })

-- LSP
hl("LspReferenceText", { bg = colors.element })
hl("LspReferenceRead", { bg = colors.element })
hl("LspReferenceWrite", { bg = colors.element })
hl("LspInlayHint", { fg = colors.line_nr })

-- Treesitter
hl("@variable", { fg = colors.fg })
hl("@variable.builtin", { fg = colors.variable_special })
hl("@variable.parameter", { fg = colors.fg })
hl("@variable.member", { fg = colors.type })
hl("@constant", { fg = colors.keyword })
hl("@constant.builtin", { fg = colors.keyword })
hl("@constant.macro", { fg = colors.keyword })
hl("@module", { fg = colors.type })
hl("@label", { fg = colors.type })
hl("@string", { fg = colors.string })
hl("@string.escape", { fg = colors.func })
hl("@string.special", { fg = colors.string })
hl("@string.regex", { fg = colors.method })
hl("@character", { fg = colors.string })
hl("@character.special", { fg = colors.func })
hl("@number", { fg = colors.keyword })
hl("@number.float", { fg = colors.keyword })
hl("@boolean", { fg = colors.keyword })
hl("@type", { fg = colors.type })
hl("@type.builtin", { fg = colors.type })
hl("@type.definition", { fg = colors.type })
hl("@attribute", { fg = colors.func })
hl("@property", { fg = colors.type })
hl("@function", { fg = colors.func })
hl("@function.builtin", { fg = colors.func })
hl("@function.macro", { fg = colors.method })
hl("@function.method", { fg = colors.method })
hl("@constructor", { fg = colors.type })
hl("@operator", { fg = colors.operator })
hl("@keyword", { fg = colors.keyword })
hl("@keyword.function", { fg = colors.keyword })
hl("@keyword.operator", { fg = colors.operator })
hl("@keyword.return", { fg = colors.keyword })
hl("@keyword.conditional", { fg = colors.keyword })
hl("@keyword.repeat", { fg = colors.keyword })
hl("@keyword.import", { fg = colors.keyword })
hl("@keyword.exception", { fg = colors.keyword })
hl("@punctuation.delimiter", { fg = colors.delimiter })
hl("@punctuation.bracket", { fg = colors.bracket })
hl("@punctuation.special", { fg = colors.operator })
hl("@comment", { fg = colors.placeholder, italic = true })
hl("@tag", { fg = colors.tag })
hl("@tag.attribute", { fg = colors.func })
hl("@tag.delimiter", { fg = colors.punctuation })
hl("@markup.heading", { fg = colors.func, bold = true })
hl("@markup.raw", { fg = colors.string })
hl("@markup.link", { fg = colors.string, italic = true })
hl("@markup.link.url", { fg = colors.method, underline = true })
hl("@markup.list", { fg = colors.type })

-- Telescope
hl("TelescopeNormal", { fg = colors.fg, bg = colors.bg })
hl("TelescopeBorder", { fg = colors.border, bg = colors.bg })
hl("TelescopePromptNormal", { fg = colors.fg, bg = colors.element })
hl("TelescopePromptBorder", { fg = colors.element, bg = colors.element })
hl("TelescopePromptTitle", { fg = colors.bg, bg = colors.cursor })
hl("TelescopePreviewTitle", { fg = colors.bg, bg = colors.string })
hl("TelescopeResultsTitle", { fg = colors.bg, bg = colors.func })
hl("TelescopeSelection", { fg = colors.fg, bg = colors.element })
hl("TelescopeMatching", { fg = colors.cursor, bold = true })

-- NeoTree
hl("NeoTreeNormal", { fg = colors.fg, bg = colors.bg })
hl("NeoTreeNormalNC", { fg = colors.fg, bg = colors.bg })
hl("NeoTreeDirectoryName", { fg = colors.func })
hl("NeoTreeDirectoryIcon", { fg = colors.func })
hl("NeoTreeRootName", { fg = colors.keyword, bold = true })
hl("NeoTreeFileName", { fg = colors.fg })
hl("NeoTreeGitAdded", { fg = colors.created })
hl("NeoTreeGitModified", { fg = colors.modified })
hl("NeoTreeGitDeleted", { fg = colors.deleted })
hl("NeoTreeGitConflict", { fg = colors.conflict, bold = true })
hl("NeoTreeGitUntracked", { fg = colors.muted })
hl("NeoTreeIndentMarker", { fg = colors.border })

-- GitSigns
hl("GitSignsAdd", { fg = colors.created })
hl("GitSignsChange", { fg = colors.modified })
hl("GitSignsDelete", { fg = colors.deleted })

-- Indent Blankline
hl("IblIndent", { fg = colors.border })
hl("IblScope", { fg = colors.active })
