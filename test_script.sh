#!/bin/bash

# Test script for script.sh
echo "Running tests for script.sh"

# Check if the script exists
if [ ! -f "./script.sh" ]; then
    echo "FAIL: script.sh does not exist"
    exit 1
fi

# Check if the script is executable
if [ ! -x "./script.sh" ]; then
    echo "FAIL: script.sh is not executable"
    chmod +x ./script.sh
    echo "Made script.sh executable"
fi

# Check if the script contains the codename and version
if ! grep -q "Internal Codename: NightHawk" "./script.sh"; then
    echo "FAIL: Codename not found in script"
    exit 1
fi

if ! grep -q "Version: 1.0.0" "./script.sh"; then
    echo "FAIL: Version not found in script"
    exit 1
fi

# Run the script and capture output
output=$(bash ./script.sh)

# Check if the output contains expected strings
if ! echo "$output" | grep -q "Welcome to the NightHawk script!"; then
    echo "FAIL: Welcome message not found in output"
    exit 1
fi

if ! echo "$output" | grep -q "This is version 1.0.0"; then
    echo "FAIL: Version message not found in output"
    exit 1
fi

if ! echo "$output" | grep -q "System Information"; then
    echo "FAIL: System information section not found in output"
    exit 1
fi

if ! echo "$output" | grep -q "Disk Space Usage"; then
    echo "FAIL: Disk space section not found in output"
    exit 1
fi

echo "All tests PASSED!"
echo "script.sh contains the required codename and version and executes correctly."
exit 0