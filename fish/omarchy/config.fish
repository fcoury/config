# Omarchy profile: load selected portable helpers, not the macOS conf.d tree.
set -l repo (path resolve (path dirname (status filename))/..)
for dir in "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/go/bin" "$HOME/.bun/bin" "$repo/../scripts"
    if test -d "$dir"
        fish_add_path --path "$dir"
    end
end
if not status is-interactive
    return
end
set -g fish_greeting
if command -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
end
set -p fish_function_path "$repo/functions"
set -p fish_complete_path "$repo/completions"
for fragment in bun go exa tmux worktrees aliases llm zz-hunk cdpath
    source "$repo/conf.d/$fragment.fish"
end
if command -q mise
    mise activate fish | source
end
if command -q zoxide
    zoxide init fish | source
end
source "$repo/conf.d/starship.fish"
