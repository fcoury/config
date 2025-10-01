return {
	"yetone/avante.nvim",
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- ⚠️ must add this setting! ! !
	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	---@module 'avante'
	---@type avante.Config
	opts = {
		-- behaviour = {
		-- 	auto_set_keymaps = false,
		-- },
		mappings = {
			---@class AvanteConflictMappings
			diff = {
				ours = "co",
				theirs = "ct",
				all_theirs = "ca",
				both = "cb",
				cursor = "cc",
				next = "]x",
				prev = "[x",
			},
			suggestion = {
				accept = "<M-l>",
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
			jump = {
				next = "]]",
				prev = "[[",
			},
			submit = {
				normal = "<CR>",
				insert = "<C-l>",
			},
			cancel = {
				normal = { "<C-c>", "<Esc>", "q" },
				insert = { "<C-c>" },
			},
			-- NOTE: The following will be safely set by avante.nvim
			ask = "<leader>va",
			new_ask = "<leader>vn",
			zen_mode = "<leader>vz",
			edit = "<leader>ve",
			refresh = "<leader>vr",
			focus = "<leader>vf",
			stop = "<leader>vS",
			toggle = {
				default = "<leader>vt",
				debug = "<leader>vd",
				selection = "<leader>vC",
				suggestion = "<leader>vs",
				repomap = "<leader>vR",
			},
			sidebar = {
				expand_tool_use = "<S-Tab>",
				next_prompt = "]p",
				prev_prompt = "[p",
				apply_all = "A",
				apply_cursor = "a",
				retry_user_request = "r",
				edit_user_request = "e",
				switch_windows = "<Tab>",
				reverse_switch_windows = "<S-Tab>",
				toggle_code_window = "x",
				remove_file = "d",
				add_file = "@",
				close = { "q" },
				---@alias AvanteCloseFromInput { normal: string | nil, insert: string | nil }
				---@type AvanteCloseFromInput | nil
				close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
				---@alias AvanteToggleCodeWindowFromInput { normal: string | nil, insert: string | nil }
				---@type AvanteToggleCodeWindowFromInput | nil
				toggle_code_window_from_input = nil, -- e.g., { normal = "x", insert = "<C-;>" }
			},
			files = {
				add_current = "<leader>vc", -- Add current buffer to selected files
				add_all_buffers = "<leader>vB", -- Add all buffer files to selected files
			},
			select_model = "<leader>v?", -- Select model command
			select_history = "<leader>vh", -- Select history command
			confirm = {
				focus_window = "<C-w>f",
				code = "c",
				resp = "r",
				input = "i",
			},
		},
		-- add any opts here
		-- this file can contain specific instructions for your project
		instructions_file = "avante.md",
		-- for example
		provider = "cerebras",
		providers = {
			cerebras = {
				__inherited_from = "openai",
				endpoint = "https://api.cerebras.ai/v1",
				model = "qwen-3-coder-480b",
				api_key_name = "CEREBRAS_API_KEY",
				timeout = 30000, -- Timeout in milliseconds
			},
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-sonnet-4-5-20250929",
				timeout = 30000, -- Timeout in milliseconds
				extra_request_body = {
					temperature = 0.75,
					max_tokens = 20480,
				},
			},
			moonshot = {
				endpoint = "https://api.moonshot.ai/v1",
				model = "kimi-k2-0711-preview",
				timeout = 30000, -- Timeout in milliseconds
				extra_request_body = {
					temperature = 0.75,
					max_tokens = 32768,
				},
			},
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-mini/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"stevearc/dressing.nvim", -- for input provider dressing
		"folke/snacks.nvim", -- for input provider snacks
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "copilot-chat", "Avante" },
			},
			ft = { "markdown", "copilot-chat", "Avante" },
		},
	},
}
