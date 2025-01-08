if test -e /opt/homebrew/bin/brew
	eval (/opt/homebrew/bin/brew shellenv)
  set -gx PATH "/opt/homebrew/bin" $PATH
end

type -q atuin && atuin init fish --disable-up-arrow | source

