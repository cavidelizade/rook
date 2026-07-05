#!/bin/sh
# A turn-end hook: notify when rook finishes a turn, using whatever notifier
# the OS provides. Handy when a long turn runs while you are in another
# window. Turn-end hooks are observe-only.

msg="rook finished a turn"

if command -v notify-send >/dev/null 2>&1; then
    notify-send "rook" "$msg"
elif command -v osascript >/dev/null 2>&1; then
    osascript -e "display notification \"$msg\" with title \"rook\""
elif command -v powershell >/dev/null 2>&1; then
    powershell -NoProfile -Command "[console]::beep(880,200)"
else
    printf '\a'
fi

exit 0
