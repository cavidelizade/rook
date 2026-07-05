#!/bin/sh
# A pre-tool hook: refuse a run_command whose command matches a dangerous
# pattern. rook hands the hook a JSON context on stdin,
#   { "event": "pre-tool", "tool": "run_command", "args": "{\"command\":\"...\"}" }
# and a non-zero exit blocks the tool, feeding this message back to the model.
#
# Because the command text is already in the context, this greps the raw
# stdin and needs no JSON parser.

ctx=$(cat)

case "$ctx" in
    *"rm -rf /"* | *"rm -rf ~"* | *"mkfs"* | *"dd if="* | *":(){ :|:&};:"* | *"> /dev/sda"*)
        echo "refused: that command matches a dangerous pattern; find a safer way" 1>&2
        exit 1
        ;;
esac

exit 0
