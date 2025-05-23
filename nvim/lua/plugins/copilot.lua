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
						accept = "<C-l>",
						next = "<M-]>",
						prev = "<M-[>",
					},
				},
				filetypes = {
					markdown = true, -- Explicitly enable for markdown
					["*"] = true, -- Enable for all other filetypes
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
	-- {
	-- 	"MeanderingProgrammer/render-markdown.nvim",
	-- 	optional = true,
	-- 	opts = {
	-- 		file_types = { "markdown", "copilot-chat" },
	-- 	},
	-- 	ft = { "markdown", "copilot-chat" },
	-- },
	-- {
	-- 	"CopilotC-Nvim/CopilotChat.nvim",
	-- 	dependencies = {
	-- 		{ "zbirenbaum/copilot.lua" },
	-- 	},
	-- 	cmd = "CopilotChat",
	-- 	build = "make tiktoken",
	-- 	keys = {
	-- 		{
	-- 			"<leader>ch",
	-- 			"<cmd>CopilotChat<cr>",
	-- 			mode = "n",
	-- 			desc = "Open Copilot Chat",
	-- 			silent = true,
	-- 		},
	-- 	},
	-- 	config = function()
	-- 		require("CopilotChat").setup()
	-- 	end,
	-- },
}
