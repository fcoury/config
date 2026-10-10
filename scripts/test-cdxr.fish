#!/usr/bin/env fish
source (path resolve (status dirname)/../fish/functions/cdxr.fish)

set -gx TMUX test-socket
set -gx TMUX_PANE %83
set -g calls
set -g lookups

function herdr
    set -ga lookups "herdr:"(string join : -- $argv)
    if test "$scenario" = herdr_capture_failed
        return 1
    end
    echo 'codex resume 01a11682-8490-7062-af9f-856b2bf9e2c9'
end

function tmux
    switch $argv[1]
        case display-message
            if contains -- -t $argv
                set -ga lookups stale
                return 1
            end
            set -ga lookups current
            if test "$scenario" != missing
                echo %84
            else
                return 1
            end
        case capture-pane
            set -ga lookups "capture:$argv[-1]"
            if test "$scenario" = capture_failed
                return 1
            end
            echo 'codex resume 01a06d91-5ea2-7402-b6f5-ce9774b86bee'
    end
end

function cdx
    set -g calls $argv
end

set -gx HERDR_ENV 1
set -gx HERDR_PANE_ID w9:p2
set -g scenario herdr_working
cdxr --search
if test $status -ne 0; or test (string join , $lookups) != 'herdr:pane:read:w9:p2:--source:recent-unwrapped:--lines:10000:--raw'; or test (string join -- ' ' $calls) != 'resume 01a11682-8490-7062-af9f-856b2bf9e2c9 --search'
    echo 'herdr pane did not resume from the current pane' >&2
    exit 1
end

set -g calls
set -g lookups
set -g scenario herdr_capture_failed
cdxr 2>/dev/null
if test $status -eq 0; or test (string join , $lookups) != 'herdr:pane:read:w9:p2:--source:recent-unwrapped:--lines:10000:--raw'; or set -q calls[1]
    echo 'failed herdr capture launched a new session' >&2
    exit 1
end

set -e HERDR_PANE_ID
set -g calls
set -g lookups
cdxr 2>/dev/null
if test $status -eq 0; or set -q lookups[1]; or set -q calls[1]
    echo 'missing herdr pane launched a new session' >&2
    exit 1
end

set -e HERDR_ENV HERDR_PANE_ID
set -g scenario working
set -g lookups
cdxr --search
if test $status -ne 0; or test (string join , $lookups) != stale,current,capture:%84; or test (string join -- ' ' $calls) != 'resume 01a06d91-5ea2-7402-b6f5-ce9774b86bee --search'
    echo 'stale pane did not resume from the current pane' >&2
    exit 1
end

set -g calls
set -g lookups
set -g scenario missing
cdxr 2>/dev/null
if test $status -eq 0; or test (string join , $lookups) != stale,current; or set -q calls[1]
    echo 'missing pane launched a new session' >&2
    exit 1
end

set -g lookups
set -g scenario capture_failed
cdxr 2>/dev/null
if test $status -eq 0; or test (string join , $lookups) != stale,current,capture:%84; or set -q calls[1]
    echo 'failed capture launched a new session' >&2
    exit 1
end

echo 'cdxr regression check passed'
