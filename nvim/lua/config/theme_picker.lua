-- Theme picker using Snacks with live preview
-- Integrates with Themery for persistence

return function()
	local themery = require("themery")
	local persistence = require("themery.persistence")
	local themes = themery.getAvailableThemes()
	-- Use vim.g.colors_name for the actual current colorscheme (more reliable than themery.getCurrentTheme())
	local original_theme = vim.g.colors_name

	-- Build items for the picker
	local items = {}
	for i, theme in ipairs(themes) do
		local name = type(theme) == "string" and theme or theme.name
		table.insert(items, {
			text = name,
			idx = i,
			theme = theme,
		})
	end

	-- Function to restore original theme
	local function restore_original()
		if original_theme then
			themery.setThemeByName(original_theme)
		end
	end

	-- Find the index of the current theme for pre-selection
	local current_idx = nil
	if original_theme then
		for i, item in ipairs(items) do
			if item.text == original_theme then
				current_idx = i
				break
			end
		end
	end

	Snacks.picker({
		title = "Themes",
		items = items,
		format = function(item)
			return { { item.text } }
		end,
		on_show = function(picker)
			if current_idx then
				picker.list:view(current_idx)
			end
		end,
		on_change = function(_, item)
			if item then
				themery.setThemeByName(item.text)
			end
		end,
		confirm = function(picker, item)
			picker:close()
			if item then
				themery.setThemeByName(item.text)
				-- Persist the theme selection
				persistence.saveTheme(item.theme, item.idx)
			end
		end,
		win = {
			input = {
				keys = {
					["<Esc>"] = {
						function(self)
							restore_original()
							self:close()
						end,
						mode = { "n", "i" },
						desc = "Cancel and restore theme",
					},
				},
			},
		},
	})
end
