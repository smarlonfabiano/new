# Code Quality Metrics Script

This repository contains a bash script for analyzing code quality metrics and technical debt indicators in a project.

## Features

The script analyzes the following code quality metrics and technical debt indicators:

1. **Lines of Code (LOC)**: Measures the size of the codebase. Large codebases often indicate higher complexity and potential maintenance challenges.

2. **Comment Density**: Assesses code documentation quality. Low comment density might indicate poor documentation, while excessive comments might indicate overly complex code.

3. **Function/Method Length**: Identifies long functions (>50 lines) that are harder to understand, test, and maintain. They often violate the Single Responsibility Principle.

4. **TODO/FIXME Comments**: Finds comments indicating known issues, technical debt, or unfinished work that should be tracked and addressed.

5. **File Size**: Detects large files (>500 lines) that often indicate poor separation of concerns and may violate the Single Responsibility Principle.

6. **Code Duplication**: Identifies potential code duplication, which violates the Don't Repeat Yourself (DRY) principle and increases maintenance burden.

7. **Test Coverage**: Analyzes the ratio of test files to source files to assess test coverage adequacy.

8. **Code Nesting**: Finds deeply nested code (>3 levels) that is hard to read, understand, and maintain, often indicating complex conditional logic.

## Usage

Make the script executable:

```bash
chmod +x code_quality_metrics.sh
```

Run the script on a directory:

```bash
./code_quality_metrics.sh /path/to/project
```

If no path is provided, the script will analyze the current directory:

```bash
./code_quality_metrics.sh
```

## Example

The repository includes a test project with intentional code quality issues to demonstrate the script's functionality:

```bash
./code_quality_metrics.sh ./test_project
```

## Dependencies

The script depends on common Unix tools:
- `find`
- `grep`
- `wc`
- `sort`
- `uniq`
- `bc` (for floating-point calculations)

## Limitations

This script provides a basic analysis of code quality metrics. For more comprehensive analysis, consider using specialized tools like:
- SonarQube: For comprehensive code quality and security analysis
- ESLint/Pylint: For language-specific linting
- JaCoCo/Istanbul: For accurate test coverage measurement
- PMD/CPD: For more sophisticated code duplication detection