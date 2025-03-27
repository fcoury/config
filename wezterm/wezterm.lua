local wezterm = require("wezterm")
local act = wezterm.action

local config = {
	font = wezterm.font("FantasqueSansM Nerd Font"),
	font_size = 22.0,
	line_height = 1.2,
	-- font = wezterm.font("Cousine Nerd Font Mono"),
	-- font_size = 16.0,
	-- line_height = 1.1,
	-- font = wezterm.font("IosevkaTerm Nerd Font"),
	-- font_size = 20.0,
	-- line_height = 1.1,
	-- font = wezterm.font("MesloLGS Nerd Font Mono"),
	-- font_size = 22.0,
	-- color_scheme = "catppuccin-mocha",
	-- line_height = 1.1,

	-- color_scheme = "Tomorrow (light) (terminal.sexy)",

	-- Max Acceleration
	max_fps = 120,
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",

	-- Window styling
	window_decorations = "RESIZE",
	window_frame = {
		font = wezterm.font({ family = "MesloLGS Nerd Font Mono", weight = "Bold" }),
		font_size = 15,
	},
	window_padding = {
		left = 5,
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

	-- CTRL+S is our leader key
	leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 },

	mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CMD",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},

	keys = {
		-- Navigation between panes (equivalent to tmux hjkl navigation)
		{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

		-- Control versions (equivalent to tmux C-hjkl navigation)
		{ key = "h", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "CTRL", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "CTRL", action = act.ActivatePaneDirection("Right") },

		-- Resize pane (replacing your existing resize_pane function)
		{ key = "H", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "J", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
		{ key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "L", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },

		-- Clone pane
		{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },

		-- Maximize pane (already in your config as CMD+SHIFT+Enter)
		{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

		-- Creating panes (already have similar with CMD+d and CMD+SHIFT+d)
		{ key = "d", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

		{ key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = false }) },
		{ key = "k", mods = "CMD|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },
		{ key = "s", mods = "CTRL|OPT|CMD", action = act.EmitEvent("toggle-font") },
		{
			key = "k",
			mods = "CMD",
			action = act.Multiple({
				-- act.SendKey({ key = "L", mods = "CTRL" }),
				act.ClearScrollback("ScrollbackAndViewport"),
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

	-- Custom theme (lackluster)
	color_scheme = "Lackluster",
	colors = {
		foreground = "#deeeed", -- luster
		background = "#101010", -- black
		cursor_bg = "#deeeed", -- luster
		cursor_border = "#deeeed", -- luster
		cursor_fg = "#000000", -- black
		selection_bg = "#444444", -- gray4
		selection_fg = "#deeeed", -- luster

		ansi = {
			"#000000", -- black
			"#D70000", -- red
			"#789978", -- green
			"#abab77", -- yellow
			"#7788AA", -- blue
			"#ffaa88", -- orange
			"#708090", -- lack
			"#aaaaaa", -- gray7
		},
		brights = {
			"#555555", -- gray5
			"#D70000", -- red
			"#789978", -- green
			"#abab77", -- yellow
			"#7788AA", -- blue
			"#ffaa88", -- orange
			"#708090", -- lack
			"#DDDDDD", -- gray9
		},

		tab_bar = {
			background = "#191919", -- gray2

			active_tab = {
				bg_color = "#444444", -- gray4
				fg_color = "#deeeed", -- luster
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#191919", -- gray2
				fg_color = "#555555", -- gray5
			},
			inactive_tab_hover = {
				bg_color = "#444444", -- gray4
				fg_color = "#deeeed", -- luster
				italic = true,
			},
			new_tab = {
				bg_color = "#191919", -- gray2
				fg_color = "#deeeed", -- luster
			},
			new_tab_hover = {
				bg_color = "#789978", -- green
				fg_color = "#191919", -- gray2
				italic = true,
			},
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
