# check if PNPM_HOME exists first
if test -d "/Users/fcoury/Library/pnpm"
  set -gx PNPM_HOME "/Users/fcoury/Library/pnpm"
  if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
  end
end
