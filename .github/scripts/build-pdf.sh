#!/bin/bash

set -e

echo "🚀 Starting PDF generation..."

# Define output directory and file
OUTPUT_DIR="pdf-book"
OUTPUT_FILE="$OUTPUT_DIR/GCP-Associate-CE.pdf"
TEMP_FILE="$OUTPUT_DIR/combined.md"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Remove old temporary file if exists
rm -f "$TEMP_FILE"

echo "📝 Collecting Markdown files..."

# Function to add file with header
add_file() {
    local file="$1"
    if [ -f "$file" ]; then
        echo "" >> "$TEMP_FILE"
        echo "\\newpage" >> "$TEMP_FILE"
        echo "" >> "$TEMP_FILE"
        cat "$file" >> "$TEMP_FILE"
        echo "✓ Added: $file"
    else
        echo "⚠ Warning: File not found: $file"
    fi
}

# Start with main README
add_file "README.md"

# Add modules in order
for i in {01..13}; do
    # Find directory starting with number
    dir=$(find . -maxdepth 1 -type d -name "${i}-*" | head -n 1)
    
    if [ -n "$dir" ]; then
        echo "📂 Processing module: $dir"
        
        # Add module README first
        add_file "$dir/README.md"
        
        # Add all other .md files except README.md and exam-questions.md
        find "$dir" -maxdepth 1 -type f -name "*.md" ! -name "README.md" ! -name "exam-questions.md" | sort | while read -r file; do
            add_file "$file"
        done
        
        # Add exam-questions.md last for each module (except module 13)
        if [ "$i" != "13" ]; then
            add_file "$dir/exam-questions.md"
        fi
    fi
done

# Add glossary at the end
add_file "glossary.md"

echo "📚 Generating PDF with Pandoc..."

# Add wrapper script directory to PATH (so mermaid-filter uses our mmdc wrapper)
export PATH="$(pwd)/.github/scripts:$PATH"

# Generate PDF using Pandoc (without mermaid-filter to avoid sandbox issues)
pandoc "$TEMP_FILE" \
    --metadata-file=.github/scripts/metadata.yaml \
    --pdf-engine=xelatex \
    --highlight-style=tango \
    --number-sections \
    --toc \
    --toc-depth=3 \
    -V geometry:margin=2.5cm \
    -V linkcolor:blue \
    -V urlcolor:blue \
    -V toccolor:black \
    -o "$OUTPUT_FILE"

# Clean up temporary file
rm -f "$TEMP_FILE"

echo "✅ PDF generated successfully: $OUTPUT_FILE"
echo "📊 File size: $(du -h "$OUTPUT_FILE" | cut -f1)"
