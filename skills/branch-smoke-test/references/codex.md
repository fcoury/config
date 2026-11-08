# Codex model smoke

Verify that the CLI and required code-mode host both come from the tested source. Inspect the checkout's current development or package launcher before choosing the build path. Some interactive macOS `just c` launchers build a complete package, while noninteractive and other-platform paths can cargo-run only the CLI.

For a direct debug launch from `codex-rs`, build and verify both binaries:

```fish
cargo build -p codex-cli --bin codex
cargo build -p codex-code-mode-host --bin codex-code-mode-host
test -x target/debug/codex
test -x target/debug/codex-code-mode-host
```

Honor the checkout's target-directory and packaging setup. If a rusty_v8 archive returns HTTP 404, locate its V8 helper under `public/scripts/codex_package/v8.py` or `scripts/codex_package/v8.py`, as provided by that checkout. Use the helper's checksum-verified Codex release artifacts and set `RUSTY_V8_ARCHIVE` and `RUSTY_V8_SRC_BINDING_PATH`. Keep the model required by the scenario; an older direct-tool model cannot verify newer-model behavior.
