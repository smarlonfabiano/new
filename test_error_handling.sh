#!/bin/bash
# Test script for error_handling_demo.sh

echo "=== Testing error_handling_demo.sh ==="

# Check if the script exists
if [ ! -f "./error_handling_demo.sh" ]; then
    echo "ERROR: error_handling_demo.sh not found"
    exit 1
fi

# Test with different log levels
echo -e "\n=== Testing with DEBUG log level ==="
LOG_LEVEL=0 bash ./error_handling_demo.sh

echo -e "\n=== Testing with ERROR log level (should show fewer messages) ==="
LOG_LEVEL=3 bash ./error_handling_demo.sh

# Test with invalid parameter
echo -e "\n=== Testing with invalid username ==="
bash ./error_handling_demo.sh "user@name!"

# Test with valid parameter
echo -e "\n=== Testing with valid username ==="
bash ./error_handling_demo.sh "valid_user123"

echo -e "\n=== All tests completed ==="