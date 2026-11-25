#!/bin/sh
# 21fadeaway-agents installer. Copies agents into a project's .claude/agents folder (Claude Code).
# Usage:
#   ./install.sh <pack>            install a starter pack, e.g. streetwear-brand
#   ./install.sh <division>        install a whole division, e.g. design
#   ./install.sh all               install all 283 (not recommended: start with 3-4)
#   ./install.sh list              show packs and divisions
# Optional second argument: the project folder (default: current folder).
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
WHAT=${1:-list}
DEST=${2:-.}/.claude/agents

if [ "$WHAT" = "list" ]; then
  echo "Packs:";     for f in "$HERE"/packs/*.txt; do echo "  $(basename "$f" .txt)"; done
  echo "Divisions:"; for d in "$HERE"/agents/*/; do echo "  $(basename "$d")"; done
  exit 0
fi

mkdir -p "$DEST"
if [ -f "$HERE/packs/$WHAT.txt" ]; then
  while IFS= read -r p; do [ -n "$p" ] && cp "$HERE/$p" "$DEST/"; done < "$HERE/packs/$WHAT.txt"
elif [ -d "$HERE/agents/$WHAT" ]; then
  find "$HERE/agents/$WHAT" -name '*.md' -exec cp {} "$DEST/" \;
elif [ "$WHAT" = "all" ]; then
  find "$HERE/agents" -name '*.md' -exec cp {} "$DEST/" \;
else
  echo "Unknown pack or division: $WHAT. Run ./install.sh list" >&2; exit 1
fi
echo "Installed into $DEST:"; ls -1 "$DEST" | sed 's/^/  /'
echo "Start a new Claude Code session, then ask by name, e.g. \"Use 21 Brand Guardian to review this page.\""
