#!/bin/bash

# Make the analyzer script executable
chmod +x ./business_logic_analyzer.sh

# Run the analyzer on the current directory
./business_logic_analyzer.sh /workspace

echo ""
echo "Analysis complete! The script has identified business logic rules, validation patterns,"
echo "and data processing workflows in the codebase and provided comments on each."