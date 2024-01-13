local wezterm = require 'wezterm';
local act = wezterm.action;

return {
  font = wezterm.font("JetBrainsMono Nerd Font"),
  font_size = 14.0,
  color_scheme = 'catppuccin-frappe',

  default_domain = 'WSL:Ubuntu',
  hide_tab_bar_if_only_one_tab = true,
  allow_win32_input_mode = true,

  keys = {
    { key = "d", mods = "ALT", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "d", mods = "ALT|SHIFT", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "w", mods = "CTRL", action = act.CloseCurrentPane { confirm = false } },
    { key = "k", mods = "ALT", action = act.Multiple {
      act.ClearScrollback "ScrollbackAndViewport",
      act.SendKey { key = "L", mods = "CTRL" },
    } },
    { key = "[", mods = "ALT", action = act.ActivatePaneDirection "Prev" },
    { key = "]", mods = "ALT", action = act.ActivatePaneDirection "Next" },
  },
}
