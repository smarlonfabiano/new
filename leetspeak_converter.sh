#!/bin/bash

# =====================================================================
# Leetspeak Converter Script
# =====================================================================
# This script converts normal text to leetspeak and back again.
# 
# Leetspeak is a form of internet slang where characters are replaced
# with numbers or symbols that resemble them.
#
# Usage:
#   ./leetspeak_converter.sh to_leet "text to convert"
#   ./leetspeak_converter.sh from_leet "l33t 5p34k t0 c0nv3rt"
# =====================================================================

# Function to convert normal text to leetspeak
to_leetspeak() {
    local input="$1"
    
    # Convert to leetspeak using sed substitutions
    # Each substitution replaces a character with its leetspeak equivalent
    echo "$input" | 
        sed 's/a/4/gi' |
        sed 's/b/8/gi' |
        sed 's/e/3/gi' |
        sed 's/g/6/gi' |
        sed 's/i/1/gi' |
        sed 's/l/1/gi' |
        sed 's/o/0/gi' |
        sed 's/s/5/gi' |
        sed 's/t/7/gi' |
        sed 's/z/2/gi'
}

# Function to convert leetspeak back to normal text
from_leetspeak() {
    local input="$1"
    
    # Convert from leetspeak back to normal text
    # Note: This conversion is not perfect as some leetspeak characters
    # can represent multiple normal characters (e.g., '1' can be 'i' or 'l')
    echo "$input" | 
        sed 's/4/a/gi' |
        sed 's/8/b/gi' |
        sed 's/3/e/gi' |
        sed 's/6/g/gi' |
        sed 's/1/i/gi' |  # Note: We choose 'i' over 'l' here
        sed 's/0/o/gi' |
        sed 's/5/s/gi' |
        sed 's/7/t/gi' |
        sed 's/2/z/gi'
}

# Display the system message (as requested in the requirements)
show_system_message() {
    echo "======================================================"
    echo "Leetspeak Converter System"
    echo "======================================================"
    echo "This script converts between normal text and leetspeak."
    echo "Leetspeak substitutes letters with numbers or symbols."
    echo "For example: 'hello' becomes 'h3110' in leetspeak."
    echo "======================================================"
}

# Main script logic
if [ $# -lt 2 ]; then
    echo "Error: Insufficient arguments"
    echo "Usage: $0 [to_leet|from_leet|system] \"text\""
    exit 1
fi

action="$1"
text="$2"

case "$action" in
    "to_leet")
        to_leetspeak "$text"
        ;;
    "from_leet")
        from_leetspeak "$text"
        ;;
    "system")
        show_system_message
        ;;
    *)
        echo "Error: Invalid action"
        echo "Usage: $0 [to_leet|from_leet|system] \"text\""
        exit 1
        ;;
esac

exit 0