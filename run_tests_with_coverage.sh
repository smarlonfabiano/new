#!/bin/bash

# run_tests_with_coverage.sh
# This script runs unit tests and integration tests with coverage analysis

# Exit on error
set -e

# Print script header
echo "======================================================"
echo "Test Coverage Analysis Script"
echo "======================================================"
echo

# Check if required tools are installed
if ! command -v python3 &> /dev/null; then
    echo "Error: python3 is not installed"
    exit 1
fi

# Create a virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Clean previous coverage data
echo "Cleaning previous coverage data..."
coverage erase

echo
echo "======================================================"
echo "Running Unit Tests with Coverage"
echo "======================================================"
echo

# Run unit tests with coverage
coverage run -m unittest discover -s tests

echo
echo "======================================================"
echo "Running Integration Tests with Coverage"
echo "======================================================"
echo

# Run integration tests with coverage (append to existing coverage data)
coverage run --append -m unittest discover -s integration_tests

echo
echo "======================================================"
echo "Coverage Report"
echo "======================================================"
echo

# Generate coverage report
coverage report -m

echo
echo "======================================================"
echo "Generating HTML Coverage Report"
echo "======================================================"
echo

# Generate HTML coverage report
coverage html

echo "HTML coverage report generated in htmlcov/ directory"

echo
echo "======================================================"
echo "Coverage Metrics Explained"
echo "======================================================"
echo
echo "1. Statement Coverage (Line Coverage):"
echo "   - Measures the percentage of statements/lines that have been executed"
echo "   - Helps identify code that is never executed during tests"
echo
echo "2. Branch Coverage:"
echo "   - Measures the percentage of branches (if/else, loops) that have been executed"
echo "   - Helps identify decision points that are not fully tested"
echo
echo "3. Function/Method Coverage:"
echo "   - Measures the percentage of functions/methods that have been called"
echo "   - Helps identify untested functions"
echo
echo "======================================================"
echo "Test Types Implemented"
echo "======================================================"
echo
echo "1. Unit Tests:"
echo "   - Located in the 'tests/' directory"
echo "   - Test individual components in isolation"
echo "   - Focus on testing specific functions and methods"
echo "   - Examples: test_calculator.py, test_data_processor.py"
echo
echo "2. Integration Tests:"
echo "   - Located in the 'integration_tests/' directory"
echo "   - Test how components work together"
echo "   - Focus on testing interactions between modules"
echo "   - Example: test_calculator_data_processor.py"
echo
echo "======================================================"
echo "Test Coverage Analysis Complete"
echo "======================================================"

# Deactivate virtual environment
deactivate