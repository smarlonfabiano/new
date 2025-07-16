# Test Project for Code Quality Metrics

This project contains intentional code quality issues to demonstrate the functionality of the code quality metrics script.

## Code Quality Issues

The project contains the following intentional code quality issues:

1. **Long Functions**: Functions that exceed 50 lines of code
2. **Deeply Nested Code**: Code with nesting levels greater than 3
3. **TODO/FIXME Comments**: Comments indicating technical debt
4. **Code Duplication**: Functions that are duplicated across files
5. **Large Files**: Files that exceed 500 lines of code
6. **Low Comment Density**: Code with insufficient comments
7. **Test Coverage**: Imbalance between source files and test files

## Directory Structure

- `src/`: Source code files with intentional code quality issues
- `tests/`: Test files for the source code

## Running the Code Quality Metrics Script

To analyze this project with the code quality metrics script, run:

```bash
../code_quality_metrics.sh ./
```

This will generate a report of the code quality metrics and technical debt indicators in the project.