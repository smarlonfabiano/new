# Test Coverage Analysis Project

This project demonstrates how to implement and analyze test coverage for Python code, including both unit tests and integration tests.

## Project Structure

```
.
├── src/                    # Source code
│   ├── __init__.py
│   ├── calculator.py       # Calculator module
│   └── data_processor.py   # Data processor module
├── tests/                  # Unit tests
│   ├── __init__.py
│   ├── test_calculator.py
│   └── test_data_processor.py
├── integration_tests/      # Integration tests
│   ├── __init__.py
│   └── test_calculator_data_processor.py
├── requirements.txt        # Project dependencies
├── run_tests_with_coverage.sh  # Test coverage script
└── README.md              # This file
```

## Getting Started

1. Make the test script executable:
   ```bash
   chmod +x run_tests_with_coverage.sh
   ```

2. Run the test coverage script:
   ```bash
   ./run_tests_with_coverage.sh
   ```

## Test Coverage Metrics

The test coverage script analyzes and reports the following metrics:

1. **Statement Coverage (Line Coverage)**
   - Measures the percentage of statements/lines that have been executed
   - Helps identify code that is never executed during tests

2. **Branch Coverage**
   - Measures the percentage of branches (if/else, loops) that have been executed
   - Helps identify decision points that are not fully tested

3. **Function/Method Coverage**
   - Measures the percentage of functions/methods that have been called
   - Helps identify untested functions

## Test Types

This project implements two types of tests:

1. **Unit Tests**
   - Located in the `tests/` directory
   - Test individual components in isolation
   - Focus on testing specific functions and methods
   - Examples: `test_calculator.py`, `test_data_processor.py`

2. **Integration Tests**
   - Located in the `integration_tests/` directory
   - Test how components work together
   - Focus on testing interactions between modules
   - Example: `test_calculator_data_processor.py`

## Coverage Reports

After running the test coverage script, you can find:

1. A console report showing coverage statistics
2. An HTML report in the `htmlcov/` directory for a more detailed view

## Dependencies

- Python 3.6+
- coverage
- pytest
- pytest-cov