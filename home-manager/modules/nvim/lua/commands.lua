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

vim.api.nvim_create_user_command("StripFirstTwoColumns", function()
	local buf = vim.api.nvim_get_current_buf()

	if not vim.api.nvim_buf_is_loaded(buf) then
		return
	end

	if vim.bo[buf].modifiable == false or vim.bo[buf].readonly then
		vim.notify("Buffer is not modifiable", vim.log.levels.WARN)
		return
	end

	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local count = #lines

	if count == 0 then
		return
	end

	if lines[count]:match("^%s*$") then
		table.remove(lines, count)
		count = count - 1
	end

	for i = 1, count do
		lines[i] = lines[i]:sub(3)
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end, { desc = "Strip first two columns and trailing empty line" })
