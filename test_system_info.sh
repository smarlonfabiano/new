#!/bin/bash

# Test script for system_info.sh
# This test script checks if system_info.sh exists and is executable

echo "Running tests for system_info.sh..."

# Test 1: Check if the script exists
if [ -f "./system_info.sh" ]; then
    echo "✓ Test 1 passed: system_info.sh exists"
else
    echo "✗ Test 1 failed: system_info.sh does not exist"
    exit 1
fi

# Test 2: Check if the script has execute permissions
if [ -x "./system_info.sh" ]; then
    echo "✓ Test 2 passed: system_info.sh is executable"
else
    echo "✗ Test 2 failed: system_info.sh is not executable"
    echo "Run 'chmod +x system_info.sh' to make it executable"
    exit 1
fi

# Test 3: Check if the script contains the AI model attribution
if grep -q "Claude 3 Opus" "./system_info.sh"; then
    echo "✓ Test 3 passed: Script contains AI model attribution"
else
    echo "✗ Test 3 failed: Script does not contain AI model attribution"
    exit 1
fi

# Test 4: Check if the script runs without errors
echo "Running system_info.sh to check for errors..."
./system_info.sh > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Test 4 passed: Script runs without errors"
else
    echo "✗ Test 4 failed: Script returned an error"
    exit 1
fi

echo "All tests passed successfully!"
echo "To run the system_info.sh script, use: ./system_info.sh"