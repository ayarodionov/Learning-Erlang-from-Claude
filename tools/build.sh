#!/bin/sh
# Rebuild PDFs from md/ into pdf/. Needs pandoc and a Chromium/Chrome binary.
# Usage: tools/build.sh [chapter.md ...]   (default: all chapters)
set -e
cd "$(dirname "$0")/.."
CHROME="${CHROME:-$(command -v chromium || command -v chromium-browser || command -v google-chrome)}"
[ $# -eq 0 ] && set -- md/*.md
for f in "$@"; do
  c=$(basename "$f" .md)
  tmp=$(mktemp --suffix=.html)
  pandoc "$f" -s --css tools/style.css --embed-resources --highlight-style=tango -o "$tmp"
  "$CHROME" --headless --no-sandbox --disable-gpu --no-pdf-header-footer --print-to-pdf="pdf/$c.pdf" "$tmp" 2>/dev/null
  rm -f "$tmp"
  echo "built pdf/$c.pdf"
done
