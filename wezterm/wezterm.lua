local wezterm = require("wezterm")
-- local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local act = wezterm.action

local config = {
	font = wezterm.font("FantasqueSansM Nerd Font"),
	font_size = 24.0,
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
	-- max_fps = 120,
	-- front_end = "WebGpu",
	-- webgpu_power_preference = "HighPerformance",

	-- Set unlimited scrollback
	scrollback_lines = 35000,

	-- Window styling
	window_decorations = "RESIZE",
	window_padding = {
		left = 5,
		right = 0,
		top = 5,
		bottom = 0,
	},

	set_environment_variables = {
		PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
	},

	send_composed_key_when_left_alt_is_pressed = false,
	send_composed_key_when_right_alt_is_pressed = true,
	hide_tab_bar_if_only_one_tab = true,

	-- CTRL+S is our leader key
	leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 },

	-- hyperlink_rules = {
	-- 	-- Linkify URLs with fixed regex
	-- 	{
	-- 		regex = [[\b(https?://[\w-]+\.[\w.-]+(/[\w\-./?%&=+]*)?)\b]],
	-- 		format = "$0",
	-- 	},
	-- },

	-- Avoid auto selecting text when clicking on different panes
	-- mouse_bindings = {
	-- 	-- Disable selection when clicking to focus
	-- 	{
	-- 		event = { Down = { streak = 1, button = "Left" } },
	-- 		mods = "NONE",
	-- 		action = act.Nop,
	-- 	},
	-- },

	-- Click to open links
	-- mouse_bindings = {
	-- 	{
	-- 		event = { Up = { streak = 1, button = "Left" } },
	-- 		mods = "CMD",
	-- 		action = wezterm.action.OpenLinkAtMouseCursor,
	-- 	},
	-- {
	-- 	event = { Up = { streak = 1, button = "Left" } },
	-- 	mods = "NONE",
	-- 	action = wezterm.action.DisableDefaultAssignment,
	-- },
	--
	-- {
	-- 	event = { Up = { streak = 1, button = "Left" } },
	-- 	mods = "CMD",
	-- 	action = wezterm.action.Multiple({
	-- 		wezterm.action.OpenLinkAtMouseCursor,
	-- 		wezterm.action.Nop,
	-- 	}),
	-- },
	-- },

	keys = {
		-- Navigation between panes (equivalent to tmux hjkl navigation)
		{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

		-- Control versions (equivalent to tmux C-hjkl navigation)
		-- create_vim_aware_key("h", "Left"),
		-- create_vim_aware_key("j", "Down"),
		-- create_vim_aware_key("k", "Up"),
		-- create_vim_aware_key("l", "Right"),
		{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },

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

	-- Tabs
	use_fancy_tab_bar = false,
	tab_max_width = 24,
	show_tab_index_in_tab_bar = false,
	tab_bar_at_bottom = true,
	window_frame = {
		font = wezterm.font({ family = "SF Pro", weight = "Medium" }),
		font_size = 13.0,
		active_titlebar_bg = "#191919",
		inactive_titlebar_bg = "#191919",
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
			background = "#101010",

			active_tab = {
				bg_color = "#333333",
				fg_color = "#deeeed",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},

			inactive_tab = {
				bg_color = "#1a1a1a",
				fg_color = "#999999",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},

			inactive_tab_hover = {
				bg_color = "#252525",
				fg_color = "#cccccc",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},

			new_tab = {
				bg_color = "#1a1a1a",
				fg_color = "#999999",
			},

			new_tab_hover = {
				bg_color = "#333333",
				fg_color = "#deeeed",
				italic = false,
			},
		},

		-- tab_bar = {
		-- 	background = "#191919", -- gray2
		--
		-- 	active_tab = {
		-- 		bg_color = "#444444", -- gray4
		-- 		fg_color = "#deeeed", -- luster
		-- 		intensity = "Bold",
		-- 	},
		-- 	inactive_tab = {
		-- 		bg_color = "#191919", -- gray2
		-- 		fg_color = "#555555", -- gray5
		-- 	},
		-- 	inactive_tab_hover = {
		-- 		bg_color = "#444444", -- gray4
		-- 		fg_color = "#deeeed", -- luster
		-- 		italic = true,
		-- 	},
		-- 	new_tab = {
		-- 		bg_color = "#191919", -- gray2
		-- 		fg_color = "#deeeed", -- luster
		-- 	},
		-- 	new_tab_hover = {
		-- 		bg_color = "#789978", -- green
		-- 		fg_color = "#191919", -- gray2
		-- 		italic = true,
		-- 	},
		-- },
	},
}

-- smart_splits.apply_to_config(config, {
-- 	-- the default config is here, if you'd like to use the default keys,
-- 	-- you can omit this configuration table parameter and just use
-- 	-- smart_splits.apply_to_config(config)
--
-- 	-- directional keys to use in order of: left, down, up, right
-- 	direction_keys = { "h", "j", "k", "l" },
-- 	-- if you want to use separate direction keys for move vs. resize, you
-- 	-- can also do this:
-- 	direction_keys = {
-- 		move = { "h", "j", "k", "l" },
-- 		resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
-- 	},
-- 	-- modifier keys to combine with direction_keys
-- 	modifiers = {
-- 		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
-- 		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
-- 	},
-- 	-- log level to use: info, warn, error
-- 	log_level = "info",
-- })

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

local last_focused_pane_id = nil

wezterm.on("update-status", function(window, pane)
	local current_pane_id = pane:pane_id()

	-- If this is a new pane being focused and it's running nvim
	if last_focused_pane_id ~= current_pane_id and pane:get_foreground_process_name():find("nvim") then
		-- Briefly disable mouse input to prevent the focus click from selecting text
		window:perform_action(
			wezterm.action.SendKey({ key = "\x1b[?1000l" }), -- Disable mouse reporting
			pane
		)

		-- Re-enable after a short delay
		wezterm.sleep_ms(100)
		window:perform_action(
			wezterm.action.SendKey({ key = "\x1b[?1000h" }), -- Re-enable mouse reporting
			pane
		)
	end

	last_focused_pane_id = current_pane_id
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.active_pane.title
	local process = tab.active_pane.foreground_process_name or ""

	-- Extract just the last part of the path for process names
	process = process:gsub("^.*/([^/]+)$", "%1")

	-- Determine appropriate icon based on process
	local icon = ""
	if process:match("vim") or process:match("nvim") then
		icon = " "
	elseif process:match("git") then
		icon = " "
	elseif process:match("ssh") then
		icon = " "
	elseif process:match("bash") or process:match("zsh") or process:match("fish") then
		icon = " "
	elseif process:match("node") then
		icon = " "
	elseif process:match("python") then
		icon = " "
	elseif process:match("rust") or process:match("cargo") then
		icon = " "
	else
		icon = "  "
	end

	-- Clean up the title
	title = title:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace

	-- Truncate long titles
	if #title > 16 then
		title = title:sub(1, 14) .. "…"
	end

	-- If title is empty or just whitespace, use process name instead
	if title == "" or title:match("^%s*$") then
		title = process
	end

	-- Format tab index
	local index = tab.tab_index + 1
	local index_str = " " .. index .. " "

	return " " .. index .. ": " .. title .. " " -- .. icon .. " "
end)

return config
