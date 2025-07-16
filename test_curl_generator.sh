#!/bin/bash

# Test script for curl_generator.sh
# This script verifies that curl_generator.sh:
# 1. Is executable
# 2. Generates a curl command
# 3. Includes a comment indicating which LLM wrote it

echo "Running tests for curl_generator.sh..."

# Make the script executable if it's not already
chmod +x ./curl_generator.sh

# Test 1: Check if the script is executable
if [ -x ./curl_generator.sh ]; then
    echo "✓ Test 1 passed: curl_generator.sh is executable"
else
    echo "✗ Test 1 failed: curl_generator.sh is not executable"
    exit 1
fi

# Test 2: Check if the script generates output
output=$(./curl_generator.sh)
if [ -n "$output" ]; then
    echo "✓ Test 2 passed: curl_generator.sh generates output"
else
    echo "✗ Test 2 failed: curl_generator.sh does not generate output"
    exit 1
fi

# Test 3: Check if the output contains "curl"
if echo "$output" | grep -q "curl"; then
    echo "✓ Test 3 passed: Output contains a curl command"
else
    echo "✗ Test 3 failed: Output does not contain a curl command"
    exit 1
fi

# Test 4: Check if the output mentions which LLM wrote it
if echo "$output" | grep -q "Claude"; then
    echo "✓ Test 4 passed: Output mentions Claude as the LLM"
else
    echo "✗ Test 4 failed: Output does not mention which LLM wrote it"
    exit 1
fi

echo "All tests passed! curl_generator.sh is working as expected."