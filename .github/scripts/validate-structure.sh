#!/bin/bash

set -e

echo "🔍 Validating repository structure..."

# Check if glossary.md exists
if [ ! -f "glossary.md" ]; then
  echo "❌ Error: glossary.md is missing"
  exit 1
fi

# Define required modules
modules=(
  "01-cloud-fundamentals"
  "02-gcp-core-services"
  "03-compute-engine"
  "04-kubernetes-engine"
  "05-app-engine"
  "06-cloud-functions"
  "07-storage"
  "08-databases"
  "09-networking"
  "10-iam-security"
  "11-monitoring-logging"
  "12-deployment-management"
  "13-practice-questions"
)

# Check each module
for module in "${modules[@]}"; do
  echo "Checking module: $module"
  
  # Check if module directory exists
  if [ ! -d "$module" ]; then
    echo "❌ Error: Module directory $module is missing"
    exit 1
  fi
  
  # Check if README.md exists
  if [ ! -f "$module/README.md" ]; then
    echo "❌ Error: $module/README.md is missing"
    exit 1
  fi
  
  # Check if exam-questions.md exists
  if [ ! -f "$module/exam-questions.md" ]; then
    echo "⚠️  Warning: $module/exam-questions.md is missing"
  fi
  
  # Validate README.md structure
  readme="$module/README.md"
  
  # Check for required sections
  if ! grep -q "## Module Goal" "$readme" && ! grep -q "## Мета модуля" "$readme"; then
    echo "⚠️  Warning: $readme is missing 'Module Goal' section"
  fi
  
  if ! grep -q "## Key Exam Takeaways" "$readme" && ! grep -q "## Topics" "$readme"; then
    echo "⚠️  Warning: $readme is missing 'Key Exam Takeaways' or 'Topics' section"
  fi
done

echo "✅ Repository structure validation completed!"
