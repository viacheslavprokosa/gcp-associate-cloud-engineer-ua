#!/bin/bash

set -e

echo "🔍 Validating Mermaid diagrams..."

# Find all markdown files with mermaid code blocks
mermaid_files=$(grep -rl "```mermaid" . --include="*.md" --exclude-dir=node_modules || true)

if [ -z "$mermaid_files" ]; then
  echo "ℹ️  No Mermaid diagrams found"
  exit 0
fi

error_count=0

# Extract and validate each mermaid diagram
for file in $mermaid_files; do
  echo "Checking Mermaid diagrams in: $file"
  
  # Extract mermaid blocks and save to temp files
  awk '/```mermaid/,/```/' "$file" | grep -v '```' > /tmp/mermaid_temp.mmd 2>/dev/null || true
  
  if [ -s /tmp/mermaid_temp.mmd ]; then
    # Try to compile the diagram (syntax check)
    if ! mmdc -i /tmp/mermaid_temp.mmd -o /tmp/mermaid_output.svg 2>/dev/null; then
      echo "❌ Error: Invalid Mermaid syntax in $file"
      error_count=$((error_count + 1))
    fi
  fi
done

rm -f /tmp/mermaid_temp.mmd /tmp/mermaid_output.svg

if [ $error_count -gt 0 ]; then
  echo "❌ Found $error_count Mermaid diagram errors"
  exit 1
fi

echo "✅ All Mermaid diagrams are valid!"
