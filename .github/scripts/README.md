# CI/CD Scripts

This directory contains validation scripts used by GitHub Actions for quality checks.

## Scripts

### validate-structure.sh

Validates the repository structure:

- Checks for required files (README.md, exam-questions.md) in each module
- Verifies glossary.md exists
- Validates README.md sections (Module Goal, Key Exam Takeaways)

### validate-mermaid.sh

Validates Mermaid diagram syntax:

- Finds all Mermaid code blocks in markdown files
- Compiles diagrams to check for syntax errors
- Reports invalid diagrams

### validate-exam-questions.sh

Validates exam questions format:

- Checks question structure (### Question headers)
- Verifies each question has a correct answer
- Ensures explanations are present
- Reports formatting inconsistencies

## Usage

These scripts are automatically executed by the GitHub Actions workflow on every push to main.

To run locally:

```bash
# Make scripts executable
chmod +x .github/scripts/*.sh

# Run individual checks
.github/scripts/validate-structure.sh
.github/scripts/validate-mermaid.sh
.github/scripts/validate-exam-questions.sh
```
