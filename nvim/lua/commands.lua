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

vim.api.nvim_create_user_command("CopyRelativePath", function()
	-- Get the full path of the current file
	local full_path = vim.fn.expand("%:p")

	-- Try to get the git root directory
	local git_root = vim.fn.system("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel")
	git_root = vim.fn.trim(git_root)

	-- Fallback to cwd if not in a git repo
	local project_root = (git_root ~= "" and not git_root:match("fatal")) and git_root or vim.fn.getcwd()

	-- Create relative path by removing the project root from the full path
	local relative_path = full_path:sub(#project_root + 2) -- +2 to account for the trailing slash

	-- Format the clipboard content
	local clipboard_content = string.format("@%s", relative_path)

	-- Copy to clipboard
	vim.fn.setreg("+", clipboard_content)
	print("Copied to clipboard: " .. clipboard_content)
end, {})

vim.api.nvim_create_user_command("CopyRelativePathAndLineForLLM", function()
	-- Get the full path of the current file
	local full_path = vim.fn.expand("%:p")

	-- Try to get the git root directory
	local git_root = vim.fn.system("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel")
	git_root = vim.fn.trim(git_root)

	-- Fallback to cwd if not in a git repo
	local project_root = (git_root ~= "" and not git_root:match("fatal")) and git_root or vim.fn.getcwd()

	-- Get the current line number
	local current_line = vim.fn.line(".")

	-- Create relative path by removing the project root from the full path
	local relative_path = full_path:sub(#project_root + 2) -- +2 to account for the trailing slash

	-- Format the clipboard content
	local clipboard_content = string.format("@%s line %d", relative_path, current_line)

	-- Copy to clipboard
	vim.fn.setreg("+", clipboard_content)
	print("Copied to clipboard: " .. clipboard_content)
end, {})

vim.api.nvim_create_user_command("CopyRelativePathAndLine", function()
	-- Get the full path of the current file
	local full_path = vim.fn.expand("%:p")

	-- Try to get the git root directory
	local git_root = vim.fn.system("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel")
	git_root = vim.fn.trim(git_root)

	-- Fallback to cwd if not in a git repo
	local project_root = (git_root ~= "" and not git_root:match("fatal")) and git_root or vim.fn.getcwd()

	-- Get the current line number
	local current_line = vim.fn.line(".")

	-- Create relative path by removing the project root from the full path
	local relative_path = full_path:sub(#project_root + 2) -- +2 to account for the trailing slash

	-- Format the clipboard content
	local clipboard_content = string.format("%s:%d", relative_path, current_line)

	-- Copy to clipboard
	vim.fn.setreg("+", clipboard_content)
	print("Copied to clipboard: " .. clipboard_content)
end, {})

vim.api.nvim_create_user_command("StripFirstTwoColumns", function()
	local buf = vim.api.nvim_get_current_buf()

	if not vim.api.nvim_buf_is_loaded(buf) then
		return
	end

	-- Avoid modifying unmodifiable/readonly buffers
	if vim.bo[buf].modifiable == false or vim.bo[buf].readonly then
		vim.notify("Buffer is not modifiable", vim.log.levels.WARN)
		return
	end

	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local count = #lines

	if count == 0 then
		return
	end

	-- Remove last line if it's empty/whitespace
	if lines[count]:match("^%s*$") then
		table.remove(lines, count)
		count = count - 1
	end

	-- Remove the first two columns from every remaining line
	for i = 1, count do
		lines[i] = lines[i]:sub(3)
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end, { desc = "Strip first two columns and trailing empty line" })

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "qf",
-- 	callback = function()
-- 		vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR>:cclose<CR>", { noremap = true, silent = true })
-- 	end,
-- })
