local function current_rust_test_name()
	-- Get the current buffer and cursor position
	local bufnr = vim.api.nvim_get_current_buf()

	---@diagnostic disable-next-line: deprecated
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

	local function_declaration_line = 0
	local function_name = ""

	-- Check lines above the cursor for the #[test] attribute and function definition
	for i = row, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]

		-- Check for function start and capture the function name
		if line:match("^%s*fn%s") then
			function_declaration_line = i
			function_name = line:match("^%s*fn%s([%w_]+)%s*%(")
			break
		end
	end

	for i = function_declaration_line, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
		if line:match("^%s*#%[test%]") then
			return function_name
		end
	end

	return nil
end

return {
	"fcoury/vial.nvim",
	dir = "~/code/vial",
	config = function()
		require("vial").setup({
			vial_path = "/Users/fcoury/code/vial/target/debug/vial",

			file_types = {
				rust = {
					command = "cargo test %s -- --nocapture --color=always",
					extensions = { ".rs" },
					extract = current_rust_test_name,
				},
			},
		})
	end,
}
