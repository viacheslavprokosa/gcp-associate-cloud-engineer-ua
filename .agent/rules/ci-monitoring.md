# CI/CD Monitoring and Auto-Fix Rules

## Post-Push Analysis Protocol

After every push to the repository, you MUST:

1. **Check CI/CD Status**
   - Monitor the GitHub Actions workflow execution
   - Review the quality check results
   - Identify any failed checks or warnings

2. **Analyze Failures**
   - If markdownlint fails: Fix formatting issues in the reported files
   - If link-check fails: Correct broken internal/external links
   - If structure validation fails: Ensure all required files exist in modules
   - If Mermaid validation fails: Fix diagram syntax errors
   - If exam questions validation fails: Correct question format and structure

3. **Auto-Fix Protocol**
   - Automatically fix simple issues like:
     - Markdown formatting (line length, heading hierarchy, list formatting)
     - Broken internal links (update file paths)
     - Missing required sections in README files
     - Mermaid syntax errors
   - For complex issues, create a detailed report and ask the user for guidance

4. **Verification**
   - After fixing issues, verify the changes locally if possible
   - Commit fixes with descriptive messages like: "fix: correct markdown formatting in module X"
   - Push the fixes and monitor the next CI run

5. **Reporting**
   - Always inform the user about:
     - What failed in CI
     - What was automatically fixed
     - What requires manual intervention (if any)
   - Provide a summary of the CI status after each push

## Quality Standards

- All markdown files MUST pass markdownlint checks
- All internal links MUST be valid and point to existing files
- All modules MUST have required files: README.md and exam-questions.md
- All Mermaid diagrams MUST have valid syntax
- All exam questions MUST follow the defined format with answers and explanations in Ukrainian

## Continuous Improvement

- Track recurring issues and suggest structural improvements
- Propose updates to CI configuration if new quality checks are needed
- Maintain consistency across all modules
