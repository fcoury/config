local wezterm = require("wezterm")
local act = wezterm.action

local config = {
	font = wezterm.font("MesloLGS Nerd Font Mono"),
	font_size = 22.0,
	-- color_scheme = "catppuccin-mocha",
	color_scheme = "Tokyo Night",
	line_height = 1.1,

	-- Window styling
	window_decorations = "RESIZE",
	window_frame = {
		font = wezterm.font({ family = "MesloLGS Nerd Font Mono", weight = "Bold" }),
		font_size = 15,
	},
	window_padding = {
		left = 0,
		right = 0,
		top = 5,
		bottom = 5,
	},

	set_environment_variables = {
		PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
	},

	send_composed_key_when_left_alt_is_pressed = false,
	send_composed_key_when_right_alt_is_pressed = true,
	hide_tab_bar_if_only_one_tab = true,

	-- CTRL+A is our leader key
	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },

	mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CMD",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},

	keys = {
		{ key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = false }) },
		{ key = "k", mods = "CMD|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },
		{ key = "s", mods = "CTRL|OPT|CMD", action = act.EmitEvent("toggle-font") },
		{
			key = "k",
			mods = "CMD",
			action = act.Multiple({
				act.ClearScrollback("ScrollbackAndViewport"),
				act.SendKey({ key = "L", mods = "CTRL" }),
			}),
		},
		{ key = "[", mods = "CMD", action = act.ActivatePaneDirection("Prev") },
		{ key = "]", mods = "CMD", action = act.ActivatePaneDirection("Next") },
		{ key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "Enter", mods = "CMD|SHIFT", action = act.TogglePaneZoomState },
		{ key = "s", mods = "OPT", action = act.PaneSelect({ mode = "SwapWithActive" }) },

		-- Search thingies
		{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },

		-- Add these lines for growing the current pane
		{ key = "UpArrow", mods = "CMD", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "DownArrow", mods = "CMD", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "LeftArrow", mods = "CMD", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "RightArrow", mods = "CMD", action = act.AdjustPaneSize({ "Right", 1 }) },

		-- Open config with nvim
		{
			key = ",",
			mods = "SUPER",
			action = wezterm.action.SpawnCommandInNewTab({
				cwd = wezterm.home_dir,
				args = { "nvim", wezterm.config_file },
			}),
		},

		-- Vimkeys resizing
		{
			-- When we push LEADER + R...
			key = "r",
			mods = "LEADER",
			-- Activate the `resize_panes` keytable
			action = wezterm.action.ActivateKeyTable({
				name = "resize_panes",
				-- Ensures the keytable stays active after it handles its
				-- first keypress.
				one_shot = false,
				-- Deactivate the keytable after a timeout.
				timeout_milliseconds = 1000,
			}),
		},
	},
}

local function resize_pane(key, direction)
	return {
		key = key,
		action = wezterm.action.AdjustPaneSize({ direction, 3 }),
	}
end

config.key_tables = {
	resize_panes = {
		resize_pane("j", "Down"),
		resize_pane("k", "Up"),
		resize_pane("h", "Left"),
		resize_pane("l", "Right"),
	},
}

for i = 1, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CMD",
		action = act.ActivateTab(i - 1),
	})
end

wezterm.on("toggle-font", function(window)
	wezterm.log_info("Toggle font keybinding triggered")
	local overrides = window:get_config_overrides() or {}
	wezterm.log_info(overrides.font)
	if overrides.font_size == 18.0 then
		wezterm.log_info("Switching to MesloLGS Nerd Font Mono")
		overrides.font = nil
		overrides.font_size = nil
	else
		wezterm.log_info("Switching to Iosevka")
		overrides.font = wezterm.font("IosevkaTerm Nerd Font")
		overrides.font_size = 18.0
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("update-status", function(window)
	-- Grab the utf8 character for the "powerline" left facing
	-- solid arrow.
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Grab the current window's configuration, and from it the
	-- palette (this is the combination of your chosen colour scheme
	-- including any overrides).
	local color_scheme = window:effective_config().resolved_palette
	local bg = color_scheme.background
	local fg = color_scheme.foreground

	window:set_right_status(wezterm.format({
		-- First, we draw the arrow...
		{ Background = { Color = "none" } },
		{ Foreground = { Color = bg } },
		{ Text = SOLID_LEFT_ARROW },
		-- Then we draw our text
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = " " .. wezterm.hostname() .. " " },
	}))
end)

return config
