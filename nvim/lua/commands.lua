vim.api.nvim_create_user_command("DiagnosticToggle", function()
	if vim.diagnostic.is_enabled() then
		vim.diagnostic.disable()
	else
		vim.diagnostic.enable()
	end
end, { desc = "toggle diagnostic" })

vim.api.nvim_create_user_command("CopyFileNameAndLine", function()
	local file_name = vim.fn.expand("%:t")
	local current_line = vim.fn.line(".")
	local clipboard_content = string.format("%s:%d", file_name, current_line)

	vim.fn.setreg("+", clipboard_content)
	print("Copied to clipboard: " .. clipboard_content)
end, {})
