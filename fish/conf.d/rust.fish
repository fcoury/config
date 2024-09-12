if test -d "$HOME/.cargo/bin"
    set -gx PATH $HOME/.cargo/bin $PATH
end

function wg
  set -l cmd (string join ' ' $argv)
  watchexec -c -r -e rs,html -- cargo $cmd
end

