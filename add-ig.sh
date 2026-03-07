#!/bin/bash
#
# Usage: ./add-ig.sh <instagram-url> [date]
#
# Adds an Instagram post URL to a diary entry's frontmatter.
# If no date is given, uses today's date.
#
# Examples:
#   ./add-ig.sh https://www.instagram.com/p/DVj0Kt-D3dB/
#   ./add-ig.sh https://www.instagram.com/p/DVj0Kt-D3dB/ 2026-03-06

set -euo pipefail

DIARY_DIR="website/src/content/diary"

if [ $# -lt 1 ]; then
  echo "Usage: ./add-ig.sh <instagram-url> [YYYY-MM-DD]"
  exit 1
fi

URL="$1"
DATE="${2:-$(date +%Y-%m-%d)}"

# Validate URL format
if [[ ! "$URL" =~ ^https://www\.instagram\.com/ ]]; then
  echo "Error: URL must start with https://www.instagram.com/"
  exit 1
fi

# Find the diary entry matching the date
ENTRY=$(find "$DIARY_DIR" -name "${DATE}*.md" -type f | head -1)

if [ -z "$ENTRY" ]; then
  echo "Error: No diary entry found for date $DATE"
  echo "Files in $DIARY_DIR:"
  ls "$DIARY_DIR"
  exit 1
fi

echo "Found entry: $ENTRY"

# Check if instagram field already exists in frontmatter
if grep -q "^instagram:" "$ENTRY"; then
  # Check if this URL is already there
  if grep -qF "$URL" "$ENTRY"; then
    echo "This URL is already in the entry. Nothing to do."
    exit 0
  fi
  # Add URL to existing instagram array (insert after the last instagram entry)
  # Find the line number of the last instagram array item
  LAST_IG_LINE=$(grep -n '  - "https://www.instagram.com/' "$ENTRY" | tail -1 | cut -d: -f1)
  if [ -n "$LAST_IG_LINE" ]; then
    sed -i '' "${LAST_IG_LINE}a\\
  - \"${URL}\"
" "$ENTRY"
  else
    # instagram: exists but has no items yet, add after it
    IG_LINE=$(grep -n "^instagram:" "$ENTRY" | head -1 | cut -d: -f1)
    sed -i '' "${IG_LINE}a\\
  - \"${URL}\"
" "$ENTRY"
  fi
  echo "Added URL to existing instagram list."
else
  # Insert instagram field before the closing --- of frontmatter
  # Find the second --- (end of frontmatter)
  END_LINE=$(awk '/^---$/{n++; if(n==2){print NR; exit}}' "$ENTRY")
  if [ -z "$END_LINE" ]; then
    echo "Error: Could not find end of frontmatter"
    exit 1
  fi
  sed -i '' "$((END_LINE))i\\
instagram:\\
  - \"${URL}\"
" "$ENTRY"
  echo "Added instagram field with URL."
fi

echo "Done! Entry updated: $ENTRY"
