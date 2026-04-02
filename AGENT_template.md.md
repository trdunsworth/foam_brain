# AGENT_template.md

<!-- This is designed to create a code-assistant agent definitions file -->

## Markdown standards

- Always run markdownlint on any markdown files created or edited
- Install using: `npm markdownlint-cli`
- Fix all linting issues before completing the task

## Testing preferences

- Write all Python tests as `pytest` style functions, not unittest classes
- Use descriptive function names starting with `test_`
- Prefer fixtures over setup/teardown methods
- Use assert statements directly, not self.assertEqual
