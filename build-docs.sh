#!/bin/bash
set -e

# Convert README.md to docs/index.html
# README.md is the canonical documentation source.

if ! command -v pandoc >/dev/null 2>&1; then
  echo "ERROR: pandoc is required to build documentation" >&2
  exit 1
fi

pandoc README.md \
  --from gfm \
  --to html5 \
  --standalone \
  --metadata title="KIM6 documentation" \
  --output docs/index.html

