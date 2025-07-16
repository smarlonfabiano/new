# Bash Error Handling Patterns

This repository demonstrates various error handling mechanisms, exception patterns, and logging strategies in Bash scripting.

## Overview

The main script `error_handling_demo.sh` implements and demonstrates the following:

### Error Handling Mechanisms

1. **Exit on Error (`set -e`)**: Makes the script exit immediately if any command fails, preventing cascading errors.
2. **Exit on Undefined Variables (`set -u`)**: Prevents using variables that haven't been defined.
3. **Pipeline Error Prevention (`set -o pipefail`)**: Returns the exit code of the last command to exit with non-zero status in a pipeline.
4. **Error Trapping (`trap`)**: Captures errors when they occur and executes custom error handling code.
5. **Cleanup Handling**: Ensures resources are properly released even when errors occur.

### Exception Patterns

1. **Try-Catch Style Error Handling**: Mimics try-catch blocks from other programming languages.
2. **Default Values for Missing Parameters**: Provides fallback values when parameters aren't provided.
3. **Input Validation**: Ensures inputs meet expected criteria before processing.
4. **Retry Mechanism**: Attempts an operation multiple times before giving up.
5. **Graceful Degradation**: Falls back to simpler functionality when preferred method fails.
6. **Conditional Error Checking**: Explicitly checks command success/failure and handles accordingly.

### Logging Strategies

1. **Log Levels**: Implements DEBUG, INFO, WARNING, ERROR, and CRITICAL log levels.
2. **Timestamped Logs**: Includes timestamps in all log messages.
3. **Dual Logging**: Logs to both console (with color coding) and file.
4. **Structured Logging**: Consistent format for all log messages.
5. **Configurable Verbosity**: Log level can be adjusted via environment variables.

## Usage

To run the demonstration script:

```bash
# Run with default settings
bash ./error_handling_demo.sh

# Run with a specific log level (0=DEBUG, 1=INFO, 2=WARNING, 3=ERROR, 4=CRITICAL)
LOG_LEVEL=0 bash ./error_handling_demo.sh

# Run with a username parameter
bash ./error_handling_demo.sh username
```

To run the test script:

```bash
bash ./test_error_handling.sh
```

## Files

- `error_handling_demo.sh`: Main script demonstrating error handling patterns
- `test_error_handling.sh`: Test script to verify functionality
- `README.md`: This documentation file