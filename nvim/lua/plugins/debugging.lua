return {
	"rcarriga/nvim-dap-ui",
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<Leader>Db",
				function()
					require("dap").toggle_breakpoint()
				end,
				mode = { "n" },
				desc = "Toggle breakpoint",
			},
			{
				"<Leader>Dc",
				function()
					require("dap").continue()
				end,
				mode = { "n" },
				desc = "Continue or Start debugger",
			},
		},
		dependendecies = {
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			-- where to find lldb-dap
			local dap = require("dap")
			local dapui = require("dapui")

			-- initialize debugger UI
			dapui.setup()

			-- dapui events to auto open and close debugger ui
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- rust lldb config
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/"
			local codelldb_path = mason_path .. "codelldb/codelldb"

			dap.adapters.lldb = {
				type = "executable",
				command = codelldb_path,
				name = "lldb",
			}

			-- rust config for debugging
			dap.configurations.rust = {
				{
					name = "Launch",
					type = "lldb",
					request = "launch",
					initCommands = function()
						-- Find out where to look for the pretty printer Python module
						local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

						local script_import = 'command script import "'
							.. rustc_sysroot
							.. '/lib/rustlib/etc/lldb_lookup.py"'
						local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

						local commands = {}
						local file = io.open(commands_file, "r")
						if file then
							for line in file:lines() do
								table.insert(commands, line)
							end
							file:close()
						end
						table.insert(commands, 1, script_import)

						return commands
					end,
				},
			}

			-- python configuration
			dap.configurations.python = {
				{
					-- The first three options are required by nvim-dap
					type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
					request = "launch",
					name = "Launch file",

					-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

					program = "${file}", -- This configuration will launch the current file if used.
					pythonPath = function()
						-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
						-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
						-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
						local cwd = vim.fn.getcwd()
						if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
							return cwd .. "/venv/bin/python"
						elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
							return cwd .. "/.venv/bin/python"
						else
							return "/usr/bin/python3"
						end
					end,
				},
			}
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			-- global python debug setup
			require("dap-python").setup("python3")
		end,
	},
}
