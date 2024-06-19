function wz
  set -l cmd (string join ' ' $argv)
  watchexec -c -r -e zig -- $cmd
end
