#!/bin/bash

# Test script for generate_script.sh

# Create a test file
echo "Line 1" > test_file.txt
echo "Line 2" >> test_file.txt
echo "Line 3" >> test_file.txt

echo "Testing help option:"
./generate_script.sh --help

echo -e "\nTesting count option:"
./generate_script.sh --count test_file.txt

echo -e "\nTesting verbose option:"
./generate_script.sh --verbose test_file.txt

echo -e "\nTesting both options:"
./generate_script.sh --verbose --count test_file.txt

# Clean up
rm test_file.txt

echo -e "\nAll tests completed."