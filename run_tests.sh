#!/bin/bash
# Make the analysis script executable
chmod +x /workspace/analyze_db_schema.sh

# Run the tests
python -m unittest /workspace/tests/test_schema_analysis.py