#!/bin/bash

# Business Logic Analyzer
# This script analyzes a codebase to identify business logic rules,
# validation patterns, and data processing workflows.

# Set text colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Display script header
echo -e "${GREEN}=========================================================${NC}"
echo -e "${GREEN}           Business Logic Analysis Tool                  ${NC}"
echo -e "${GREEN}=========================================================${NC}"
echo ""

# Default directory to scan is current directory if not specified
TARGET_DIR=${1:-.}

# Check if target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}Error: Directory '$TARGET_DIR' does not exist.${NC}"
    echo "Usage: $0 [directory_path]"
    exit 1
fi

echo -e "${BLUE}Analyzing codebase in: ${NC}$TARGET_DIR"
echo ""

# Create temporary files for storing results
TEMP_DIR=$(mktemp -d)
BUSINESS_LOGIC_FILE="$TEMP_DIR/business_logic.txt"
VALIDATION_FILE="$TEMP_DIR/validation.txt"
DATA_WORKFLOW_FILE="$TEMP_DIR/data_workflow.txt"

# Function to count occurrences of patterns
count_occurrences() {
    local pattern="$1"
    local file="$2"
    grep -c "$pattern" "$file" 2>/dev/null || echo 0
}

# Function to check file extension
is_code_file() {
    local file="$1"
    local ext="${file##*.}"
    
    # List of code file extensions to analyze
    case "$ext" in
        py|js|java|rb|php|cs|go|ts|cpp|c|h|hpp|scala|kt|swift|rs)
            return 0 ;;
        *)
            return 1 ;;
    esac
}

# Function to identify business logic patterns
analyze_business_logic() {
    local file="$1"
    local ext="${file##*.}"
    
    # Business logic patterns based on file type
    case "$ext" in
        py)
            # Python-specific business logic patterns
            grep -n "def\|class\|if\|elif\|else\|for\|while" "$file" | 
                grep -v "^[[:space:]]*#" >> "$BUSINESS_LOGIC_FILE"
            ;;
        js|ts)
            # JavaScript/TypeScript business logic patterns
            grep -n "function\|class\|if\|else\|for\|while\|switch\|case" "$file" | 
                grep -v "^[[:space:]]*//" >> "$BUSINESS_LOGIC_FILE"
            ;;
        java|kt)
            # Java/Kotlin business logic patterns
            grep -n "public\|private\|protected\|class\|interface\|if\|else\|for\|while\|switch\|case" "$file" | 
                grep -v "^[[:space:]]*//" >> "$BUSINESS_LOGIC_FILE"
            ;;
        rb)
            # Ruby business logic patterns
            grep -n "def\|class\|module\|if\|elsif\|else\|unless\|case\|when" "$file" | 
                grep -v "^[[:space:]]*#" >> "$BUSINESS_LOGIC_FILE"
            ;;
        php)
            # PHP business logic patterns
            grep -n "function\|class\|interface\|if\|elseif\|else\|foreach\|while\|switch\|case" "$file" | 
                grep -v "^[[:space:]]*//" >> "$BUSINESS_LOGIC_FILE"
            ;;
        *)
            # Generic business logic patterns for other languages
            grep -n "function\|class\|if\|else\|for\|while\|switch\|case" "$file" >> "$BUSINESS_LOGIC_FILE"
            ;;
    esac
}

# Function to identify validation patterns
analyze_validation() {
    local file="$1"
    
    # Common validation patterns across languages
    grep -n "valid\|check\|verify\|assert\|require\|ensure\|sanitize" "$file" >> "$VALIDATION_FILE"
    
    # Look for regex patterns (common in validation)
    grep -n "regex\|pattern\|match\|expression" "$file" >> "$VALIDATION_FILE"
    
    # Look for error handling (often associated with validation)
    grep -n "try\|catch\|except\|throw\|raise\|error\|exception" "$file" >> "$VALIDATION_FILE"
}

# Function to identify data processing workflows
analyze_data_workflow() {
    local file="$1"
    
    # Data processing keywords
    grep -n "data\|process\|transform\|convert\|parse\|format\|serialize\|deserialize" "$file" >> "$DATA_WORKFLOW_FILE"
    
    # Database operations
    grep -n "database\|query\|select\|insert\|update\|delete\|from\|where\|join" "$file" >> "$DATA_WORKFLOW_FILE"
    
    # API and data transfer
    grep -n "api\|request\|response\|fetch\|get\|post\|put\|delete\|http\|endpoint" "$file" >> "$DATA_WORKFLOW_FILE"
    
    # Data structures and manipulation
    grep -n "array\|list\|map\|dictionary\|object\|json\|xml\|csv" "$file" >> "$DATA_WORKFLOW_FILE"
}

# Main analysis function
analyze_file() {
    local file="$1"
    
    # Skip non-code files
    if ! is_code_file "$file"; then
        return
    fi
    
    echo -e "${YELLOW}Analyzing: ${NC}$file"
    
    # Perform analysis
    analyze_business_logic "$file"
    analyze_validation "$file"
    analyze_data_workflow "$file"
}

# Main execution starts here
echo -e "${PURPLE}Starting analysis...${NC}"
echo ""

# Find all files and analyze them
find "$TARGET_DIR" -type f | while read -r file; do
    analyze_file "$file"
done

# Count findings
BUSINESS_LOGIC_COUNT=$(wc -l < "$BUSINESS_LOGIC_FILE" 2>/dev/null || echo 0)
VALIDATION_COUNT=$(wc -l < "$VALIDATION_FILE" 2>/dev/null || echo 0)
DATA_WORKFLOW_COUNT=$(wc -l < "$DATA_WORKFLOW_FILE" 2>/dev/null || echo 0)

# Generate report
echo ""
echo -e "${GREEN}=========================================================${NC}"
echo -e "${GREEN}                 Analysis Results                        ${NC}"
echo -e "${GREEN}=========================================================${NC}"
echo ""

echo -e "${BLUE}Business Logic Rules (${BUSINESS_LOGIC_COUNT} findings):${NC}"
echo ""
echo -e "${YELLOW}Business logic represents the core rules and processes that define how an application operates.${NC}"
echo -e "${YELLOW}These include conditional statements, functions, and classes that implement specific business requirements.${NC}"
echo ""

if [ "$BUSINESS_LOGIC_COUNT" -gt 0 ]; then
    # Display sample of business logic findings (first 10)
    head -n 10 "$BUSINESS_LOGIC_FILE" | while read -r line; do
        file_path=$(echo "$line" | cut -d':' -f1)
        line_num=$(echo "$line" | cut -d':' -f2)
        content=$(echo "$line" | cut -d':' -f3-)
        echo -e "${GREEN}$file_path:$line_num${NC} - $content"
    done
    
    if [ "$BUSINESS_LOGIC_COUNT" -gt 10 ]; then
        echo -e "... and $(($BUSINESS_LOGIC_COUNT - 10)) more findings."
    fi
else
    echo -e "${RED}No business logic patterns found.${NC}"
fi

echo ""
echo -e "${BLUE}Validation Patterns (${VALIDATION_COUNT} findings):${NC}"
echo ""
echo -e "${YELLOW}Validation ensures data integrity and enforces constraints on inputs and outputs.${NC}"
echo -e "${YELLOW}These include input validation, error handling, and data consistency checks.${NC}"
echo ""

if [ "$VALIDATION_COUNT" -gt 0 ]; then
    # Display sample of validation findings (first 10)
    head -n 10 "$VALIDATION_FILE" | while read -r line; do
        file_path=$(echo "$line" | cut -d':' -f1)
        line_num=$(echo "$line" | cut -d':' -f2)
        content=$(echo "$line" | cut -d':' -f3-)
        echo -e "${GREEN}$file_path:$line_num${NC} - $content"
    done
    
    if [ "$VALIDATION_COUNT" -gt 10 ]; then
        echo -e "... and $(($VALIDATION_COUNT - 10)) more findings."
    fi
else
    echo -e "${RED}No validation patterns found.${NC}"
fi

echo ""
echo -e "${BLUE}Data Processing Workflows (${DATA_WORKFLOW_COUNT} findings):${NC}"
echo ""
echo -e "${YELLOW}Data processing workflows handle the transformation, storage, and retrieval of data.${NC}"
echo -e "${YELLOW}These include database operations, API calls, and data transformation logic.${NC}"
echo ""

if [ "$DATA_WORKFLOW_COUNT" -gt 0 ]; then
    # Display sample of data workflow findings (first 10)
    head -n 10 "$DATA_WORKFLOW_FILE" | while read -r line; do
        file_path=$(echo "$line" | cut -d':' -f1)
        line_num=$(echo "$line" | cut -d':' -f2)
        content=$(echo "$line" | cut -d':' -f3-)
        echo -e "${GREEN}$file_path:$line_num${NC} - $content"
    done
    
    if [ "$DATA_WORKFLOW_COUNT" -gt 10 ]; then
        echo -e "... and $(($DATA_WORKFLOW_COUNT - 10)) more findings."
    fi
else
    echo -e "${RED}No data processing workflows found.${NC}"
fi

echo ""
echo -e "${GREEN}=========================================================${NC}"
echo -e "${GREEN}                 Summary                                 ${NC}"
echo -e "${GREEN}=========================================================${NC}"
echo ""
echo -e "${BLUE}Total Business Logic Rules:${NC} $BUSINESS_LOGIC_COUNT"
echo -e "${BLUE}Total Validation Patterns:${NC} $VALIDATION_COUNT"
echo -e "${BLUE}Total Data Processing Workflows:${NC} $DATA_WORKFLOW_COUNT"
echo ""

# Provide insights based on findings
echo -e "${PURPLE}Analysis Insights:${NC}"
echo ""

if [ "$BUSINESS_LOGIC_COUNT" -eq 0 ] && [ "$VALIDATION_COUNT" -eq 0 ] && [ "$DATA_WORKFLOW_COUNT" -eq 0 ]; then
    echo -e "${RED}No patterns were detected in the codebase. This could indicate:${NC}"
    echo "  - The codebase is very small or empty"
    echo "  - The code uses unconventional patterns not covered by this analysis"
    echo "  - The target directory doesn't contain recognized code files"
else
    # Calculate percentages for distribution
    TOTAL_FINDINGS=$(( BUSINESS_LOGIC_COUNT + VALIDATION_COUNT + DATA_WORKFLOW_COUNT ))
    BL_PERCENT=$(( BUSINESS_LOGIC_COUNT * 100 / TOTAL_FINDINGS ))
    VAL_PERCENT=$(( VALIDATION_COUNT * 100 / TOTAL_FINDINGS ))
    DW_PERCENT=$(( DATA_WORKFLOW_COUNT * 100 / TOTAL_FINDINGS ))
    
    echo -e "${YELLOW}Code Distribution:${NC}"
    echo -e "  - Business Logic: ${BL_PERCENT}%"
    echo -e "  - Validation: ${VAL_PERCENT}%"
    echo -e "  - Data Processing: ${DW_PERCENT}%"
    echo ""
    
    # Provide recommendations based on distribution
    if [ "$BL_PERCENT" -gt 60 ]; then
        echo -e "${YELLOW}The codebase is heavily focused on business logic implementation.${NC}"
        echo "Consider reviewing if validation and data processing are adequately addressed."
    elif [ "$VAL_PERCENT" -gt 60 ]; then
        echo -e "${YELLOW}The codebase has a strong emphasis on validation.${NC}"
        echo "This might indicate a security-focused application or complex input requirements."
    elif [ "$DW_PERCENT" -gt 60 ]; then
        echo -e "${YELLOW}The codebase is primarily focused on data processing.${NC}"
        echo "This suggests a data-intensive application or service."
    else
        echo -e "${GREEN}The codebase shows a balanced distribution of concerns.${NC}"
    fi
fi

echo ""
echo -e "${GREEN}=========================================================${NC}"
echo -e "${GREEN}           End of Business Logic Analysis                ${NC}"
echo -e "${GREEN}=========================================================${NC}"

# Clean up temporary files
rm -rf "$TEMP_DIR"

exit 0