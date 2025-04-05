local function get_params()
	local winid = vim.api.nvim_get_current_win()
	local params = vim.lsp.util.make_position_params(winid, "utf-8")
	params.textDocument = vim.lsp.util.make_text_document_params()
	return params
end

local function get_current_test_args()
	local params = get_params()
	local result = vim.lsp.buf_request_sync(0, "experimental/runnables", params, 1000)
	if result and result[1] and result[1].result then
		for _, runnable in ipairs(result[1].result) do
			if runnable.kind == "cargo" and runnable.args.executableArgs then
				local args = runnable.args.executableArgs
				-- Check if this is a specific test
				if #args >= 1 and args[1]:match("^[%w_:]+::[%w_]+$") and runnable.label:match("^test ") then
					return runnable.args
				end
			end
		end
	end
	return nil
end

local function current_test_name_regex()
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

local function current_rust_test_name()
	local cmd
	if pcall(require, "lspconfig") then
		local args = get_current_test_args()
		if args == nil then
			return nil
		end
		cmd = table.concat(args.cargoArgs, " ") .. " -- " .. table.concat(args.executableArgs, " ") -- .. " --nocapture"
	else
		local test_name = current_test_name_regex()
		if test_name == nil then
			return nil
		end
		cmd = "test %s -- --nocapture --color=always"
	end

	return cmd
end

return {
	"fcoury/vial.nvim",
	dir = "~/code/vial",
	config = function()
		require("vial").setup({
			vial_path = "/Users/fcoury/.cargo/bin/vial",

			file_types = {
				rust = {
					command = "CARGO_TERM_COLOR=always cargo %s",
					extensions = { ".rs" },
					extract = current_rust_test_name,
				},
			},
		})
	end,
}
