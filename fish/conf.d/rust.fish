function wg
  set -l cmd (string join ' ' $argv)
  watchexec -c -r -e rs,html -- cargo $cmd
end
