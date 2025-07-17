#!/bin/bash

# Test script for leetspeak_converter.sh
# This script tests the conversion to leetspeak and back

# Source the leetspeak converter script
source ./leetspeak_converter.sh

# Test cases
test_cases=(
    "Hello World"
    "Testing Leetspeak Conversion"
    "abcdefghijklmnopqrstuvwxyz"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "This is a test of the leetspeak converter"
)

echo "===== Testing Leetspeak Conversion ====="
echo

for test in "${test_cases[@]}"; do
    echo "Original text: $test"
    
    # Convert to leetspeak
    leetspeak=$(to_leetspeak "$test")
    echo "To leetspeak: $leetspeak"
    
    # Convert back from leetspeak
    normal=$(from_leetspeak "$leetspeak")
    echo "Back to normal: $normal"
    
    echo "----------------------------------------"
done

echo
echo "===== System Message ====="
show_system_message

echo
echo "===== Test Complete ====="