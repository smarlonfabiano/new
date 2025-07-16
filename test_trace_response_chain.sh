#!/bin/bash

# Unit test for trace_response_chain.sh
# This script tests the functionality of the trace_response_chain.sh script

# Set up test environment
echo "Setting up test environment..."
TEST_LOG="test_results.log"
echo "Starting test at $(date)" > $TEST_LOG

# Function to check if a string exists in a file
check_content() {
    local file=$1
    local search_string=$2
    local description=$3
    
    if grep -q "$search_string" "$file"; then
        echo "✓ PASS: $description" | tee -a $TEST_LOG
        return 0
    else
        echo "✗ FAIL: $description" | tee -a $TEST_LOG
        return 1
    fi
}

# Test 1: Check if the script is executable
echo "Test 1: Checking if script is executable..." | tee -a $TEST_LOG
if [[ -x "./trace_response_chain.sh" ]]; then
    echo "✓ PASS: Script is executable" | tee -a $TEST_LOG
else
    echo "✗ FAIL: Script is not executable" | tee -a $TEST_LOG
    echo "Making script executable..." | tee -a $TEST_LOG
    chmod +x ./trace_response_chain.sh
fi

# Test 2: Run the script and check if it executes without errors
echo "Test 2: Running script..." | tee -a $TEST_LOG
./trace_response_chain.sh
if [[ $? -eq 0 ]]; then
    echo "✓ PASS: Script executed successfully" | tee -a $TEST_LOG
else
    echo "✗ FAIL: Script execution failed" | tee -a $TEST_LOG
    exit 1
fi

# Test 3: Check if log file was created
echo "Test 3: Checking if log file was created..." | tee -a $TEST_LOG
if [[ -f "response_chain.log" ]]; then
    echo "✓ PASS: Log file was created" | tee -a $TEST_LOG
else
    echo "✗ FAIL: Log file was not created" | tee -a $TEST_LOG
    exit 1
fi

# Test 4: Check if all services are documented in the script
echo "Test 4: Checking if all services are documented..." | tee -a $TEST_LOG

# Array of services that should be documented
services=(
    "Authentication Service"
    "User Context Service"
    "Natural Language Understanding (NLU) Service"
    "Knowledge Graph Service"
    "Weather API"
    "Response Generation Service"
    "Personalization Service"
    "Analytics Service"
)

# Check each service
failures=0
for service in "${services[@]}"; do
    if ! check_content "trace_response_chain.sh" "$service" "Script contains documentation for $service"; then
        failures=$((failures+1))
    fi
done

# Test 5: Check if the script contains proper comments for each service
echo "Test 5: Checking if services have proper comments..." | tee -a $TEST_LOG

comment_patterns=(
    "Purpose:"
    "Input:"
    "Output:"
    "Technology:"
    "Dependencies:"
)

for pattern in "${comment_patterns[@]}"; do
    if ! check_content "trace_response_chain.sh" "$pattern" "Script contains $pattern documentation"; then
        failures=$((failures+1))
    fi
done

# Test 6: Check if the final response is generated
echo "Test 6: Checking if final response is generated..." | tee -a $TEST_LOG
check_content "response_chain.log" "FINAL RESPONSE" "Final response is generated"

# Test 7: Check if the response chain summary is included
echo "Test 7: Checking if response chain summary is included..." | tee -a $TEST_LOG
check_content "response_chain.log" "Response Chain Summary:" "Response chain summary is included"

# Summary
echo -e "\nTest Summary:" | tee -a $TEST_LOG
if [[ $failures -eq 0 ]]; then
    echo "All tests passed successfully!" | tee -a $TEST_LOG
else
    echo "$failures tests failed." | tee -a $TEST_LOG
fi

echo "Testing completed at $(date)" | tee -a $TEST_LOG