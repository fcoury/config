function __path_prepend
  fish_add_path --path --move --prepend $argv
end

function __path_append
  fish_add_path --path --move --append $argv
end

if test -e /opt/homebrew/bin/brew
  eval (/opt/homebrew/bin/brew shellenv)
end

# Managed prefixes in final precedence order.
__path_prepend \
  "$HOME/.cargo/bin" \
  "/Applications/WezTerm.app/Contents/MacOS" \
  "$HOME/.local/bin" \
  "$HOME/.config/scripts" \
  "$HOME/.bun/bin" \
  "/opt/nanobrew/prefix/bin" \
  "/Applications/Postgres.app/Contents/Versions/latest/bin" \
  "/opt/homebrew/opt/mysql-client/bin" \
  "/opt/homebrew/opt/openjdk/bin" \
  "$HOME/go/bin" \
  "/opt/homebrew/opt/go/bin" \
  "/usr/local/go/bin" \
  "$HOME/.pyenv/bin" \
  "/opt/homebrew/opt/pyqt@5/5.15.4_1/bin" \
  "/opt/homebrew/opt/qt@5/bin" \
  "/Library/Frameworks/Python.framework/Versions/3.13/bin" \
  "$HOME/Library/pnpm" \
  "$HOME/.resend/bin"

# Explicit append-only entries.
__path_append \
  "$HOME/.modular/pkg/packages.modular.com_mojo/bin" \
  "$HOME/.cache/lm-studio/bin" \
  "$HOME/.opencode/bin" \
  "$HOME/.fabro/bin"
