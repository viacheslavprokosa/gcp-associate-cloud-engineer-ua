#!/bin/bash

set -e

echo "🔍 Validating exam questions format..."

# Find all exam-questions.md files
exam_files=$(find . -name "exam-questions.md" -not -path "./node_modules/*" || true)

if [ -z "$exam_files" ]; then
  echo "ℹ️  No exam question files found"
  exit 0
fi

error_count=0

for file in $exam_files; do
  echo "Checking: $file"
  
  # Check if file has questions (contains "###" for question headers)
  if ! grep -q "^###" "$file"; then
    echo "⚠️  Warning: $file appears to be empty or has no questions"
    continue
  fi
  
  # Count questions
  question_count=$(grep -c "^### Question" "$file" || echo "0")
  
  # Count "Correct Answer" sections
  answer_count=$(grep -c "^\*\*Correct Answer" "$file" || echo "0")
  
  # Count "Explanation" sections (both English and Ukrainian)
  explanation_count=$(grep -c "^\*\*Explanation" "$file" || grep -c "^\*\*Пояснення" "$file" || echo "0")
  
  if [ "$question_count" -ne "$answer_count" ]; then
    echo "❌ Error: $file has $question_count questions but $answer_count answers"
    error_count=$((error_count + 1))
  fi
  
  if [ "$question_count" -ne "$explanation_count" ]; then
    echo "⚠️  Warning: $file has $question_count questions but $explanation_count explanations"
  fi
  
  echo "  ✓ Found $question_count questions with $answer_count answers"
done

if [ $error_count -gt 0 ]; then
  echo "❌ Found $error_count exam question format errors"
  exit 1
fi

echo "✅ All exam questions are properly formatted!"
