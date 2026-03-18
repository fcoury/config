-- inline git diff viewer with delta syntax highlighting
-- NOTE: delta.lua's parser expects a/b prefixes in diffs but diff.mnemonicPrefix
-- uses c/w/i prefixes, so we monkey-patch vim.system to inject -c diff.mnemonicPrefix=false
-- on git diff calls used by deltaview
return {
	"kokusenz/deltaview.nvim",
	dependencies = {
		{ "kokusenz/delta.lua", config = true },
	},
	keys = {
		{ "<leader>dl", "<cmd>DeltaView<cr>", desc = "DeltaView (current file)" },
		{ "<leader>dm", "<cmd>DeltaMenu<cr>", desc = "DeltaMenu (all changed files)" },
		{ "<leader>da", "<cmd>Delta<cr>", desc = "Delta (full diff)" },
	},
	config = function()
		-- Wrap vim.system so git-diff calls used by deltaview/delta.lua
		-- always produce standard a/b prefixes regardless of mnemonicPrefix
		local orig_system = vim.system
		vim.system = function(cmd, ...)
			if type(cmd) == "table" and cmd[1] == "git" then
				local has_diff = false
				for _, arg in ipairs(cmd) do
					if arg == "diff" or arg == "show" then
						has_diff = true
						break
					end
				end
				if has_diff then
					local patched = { "git", "-c", "diff.mnemonicPrefix=false" }
					for i = 2, #cmd do
						table.insert(patched, cmd[i])
					end
					return orig_system(patched, ...)
				end
			end
			return orig_system(cmd, ...)
		end

		require("deltaview").setup({
			use_nerdfonts = true,
			line_numbers = false,
		})
	end,
}
