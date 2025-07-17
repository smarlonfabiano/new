#!/bin/bash

# Test script for test2

# Source the test2 script to use its functions
source ./test2

# Test cases
test_cases=(
    "Hello World"
    "Testing Leetspeak Conversion"
    "The quick brown fox jumps over the lazy dog"
)

# Run tests
echo "Running tests for leetspeak conversion:"
echo "======================================"

for test in "${test_cases[@]}"; do
    echo "Original: $test"
    
    # Convert to leetspeak
    leetspeak=$(to_leetspeak "$test")
    echo "Leetspeak: $leetspeak"
    
    # Convert back
    normal=$(from_leetspeak "$leetspeak")
    echo "Back to normal: $normal"
    
    echo "--------------------------------------"
done

echo "Tests completed."