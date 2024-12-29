-- Define a custom text object for double quotes
function _G.select_inside_quotes()
	local _, col_start = unpack(vim.fn.searchpos('"', "bcn")) -- Find opening quote
	local _, col_end = unpack(vim.fn.searchpos('"', "cn")) -- Find closing quote
	if col_start == 0 or col_end == 0 or col_start == col_end then
		return
	end
	vim.fn.setpos(".", { 0, vim.fn.line("."), col_start + 1, 0 }) -- Move cursor to opening quote
	vim.cmd("normal! v") -- Start visual mode
	vim.fn.setpos(".", { 0, vim.fn.line("."), col_end - 1, 0 }) -- Move cursor to closing quote
end

function _G.select_around_quotes()
	local _, col_start = unpack(vim.fn.searchpos('"', "bcn")) -- Find opening quote
	local _, col_end = unpack(vim.fn.searchpos('"', "cn")) -- Find closing quote
	if col_start == 0 or col_end == 0 or col_start == col_end then
		return
	end
	vim.fn.setpos(".", { 0, vim.fn.line("."), col_start, 0 }) -- Move cursor to opening quote
	vim.cmd("normal! v") -- Start visual mode
	vim.fn.setpos(".", { 0, vim.fn.line("."), col_end, 0 }) -- Move cursor to after closing quote
end

-- Register the custom text objects
-- vim.api.nvim_set_keymap("x", "iq", ":lua select_inside_quotes()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("o", "iq", ":lua select_inside_quotes()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("x", "aq", ":lua select_around_quotes()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("o", "aq", ":lua select_around_quotes()<CR>", { noremap = true, silent = true })
--

-- require("legendary").keymaps({
-- })
