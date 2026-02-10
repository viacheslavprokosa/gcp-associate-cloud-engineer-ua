#!/bin/bash
# Wrapper for mmdc to add --no-sandbox flag

# Find the real mmdc
REAL_MMDC=$(npm root -g)/mermaid-filter/node_modules/.bin/mmdc

# Run with puppeteer args
exec "$REAL_MMDC" --puppeteerConfigFile .github/scripts/mermaid-config.json "$@"
