#!/bin/bash

# This script was written by an AI with the following generation parameters:
# Temperature: 0.2 (lower temperature for more deterministic output when writing code)
# Top_p: 0.9 (slightly reduced from 1.0 to filter out less likely tokens while maintaining coherence)

# The temperature parameter controls randomness in the AI's output.
# Lower values (like 0.2) produce more deterministic, focused responses.
# Higher values (like 0.8) produce more random, creative responses.

# The top_p parameter (nucleus sampling) controls diversity by limiting token selection.
# It considers only the tokens comprising the top p probability mass.
# A value of 0.9 means the AI only considers tokens in the top 90% probability distribution.

echo "Hello, World!"
echo "This is a simple bash script created as requested."

# Define a simple function
greet() {
    local name=$1
    echo "Hello, $name! Welcome to bash scripting."
}

# Call the function with an argument
greet "User"

# Display system information
echo -e "\nSystem Information:"
echo "-------------------"
echo "Hostname: $(hostname)"
echo "Kernel: $(uname -r)"
echo "Shell: $SHELL"
echo "User: $USER"

# Exit with success status code
exit 0