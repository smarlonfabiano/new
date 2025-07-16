#!/bin/bash

# Wrapper script to run the database schema analysis and capture output

echo "Running database schema analysis on current directory..."
bash analyze_db_schema.sh > analysis_results.txt

echo "Analysis complete. Results saved to analysis_results.txt"
echo "Summary of findings:"
echo "-------------------"
grep -E "Found|Detected|=== .* ===" analysis_results.txt

echo ""
echo "For full details, check analysis_results.txt"