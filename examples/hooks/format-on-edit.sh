#!/bin/sh
# A post-tool hook: after rook writes or edits a file, re-format it so style
# stays consistent. Bound to write_file and edit_file. Post-tool hooks are
# observe-only, so the exit code is ignored.
#
# The context arrives on stdin as
#   { "event": "post-tool", "tool": "edit_file", "args": "{\"path\":\"...\"}" }
# where args is itself a JSON string. With jq present this reads just the
# touched file's path (jq's fromjson parses the nested args); without jq it
# falls back to formatting the whole project.

ctx=$(cat)
file=""

if command -v jq >/dev/null 2>&1; then
    file=$(printf '%s' "$ctx" | jq -r '.args | fromjson | .path // empty' 2>/dev/null)
fi

case "$file" in
    *.rv)
        command -v rvpm >/dev/null 2>&1 && rvpm fmt "$file" >/dev/null 2>&1
        ;;
    "")
        [ -f rv.toml ] && command -v rvpm >/dev/null 2>&1 && rvpm fmt >/dev/null 2>&1
        ;;
esac

exit 0
