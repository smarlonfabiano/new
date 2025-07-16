#!/bin/bash

# This script was generated with the following verbatim command:
# $ cat > generate_script.sh << 'EOF'
# #!/bin/bash
#
# # This script was generated with the following verbatim command:
# # $ cat > generate_script.sh << 'EOF'
# # [content of the script]
# # EOF
# # $ chmod +x generate_script.sh
#
# [... script content ...]
# EOF
# $ chmod +x generate_script.sh

# Purpose: This script demonstrates a simple utility that processes files
# and includes comments about how it was verbatim generated using a heredoc

# Function to display usage information
display_usage() {
    echo "Usage: $0 [options] [file]"
    echo "Options:"
    echo "  -h, --help     Display this help message"
    echo "  -v, --verbose  Enable verbose output"
    echo "  -c, --count    Count lines in the file"
}

# Function to count lines in a file
count_lines() {
    local file=$1
    if [[ -f "$file" ]]; then
        wc -l < "$file"
    else
        echo "Error: File not found: $file" >&2
        return 1
    fi
}

# Default values
verbose=false
count=false
file=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            display_usage
            exit 0
            ;;
        -v|--verbose)
            verbose=true
            shift
            ;;
        -c|--count)
            count=true
            shift
            ;;
        *)
            if [[ -z "$file" ]]; then
                file=$1
            else
                echo "Error: Too many arguments" >&2
                display_usage
                exit 1
            fi
            shift
            ;;
    esac
done

# Main script logic
if [[ -z "$file" ]]; then
    echo "No file specified"
    display_usage
    exit 1
fi

if [[ "$verbose" = true ]]; then
    echo "Processing file: $file"
fi

if [[ "$count" = true ]]; then
    lines=$(count_lines "$file")
    if [[ $? -eq 0 ]]; then
        echo "File $file has $lines lines"
    else
        exit 1
    fi
fi

# End of script
# This script was created using a heredoc (here document) in bash
# The verbatim command that generated this script is shown at the top
# The heredoc approach allows for creating files with predefined content
# without needing to use multiple echo statements or an editor