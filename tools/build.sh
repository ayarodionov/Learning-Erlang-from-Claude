#!/bin/sh
# Rebuild PDFs from md/ into pdf/. Needs pandoc and a Chromium/Chrome binary.
# Usage: tools/build.sh [chapter.md ...]   (default: all chapters)
set -e
cd "$(dirname "$0")/.."
if [ -z "$CHROME" ]; then
  for c in chromium chromium-browser google-chrome google-chrome-stable \
           "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
           "/Applications/Chromium.app/Contents/MacOS/Chromium"; do
    if command -v "$c" >/dev/null 2>&1 || [ -x "$c" ]; then CHROME="$c"; break; fi
  done
fi
if [ -z "$CHROME" ]; then echo "Chromium/Chrome not found; set CHROME=/path/to/chrome" >&2; exit 1; fi
if [ $# -eq 0 ]; then set -- md/*.md; fi
for f in "$@"; do
  c=$(basename "$f" .md)
  tmp=$(mktemp --suffix=.html)
  pandoc "$f" -s --css tools/style.css --embed-resources --highlight-style=tango -o "$tmp"
  "$CHROME" --headless --no-sandbox --disable-gpu --no-pdf-header-footer --print-to-pdf="pdf/$c.pdf" "$tmp" 2>/dev/null
  rm -f "$tmp"
  echo "built pdf/$c.pdf"
done
