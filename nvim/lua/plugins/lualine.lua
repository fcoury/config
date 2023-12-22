return {
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			local function truncated_git_branch()
				local handle = io.popen("git symbolic-ref --short HEAD 2>/dev/null")
				local branch = handle:read("*a") or ""
				handle:close()

				branch = branch:gsub("\n", "")
				if #branch > 25 then
					local parts = {}
					for part in string.gmatch(branch, "[^/]+") do
						table.insert(parts, part)
					end
					if #parts >= 3 then
						return parts[1]:sub(1, 1) .. "/" .. parts[2]:sub(1, 1) .. "/" .. parts[3]
					end
				end
				return branch
			end

			require("lualine").setup({
				options = {
					theme = "dracula",
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						{ truncated_git_branch, icon = "", color = { fg = "#8be9fd", gui = "bold" } },
						"diff",
						"diagnostics",
					},
					lualine_c = {
						{ "filename", file_status = true, path = 1 },
					},
					-- lualine_x = { "require'lsp-status'.status()" },
					-- lualine_x = { require("lsp-progress").progress },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
}
