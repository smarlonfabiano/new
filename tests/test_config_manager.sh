#!/bin/bash

# ========================================================================
# Test Script for Configuration Manager
# ========================================================================
# This script tests the functionality of the config_manager.sh script
#
# Author: AI Assistant
# Date: $(date +%Y-%m-%d)
# ========================================================================

# Set script to exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Path to the config manager script
CONFIG_MANAGER="../config_manager.sh"

# Test counter
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a test
run_test() {
  local test_name=$1
  local command=$2
  local expected_exit_code=${3:-0}
  
  echo -e "\n${YELLOW}Running test: $test_name${NC}"
  echo "Command: $command"
  ((TESTS_TOTAL++))
  
  # Run the command and capture output and exit code
  output=$(eval "$command" 2>&1) || true
  exit_code=$?
  
  # Check if exit code matches expected
  if [ $exit_code -eq $expected_exit_code ]; then
    echo -e "${GREEN}✓ Test passed${NC}"
    ((TESTS_PASSED++))
  else
    echo -e "${RED}✗ Test failed: Expected exit code $expected_exit_code, got $exit_code${NC}"
    ((TESTS_FAILED++))
  fi
  
  # Display output
  echo "Output:"
  echo "$output"
}

# Function to print test summary
print_summary() {
  echo -e "\n${YELLOW}Test Summary:${NC}"
  echo "Total tests: $TESTS_TOTAL"
  echo -e "${GREEN}Tests passed: $TESTS_PASSED${NC}"
  echo -e "${RED}Tests failed: $TESTS_FAILED${NC}"
  
  if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}All tests passed!${NC}"
    exit 0
  else
    echo -e "\n${RED}Some tests failed!${NC}"
    exit 1
  fi
}

# ========================================================================
# Test Cases
# ========================================================================

# Test 1: Check if script exists
run_test "Check if script exists" "[ -f $CONFIG_MANAGER ]"

# Test 2: Check if script is executable
run_test "Check if script is executable" "[ -x $CONFIG_MANAGER ]"

# Test 3: Test list-configs command
run_test "Test list-configs command" "$CONFIG_MANAGER list-configs"

# Test 4: Test show-config command with valid file
run_test "Test show-config with valid file" "$CONFIG_MANAGER show-config app.conf"

# Test 5: Test show-config command with invalid file
run_test "Test show-config with invalid file" "$CONFIG_MANAGER show-config nonexistent.conf" 1

# Test 6: Test list-env command
run_test "Test list-env command" "$CONFIG_MANAGER list-env"

# Test 7: Test check-deployment command
run_test "Test check-deployment command" "$CONFIG_MANAGER check-deployment"

# Test 8: Test validate command
run_test "Test validate command" "$CONFIG_MANAGER validate" 1

# Test 9: Test backup command
run_test "Test backup command" "$CONFIG_MANAGER backup"

# Test 10: Test with invalid command
run_test "Test with invalid command" "$CONFIG_MANAGER invalid-command" 1

# Print test summary
print_summary