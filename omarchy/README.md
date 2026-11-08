# Omarchy configuration

Run `./setup.sh --omarchy` from the repository root to link the Fish profile,
Ghostty config, Hyprland input overrides, and `~/.XCompose`. Existing files are
backed up before replacement; running setup again leaves matching links alone.
Other Omarchy desktop settings remain managed by Omarchy.

The saved customizations include:

- Fish with shared aliases, AI helpers, Hunk, and custom Starship dark/light prompts.
- Only Red's `config.toml` is linked from `red/`; themes and runtime data stay local.
- Ghostty starting Fish, plus font, padding, cursor, and key bindings.
- US International dead keys and swapped Alt/Win modifiers.
- Physical Alt+Tab / Alt+Shift+Tab cycle windows instead of workspaces.
- Built-in display at 2560 × 1600, 90 Hz, with 1.6× scaling.
- Portuguese cedilla (`'` then `c` → `ç`) and literal apostrophes before other consonants.

After installation, run in a desktop terminal:

```sh
hyprctl reload
hyprctl configerrors
omarchy restart xcompose
```

Reload Ghostty with Ctrl+Shift+, and fully reopen apps to refresh Compose tables.
Run `exec fish` to refresh the shell. Theme colors still follow Omarchy.

Fish uses shared helpers in `fish/conf.d` and functions in `fish/functions`;
the macOS environment configuration is not loaded. The Starship theme selector
currently expects the repository at `~/code/config`.
