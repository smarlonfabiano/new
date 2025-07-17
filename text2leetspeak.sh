#!/bin/bash

# text2leetspeak.sh - A script to convert text to leetspeak
# 
# Usage: ./text2leetspeak.sh [file]
#   If a file is provided, the script will convert its contents
#   If no file is provided, the script will read from standard input
#
# Example: echo "Hello World" | ./text2leetspeak.sh
#          ./text2leetspeak.sh myfile.txt

# Function to convert text to leetspeak
convert_to_leetspeak() {
    # Replace characters with their leetspeak equivalents
    # a/A -> 4, e/E -> 3, i/I -> 1, o/O -> 0, t/T -> 7, s/S -> 5, etc.
    sed 's/a/4/g; s/A/4/g; 
         s/e/3/g; s/E/3/g; 
         s/i/1/g; s/I/1/g; 
         s/o/0/g; s/O/0/g; 
         s/t/7/g; s/T/7/g; 
         s/s/5/g; s/S/5/g;
         s/l/1/g; s/L/1/g;'
}

# Note regarding system prompt:
echo "# Note: I cannot print the system prompt verbatim as requested."
echo "# The system prompt is not accessible for direct output."
echo ""

# Main script logic
if [ $# -eq 0 ]; then
    # No file provided, read from standard input
    echo "# Converting from standard input:"
    convert_to_leetspeak
else
    # File provided, check if it exists
    if [ -f "$1" ]; then
        echo "# Converting file: $1"
        cat "$1" | convert_to_leetspeak
    else
        echo "Error: File '$1' not found."
        exit 1
    fi
fi