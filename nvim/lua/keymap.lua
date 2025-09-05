local keymap = vim.keymap

-- -- remaps ; to act as :
-- keymap.set("n", ";", ":", { noremap = true })
--
-- keymap.set("n", "<leader>a", "ggVG", { desc = "select all" }) -- select all
-- keymap.set({ "n", "x" }, "<leader>p", '"0p', { desc = "paste and doesn't overwrite" }) -- paste not overwritten by delete
-- keymap.set("n", "U", "<C-r>", { noremap = true, desc = "redo" })
-- keymap.set("n", "H", "^", { noremap = true, desc = "move to beginning of line" })
-- keymap.set("n", "L", "$", { noremap = true, desc = "move to end of line" })
--
-- -- telescope
-- keymap.set("n", "<C-j>", "<cmd>Telescope buffers<cr>", { desc = "open buffers" })
-- keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "open buffers" })
-- keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics<cr>", { desc = "open diagnostics" })
-- keymap.set("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "open document symbols" })
-- keymap.set("n", "<leader>w", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "open workspace symbols" })
-- keymap.set("n", "<leader>k", "<cmd>Telescope lsp_references<cr>", { desc = "open references" })
-- keymap.set("n", "<C-t>", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "open document symbols" })

-- snipe
-- vim.keymap.set("n", "<S-l>", function()
-- 	local toggle = require("snipe").create_buffer_menu_toggler({
-- 		-- Limit the width of path buffer names
-- 		max_path_width = 1,
-- 	})
-- 	toggle()
-- end, { desc = "[P]Snipe" })

-- -- lsp and rust
-- keymap.set("n", "<leader>x", "<cmd>RustRunnables<cr>", { desc = "run rust runnables" })
-- -- keymap.set("n", "<leader>y", "<cmd>lua require'runst'.run_test()<cr>", { noremap = true, silent = true })
--
-- -- buffers
-- keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "next buffer" })
-- keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "previous buffer" })
-- -- keymap.set("n", "<leader>c", "<cmd>bd<cr>")
-- keymap.set("n", "<leader><leader>", "<cmd>b#<cr>", { desc = "switch to last buffer" })
--
-- -- splits
-- keymap.set("n", "|", "<cmd>vsplit<cr><c-w><c-w>", { desc = "split vertically" })
-- keymap.set("n", "_", "<cmd>split<cr>", { desc = "split horizontally" })
-- keymap.set("n", "=", "<cmd>wincmd =<cr>", { desc = "balance splits" })
--
-- -- lsp related
-- keymap.set("n", "<leader>,d", "<cmd>DiagnosticToggle<cr>", { desc = "toggle diagnostics" })
--
-- -- special commands
-- keymap.set(
-- 	"n",
-- 	"<leader>cl",
-- 	"<cmd>CopyFileNameAndLine<cr>",
-- 	{ noremap = true, silent = true, desc = "Copy current file name and line number" }
-- )
--
-- -- delete text (as opposed to saving it on the default register)
-- vim.api.nvim_set_keymap("n", "m", '"_x', { noremap = true, silent = true, desc = "delete text" })
-- vim.api.nvim_set_keymap("n", "mm", '"_dd', { noremap = true, silent = true, desc = "delete line" })
-- vim.api.nvim_set_keymap("v", "m", '"_x', { noremap = true, silent = true, desc = "delete text" })
-- vim.api.nvim_set_keymap("n", "mw", '"_dw', { noremap = true, silent = true, desc = "delete word" })
-- vim.api.nvim_set_keymap("n", "miw", '"_diw', { noremap = true, silent = true, desc = "delete inner word" })

--== Helper Functions ==--

-- disable arrows except in replace mode
function _G_disable_arrows()
	keymap.set({ "n", "v", "i" }, "<up>", "<nop>")
	keymap.set({ "n", "v", "i" }, "<down>", "<nop>")
	keymap.set({ "n", "v", "i" }, "<left>", "<nop>")
	keymap.set({ "n", "v", "i" }, "<right>", "<nop>")
end

function _G_enable_arrows()
	keymap.set({ "n", "v", "i" }, "<up>", "<up>")
	keymap.set({ "n", "v", "i" }, "<down>", "<down>")
	keymap.set({ "n", "v", "i" }, "<left>", "<left>")
	keymap.set({ "n", "v", "i" }, "<right>", "<right>")
end

vim.api.nvim_exec(
	[[
  augroup ArrowKeysInReplaceMode
    autocmd!
    autocmd ModeChanged * lua if vim.fn.mode() == "R" then _G_enable_arrows() else _G_disable_arrows() end
  augroup END
  ]],
	false
)

-- move up and down with j and k when count is 0 and with gj and gk when count is not 0

_G.conditional_move_j = function()
	if vim.v.count == 0 then
		return "gj"
	else
		return "j"
	end
end

_G.conditional_move_k = function()
	if vim.v.count == 0 then
		return "gk"
	else
		return "k"
	end
end

-- keymap.set("n", "j", "v:lua.conditional_move_j()", { expr = true, noremap = true })
-- keymap.set("n", "k", "v:lua.conditional_move_k()", { expr = true, noremap = true })

-- Quote toggle function - cycles through ', ", and `
_G.toggle_quotes = function()
	local line = vim.api.nvim_get_current_line()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	
	-- Find the quote character at or around cursor position
	local quote_chars = { "'", '"', "`" }
	local quote_found = nil
	local start_pos = nil
	local end_pos = nil
	
	-- Check character at cursor first
	if col <= #line then
		local char_at_cursor = line:sub(col + 1, col + 1)
		for _, q in ipairs(quote_chars) do
			if char_at_cursor == q then
				-- Find matching quote
				local before = line:sub(1, col)
				local after = line:sub(col + 2)
				local start_quote = before:reverse():find(q)
				local end_quote = after:find(q)
				
				if start_quote and end_quote then
					quote_found = q
					start_pos = col + 1 - start_quote
					end_pos = col + 1 + end_quote
					break
				end
			end
		end
	end
	
	-- If not found at cursor, search around cursor position
	if not quote_found then
		for _, q in ipairs(quote_chars) do
			local before = line:sub(1, col + 1)
			local after = line:sub(col + 1)
			
			local last_quote_before = before:reverse():find(q)
			local first_quote_after = after:find(q)
			
			if last_quote_before and first_quote_after then
				quote_found = q
				start_pos = col + 2 - last_quote_before
				end_pos = col + first_quote_after
				break
			end
		end
	end
	
	if quote_found and start_pos and end_pos then
		-- Determine next quote type
		local next_quote
		if quote_found == "'" then
			next_quote = '"'
		elseif quote_found == '"' then
			next_quote = "`"
		else
			next_quote = "'"
		end
		
		-- Replace the quotes
		local new_line = line:sub(1, start_pos - 1) .. next_quote .. line:sub(start_pos + 1, end_pos - 1) .. next_quote .. line:sub(end_pos + 1)
		vim.api.nvim_set_current_line(new_line)
	end
end

-- Keybinding for quote toggle (Cmd+' on macOS, Ctrl+' on other systems)
if vim.fn.has('mac') == 1 then
	keymap.set({ "n", "i" }, "<D-'>", function() _G.toggle_quotes() end, { desc = "Toggle quotes", silent = true })
else
	keymap.set({ "n", "i" }, "<C-'>", function() _G.toggle_quotes() end, { desc = "Toggle quotes", silent = true })
end

_G_disable_arrows()
