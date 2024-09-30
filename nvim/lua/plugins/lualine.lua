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

			vim.g.VM_set_statusline = 0
			vim.g.VM_silent_exit = 1

			local function vm_mode()
				return vim.iter(string.gmatch(vim.fn["vm#themes#statusline"](), "%S+")):nth(2)
			end

			local function vm_status()
				return vim.fn["VMInfos"]().status or ""
			end

			vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
				pattern = { "@" },
				callback = function(ev)
					if vim.b.visual_multi then
						local delay = 0
						vim.defer_fn(function()
							vim.cmd('execute "redrawstatus"')
						end, delay)
					end
				end,
			})

			require("lualine").setup({
				options = {
					theme = "auto",
					-- theme = "nightfly",
					-- theme = "horizon",
					-- theme = "dracula",
					-- theme = "lackluster",
					-- theme = "gruvbox",
					-- theme = "rose-pine",
					-- theme = "iceberg_dark",
					-- theme = "nord",
					-- theme = "catppuccin",
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(mode)
								return vm_mode() or mode
							end,
						},
					},
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
