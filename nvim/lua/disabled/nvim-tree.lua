return {
	"nvim-tree/nvim-tree.lua",
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		local api = require("nvim-tree.api")
		local lib = require("nvim-tree.lib")

		vim.keymap.set("v", "<C-e>", api.tree.toggle)
		vim.keymap.set("n", "<C-e>", api.tree.toggle)

		local function my_on_attach(bufnr)
			local function opts(desc)
				return {
					desc = "nvim-tree: " .. desc,
					buffer = bufnr,
					noremap = true,
					silent = true,
					nowait = true,
				}
			end

			api.config.mappings.default_on_attach(bufnr)

			vim.keymap.set("v", "<C-e>", api.tree.toggle, opts("Toggle"))
			vim.keymap.set("n", "<C-e>", api.tree.toggle, opts("Toggle"))
			vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
			vim.keymap.set("n", "l", function()
				local node = lib.get_node_at_cursor()
				if node then
					if node.nodes then
						lib.expand_or_collapse(node)
					else
						api.node.open.edit()
					end
				end
			end, opts("Edit or Open"))
			vim.keymap.set("n", "h", function()
				local node = lib.get_node_at_cursor()
				if node and node.nodes then
					lib.close_node(node)
				end
			end, opts("Close Node"))
			vim.keymap.set("n", "h", function()
				local node = api.tree.get_node_under_cursor()
				if node then
					if node.nodes ~= nil then
						api.node.navigate.parent_close()
					else
						local parent = api.node.navigate.parent(node)
						api.node.navigate.parent_close(parent)
					end
				end
			end, opts("Close Node"))
		end

		require("nvim-tree").setup({
			on_attach = my_on_attach,
			filters = {
				custom = { "^.git%" },
			},
			actions = {
				open_file = {
					quit_on_open = true,
					window_picker = {
						enable = false,
					},
				},
			},
			update_focused_file = {
				enable = true,
				update_cwd = true,
			},
			git = {
				enable = false,
			},
			diagnostics = {
				enable = true,
				show_on_dirs = true,
				icons = {
					hint = "",
					info = "",
					warning = "",
					error = "",
				},
			},
		})
	end,
}
