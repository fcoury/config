return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = "<c-l>",
						next = "<M-]>",
						prev = "<M-[>",
					},
				},
			})
		end,
	},
	-- {
	-- 	"zbirenbaum/copilot-cmp",
	-- 	config = function()
	-- 		require("copilot_cmp").setup()
	-- 	end,
	-- },
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
		},
		cmd = "CopilotChat",
		build = "make tiktoken",
		keys = {
			{
				"<leader>ch",
				"<cmd>CopilotChat<cr>",
				mode = "n",
				desc = "Open Copilot Chat",
				silent = true,
			},
		},
		config = function()
			require("CopilotChat").setup()
		end,
	},
}
