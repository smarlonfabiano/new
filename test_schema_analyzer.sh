#!/bin/bash

# Test script for the database schema analyzer

# Make the analyzer script executable
chmod +x /workspace/analyze_db_schema.sh

# Set text colors for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Running database schema analyzer test...${NC}"

# Run the analyzer and capture its output
output=$(/workspace/analyze_db_schema.sh)

# Check if the output contains expected elements
expected_elements=(
    "DATABASE SCHEMA ANALYSIS REPORT"
    "Tables defined in"
    "Foreign key relationships"
    "Models defined in"
    "Relationships in"
    "SCHEMA SUMMARY"
    "Total tables defined in SQL"
    "Total models defined in Python"
    "Total relationships"
    "Schema Design Analysis"
)

all_passed=true

for element in "${expected_elements[@]}"; do
    if echo "$output" | grep -q "$element"; then
        echo -e "${GREEN}✓ Output contains: $element${NC}"
    else
        echo -e "${RED}✗ Output missing: $element${NC}"
        all_passed=false
    fi
done

# Check if specific tables are found
tables=("users" "products" "orders" "order_items" "categories" "product_categories")

for table in "${tables[@]}"; do
    if echo "$output" | grep -q "$table"; then
        echo -e "${GREEN}✓ Found table: $table${NC}"
    else
        echo -e "${RED}✗ Missing table: $table${NC}"
        all_passed=false
    fi
done

# Check if specific models are found
models=("User" "Product" "Order" "OrderItem" "Category")

for model in "${models[@]}"; do
    if echo "$output" | grep -q "$model"; then
        echo -e "${GREEN}✓ Found model: $model${NC}"
    else
        echo -e "${RED}✗ Missing model: $model${NC}"
        all_passed=false
    fi
done

# Final result
if $all_passed; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi