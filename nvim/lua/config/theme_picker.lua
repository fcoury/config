-- Theme picker using Snacks with live preview
-- Integrates with Themery for persistence

return function()
	local themery = require("themery")
	local persistence = require("themery.persistence")
	local themes = themery.getAvailableThemes()
	local current = themery.getCurrentTheme()
	local original_theme = current and current.name or nil

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

	Snacks.picker({
		title = "Themes",
		items = items,
		format = function(item)
			return { { item.text } }
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
		cancel = function(picker)
			picker:close()
			if original_theme then
				themery.setThemeByName(original_theme)
			end
		end,
	})
end
