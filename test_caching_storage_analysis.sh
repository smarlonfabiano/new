#!/bin/bash

# =========================================================================
# Test Script for Caching and Storage Analysis
# =========================================================================
# This script tests the functionality of caching_storage_analysis.sh
# by verifying that it runs without errors.
# =========================================================================

echo "===== Testing Caching and Storage Analysis Script ====="

# Check if the script exists
if [ ! -f "/workspace/caching_storage_analysis.sh" ]; then
    echo "ERROR: Script /workspace/caching_storage_analysis.sh not found!"
    exit 1
fi

# Make sure the script is executable
chmod +x /workspace/caching_storage_analysis.sh

# Run the script with output redirected to a log file
echo "Running the script..."
/workspace/caching_storage_analysis.sh > /tmp/script_output.log 2>&1
EXIT_CODE=$?

# Check if the script ran successfully
if [ $EXIT_CODE -eq 0 ]; then
    echo "SUCCESS: Script executed without errors (exit code: $EXIT_CODE)"
else
    echo "ERROR: Script failed with exit code: $EXIT_CODE"
    echo "Last 10 lines of output:"
    tail -10 /tmp/script_output.log
    exit 1
fi

# Check for expected output sections
echo "Verifying script output..."

# Function to check if a pattern exists in the output
check_output() {
    local pattern="$1"
    local description="$2"
    
    if grep -q "$pattern" /tmp/script_output.log; then
        echo "✓ PASS: $description"
    else
        echo "✗ FAIL: $description"
        echo "  Pattern '$pattern' not found in output"
        exit 1
    fi
}

# Check for each major section
check_output "CACHING STRATEGIES" "Caching strategies section exists"
check_output "Memoization Cache" "Memoization cache section exists"
check_output "LRU Cache" "LRU cache section exists"
check_output "Time-based Cache" "Time-based cache section exists"

check_output "DATA STORAGE PATTERNS" "Data storage patterns section exists"
check_output "File-based Storage" "File-based storage section exists"
check_output "In-memory Storage" "In-memory storage section exists"
check_output "Key-value Storage" "Key-value storage section exists"

check_output "MEMORY MANAGEMENT TECHNIQUES" "Memory management techniques section exists"
check_output "Garbage Collection" "Garbage collection section exists"
check_output "Memory Allocation" "Memory allocation section exists"
check_output "Memory Usage Monitoring" "Memory monitoring section exists"

check_output "Analysis Summary" "Summary section exists"

echo "All tests passed! The script is working correctly."
echo "===== Test Complete ====="