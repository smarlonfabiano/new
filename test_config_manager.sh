#!/bin/bash

# =============================================================================
# Test Script for Configuration Management
# =============================================================================
# This script tests the functionality of the config_manager.sh script
# by running it with different environments and checking the output.
# =============================================================================

set -e  # Exit immediately if a command exits with a non-zero status

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_TOTAL=0
TESTS_PASSED=0

# Helper function to run a test
run_test() {
    local test_name=$1
    local command=$2
    local expected_exit_code=${3:-0}
    
    echo -e "\n${YELLOW}Running test: ${test_name}${NC}"
    echo "Command: $command"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    # Run the command and capture output and exit code
    output=$(eval "$command" 2>&1) || true
    exit_code=$?
    
    # Check if exit code matches expected
    if [[ $exit_code -eq $expected_exit_code ]]; then
        echo -e "${GREEN}✓ Exit code $exit_code matches expected $expected_exit_code${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗ Exit code $exit_code does not match expected $expected_exit_code${NC}"
    fi
    
    # Print output (truncated if too long)
    echo "Output (truncated):"
    echo "$output" | head -n 20
    if [[ $(echo "$output" | wc -l) -gt 20 ]]; then
        echo "... (output truncated)"
    fi
}

# Make sure the script is executable
chmod +x ./config_manager.sh

echo -e "${YELLOW}=== Starting Configuration Manager Tests ===${NC}"

# Test 1: Default environment (dev)
run_test "Default environment (dev)" "./config_manager.sh"

# Test 2: Staging environment
run_test "Staging environment" "./config_manager.sh staging"

# Test 3: Production environment
run_test "Production environment" "./config_manager.sh prod"

# Test 4: Invalid environment (should fail)
run_test "Invalid environment" "./config_manager.sh invalid_env" 1

# Test 5: Test with custom environment variable
run_test "Custom environment variable" "DB_HOST=custom-db.example.com ./config_manager.sh dev"

# Test 6: Generate config files
if [[ -f "generated.env" ]]; then
    echo "Removing previously generated files"
    rm -f generated.env generated.json
fi

run_test "Generate config files" "./config_manager.sh dev"

# Test 7: Check if generated files exist
TESTS_TOTAL=$((TESTS_TOTAL + 2))
if [[ -f "generated.env" ]]; then
    echo -e "${GREEN}✓ generated.env file was created${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ generated.env file was not created${NC}"
fi

if [[ -f "generated.json" ]]; then
    echo -e "${GREEN}✓ generated.json file was created${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ generated.json file was not created${NC}"
fi

# Print test summary
echo -e "\n${YELLOW}=== Test Summary ===${NC}"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC} / ${YELLOW}$TESTS_TOTAL${NC}"

if [[ $TESTS_PASSED -eq $TESTS_TOTAL ]]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi