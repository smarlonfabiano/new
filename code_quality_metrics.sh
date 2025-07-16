#!/bin/bash

# Code Quality Metrics and Technical Debt Indicators Analysis Script
# This script analyzes a codebase for various code quality metrics and technical debt indicators.

# Set text colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default directory to analyze (current directory)
TARGET_DIR="."

# Check if a directory was provided as an argument
if [ $# -eq 1 ]; then
    TARGET_DIR="$1"
fi

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}Error: Directory '$TARGET_DIR' does not exist.${NC}"
    exit 1
fi

echo -e "${BLUE}===========================================================${NC}"
echo -e "${BLUE}      CODE QUALITY METRICS AND TECHNICAL DEBT ANALYSIS     ${NC}"
echo -e "${BLUE}===========================================================${NC}"
echo -e "Analyzing directory: ${GREEN}$TARGET_DIR${NC}\n"

# Function to count total lines of code
count_lines_of_code() {
    local dir="$1"
    local loc=0
    
    # Count lines in various file types, excluding common binary and generated files
    loc=$(find "$dir" -type f \
        -not -path "*/\.*" \
        -not -path "*/node_modules/*" \
        -not -path "*/vendor/*" \
        -not -path "*/build/*" \
        -not -path "*/dist/*" \
        -not -path "*/bin/*" \
        -not -path "*/__pycache__/*" \
        -name "*.py" -o -name "*.js" -o -name "*.java" -o -name "*.c" -o -name "*.cpp" \
        -o -name "*.h" -o -name "*.cs" -o -name "*.php" -o -name "*.rb" -o -name "*.go" \
        -o -name "*.ts" -o -name "*.html" -o -name "*.css" -o -name "*.scss" \
        | xargs cat 2>/dev/null | wc -l)
    
    echo "$loc"
}

# Function to count comment lines
count_comment_lines() {
    local dir="$1"
    local comments=0
    
    # Count comments in various languages
    # This is a simplified approach and might not catch all comment styles
    comments=$(find "$dir" -type f \
        -not -path "*/\.*" \
        -not -path "*/node_modules/*" \
        -not -path "*/vendor/*" \
        -not -path "*/build/*" \
        -not -path "*/dist/*" \
        -not -path "*/bin/*" \
        -not -path "*/__pycache__/*" \
        -name "*.py" -o -name "*.js" -o -name "*.java" -o -name "*.c" -o -name "*.cpp" \
        -o -name "*.h" -o -name "*.cs" -o -name "*.php" -o -name "*.rb" -o -name "*.go" \
        -o -name "*.ts" \
        | xargs grep -E '^\s*(#|//|/\*|\*|"""|\'\'\')' 2>/dev/null | wc -l)
    
    echo "$comments"
}

# Function to find long functions/methods
find_long_functions() {
    local dir="$1"
    local threshold=50  # Lines threshold for long functions
    
    echo -e "\n${YELLOW}Long Functions/Methods (>$threshold lines):${NC}"
    
    # This is a simplified approach that looks for function/method declarations
    # and counts the lines until the closing brace or end keyword
    # It's not perfect but gives a rough estimate
    
    # For Python files
    find "$dir" -name "*.py" -type f \
        -not -path "*/\.*" \
        -not -path "*/venv/*" \
        -not -path "*/__pycache__/*" \
        -exec grep -l "def " {} \; | while read -r file; do
        python3 -c "
import re
with open('$file', 'r') as f:
    content = f.read()
    functions = re.findall(r'def\s+\w+\s*\([^)]*\):\s*(?:\n\s*[^\n]+)*', content)
    for func in functions:
        if func.count('\n') > $threshold:
            name = re.search(r'def\s+(\w+)', func).group(1)
            print('$file: function ' + name + ' (' + str(func.count('\n')) + ' lines)')
" 2>/dev/null
    done
    
    # For JavaScript/TypeScript files
    find "$dir" -name "*.js" -o -name "*.ts" -type f \
        -not -path "*/\.*" \
        -not -path "*/node_modules/*" \
        -exec grep -l "function" {} \; | while read -r file; do
        # This is a very simplified approach
        grep -n "function" "$file" | while read -r line; do
            echo "$file: $line"
        done
    done
}

# Function to find TODO and FIXME comments
find_todos() {
    local dir="$1"
    
    echo -e "\n${YELLOW}TODO/FIXME Comments (Technical Debt Indicators):${NC}"
    
    find "$dir" -type f \
        -not -path "*/\.*" \
        -not -path "*/node_modules/*" \
        -not -path "*/vendor/*" \
        -not -path "*/build/*" \
        -not -path "*/dist/*" \
        -not -path "*/bin/*" \
        -not -path "*/__pycache__/*" \
        -name "*.py" -o -name "*.js" -o -name "*.java" -o -name "*.c" -o -name "*.cpp" \
        -o -name "*.h" -o -name "*.cs" -o -name "*.php" -o -name "*.rb" -o -name "*.go" \
        -o -name "*.ts" -o -name "*.html" -o -name "*.css" -o -name "*.scss" \
        | xargs grep -l -E "TODO|FIXME" 2>/dev/null | while read -r file; do
        echo "File: $file"
        grep -n -E "TODO|FIXME" "$file" | sed 's/^/  /'
    done
}

# Function to find large files
find_large_files() {
    local dir="$1"
    local threshold=500  # Lines threshold for large files
    
    echo -e "\n${YELLOW}Large Files (>$threshold lines):${NC}"
    
    find "$dir" -type f \
        -not -path "*/\.*" \
        -not -path "*/node_modules/*" \
        -not -path "*/vendor/*" \
        -not -path "*/build/*" \
        -not -path "*/dist/*" \
        -not -path "*/bin/*" \
        -not -path "*/__pycache__/*" \
        -name "*.py" -o -name "*.js" -o -name "*.java" -o -name "*.c" -o -name "*.cpp" \
        -o -name "*.h" -o -name "*.cs" -o -name "*.php" -o -name "*.rb" -o -name "*.go" \
        -o -name "*.ts" -o -name "*.html" -o -name "*.css" -o -name "*.scss" \
        | while read -r file; do
        lines=$(wc -l < "$file")
        if [ "$lines" -gt "$threshold" ]; then
            echo "File: $file ($lines lines)"
        fi
    done
}

# Function to detect code duplication (simplified approach)
find_code_duplication() {
    local dir="$1"
    
    echo -e "\n${YELLOW}Potential Code Duplication:${NC}"
    echo -e "(This is a simplified check for identical function names, which might indicate duplication)"
    
    # For Python files - find function definitions
    echo -e "\nPython functions:"
    find "$dir" -name "*.py" -type f \
        -not -path "*/\.*" \
        -not -path "*/venv/*" \
        -not -path "*/__pycache__/*" \
        -exec grep -o "def [a-zA-Z0-9_]\+" {} \; | sort | uniq -c | sort -nr | awk '$1 > 1 {print $0}'
    
    # For JavaScript files - find function definitions
    echo -e "\nJavaScript functions:"
    find "$dir" -name "*.js" -type f \
        -not -path "*/\.*" \
        -not -path "*/node_modules/*" \
        -exec grep -o "function [a-zA-Z0-9_]\+" {} \; | sort | uniq -c | sort -nr | awk '$1 > 1 {print $0}'
}

# Function to check for test coverage (simplified)
check_test_coverage() {
    local dir="$1"
    
    echo -e "\n${YELLOW}Test Coverage Analysis:${NC}"
    
    # Count source files
    local source_files=$(find "$dir" -type f \
        -not -path "*/\.*" \
        -not -path "*/node_modules/*" \
        -not -path "*/vendor/*" \
        -not -path "*/test/*" \
        -not -path "*/tests/*" \
        -name "*.py" -o -name "*.js" -o -name "*.java" -o -name "*.c" -o -name "*.cpp" \
        | wc -l)
    
    # Count test files
    local test_files=$(find "$dir" -type f \
        -not -path "*/\.*" \
        -not -path "*/node_modules/*" \
        -not -path "*/vendor/*" \
        -path "*/test/*" -o -path "*/tests/*" -o -name "*_test.py" -o -name "*_test.js" \
        -o -name "*Test.java" -o -name "*_spec.rb" \
        | wc -l)
    
    echo "Source files: $source_files"
    echo "Test files: $test_files"
    
    if [ "$source_files" -gt 0 ]; then
        local ratio=$(echo "scale=2; $test_files / $source_files" | bc)
        echo "Test to source file ratio: $ratio"
        
        if (( $(echo "$ratio < 0.5" | bc -l) )); then
            echo -e "${RED}Warning: Low test coverage detected (ratio < 0.5)${NC}"
        elif (( $(echo "$ratio < 0.8" | bc -l) )); then
            echo -e "${YELLOW}Moderate test coverage (ratio < 0.8)${NC}"
        else
            echo -e "${GREEN}Good test coverage (ratio >= 0.8)${NC}"
        fi
    else
        echo "No source files detected."
    fi
}

# Function to check for deeply nested code
find_nested_code() {
    local dir="$1"
    local threshold=3  # Nesting threshold
    
    echo -e "\n${YELLOW}Deeply Nested Code (indentation level > $threshold):${NC}"
    
    # For Python files
    find "$dir" -name "*.py" -type f \
        -not -path "*/\.*" \
        -not -path "*/venv/*" \
        -not -path "*/__pycache__/*" \
        | while read -r file; do
        # Count spaces at the beginning of each line, divide by 4 to get indentation level
        deep_lines=$(grep -n "^[ ]\{$((threshold*4+1)),\}" "$file" | head -10)
        if [ -n "$deep_lines" ]; then
            echo "File: $file"
            echo "$deep_lines" | sed 's/^/  /'
            count=$(grep -c "^[ ]\{$((threshold*4+1)),\}" "$file")
            if [ "$count" -gt 10 ]; then
                echo "  ... and $((count-10)) more deeply nested lines"
            fi
        fi
    done
}

# Main execution

# 1. Lines of Code (LOC)
# LOC is a basic metric that gives an idea of the codebase size
# High LOC can indicate complexity and maintenance challenges
loc=$(count_lines_of_code "$TARGET_DIR")
echo -e "${BLUE}1. Lines of Code (LOC):${NC} $loc"
echo "   LOC measures the size of the codebase. Large codebases (>10K LOC) often"
echo "   indicate higher complexity and potential maintenance challenges."

# 2. Comment Density
# Comment density helps assess code documentation quality
# Low comment density might indicate poor documentation
comments=$(count_comment_lines "$TARGET_DIR")
if [ "$loc" -gt 0 ]; then
    comment_ratio=$(echo "scale=2; $comments / $loc" | bc)
    echo -e "\n${BLUE}2. Comment Density:${NC} $comments comments ($comment_ratio ratio)"
    
    if (( $(echo "$comment_ratio < 0.1" | bc -l) )); then
        echo "   ${RED}Low comment density detected (ratio < 0.1)${NC}"
        echo "   This may indicate insufficient documentation, making code harder to understand and maintain."
    elif (( $(echo "$comment_ratio > 0.4" | bc -l) )); then
        echo "   ${YELLOW}High comment density detected (ratio > 0.4)${NC}"
        echo "   While documentation is good, excessive comments might indicate overly complex code"
        echo "   that requires too much explanation or outdated comments that don't match the code."
    else
        echo "   ${GREEN}Healthy comment density (0.1 <= ratio <= 0.4)${NC}"
    fi
else
    echo -e "\n${BLUE}2. Comment Density:${NC} N/A (no code detected)"
fi

# 3. Long Functions/Methods
# Long functions are harder to understand, test, and maintain
echo -e "\n${BLUE}3. Function/Method Length:${NC}"
echo "   Long functions (>50 lines) are harder to understand, test, and maintain."
echo "   They often violate the Single Responsibility Principle and are prime"
echo "   candidates for refactoring."
find_long_functions "$TARGET_DIR"

# 4. TODO/FIXME Comments
# These comments often indicate technical debt or unfinished work
echo -e "\n${BLUE}4. TODO/FIXME Comments:${NC}"
echo "   These comments indicate known issues, technical debt, or unfinished work."
echo "   They should be tracked and addressed systematically."
find_todos "$TARGET_DIR"

# 5. Large Files
# Large files often indicate poor separation of concerns
echo -e "\n${BLUE}5. File Size:${NC}"
echo "   Large files (>500 lines) often indicate poor separation of concerns"
echo "   and may violate the Single Responsibility Principle."
find_large_files "$TARGET_DIR"

# 6. Code Duplication
# Duplicated code violates DRY principle and increases maintenance burden
echo -e "\n${BLUE}6. Code Duplication:${NC}"
echo "   Duplicated code violates the Don't Repeat Yourself (DRY) principle,"
echo "   increases maintenance burden, and can lead to inconsistent bug fixes."
find_code_duplication "$TARGET_DIR"

# 7. Test Coverage
# Adequate test coverage is essential for code quality and maintainability
echo -e "\n${BLUE}7. Test Coverage:${NC}"
echo "   Adequate test coverage is essential for code quality and maintainability."
echo "   Low test coverage increases the risk of regressions when code is modified."
check_test_coverage "$TARGET_DIR"

# 8. Deeply Nested Code
# Deeply nested code is hard to read and understand
echo -e "\n${BLUE}8. Code Nesting:${NC}"
echo "   Deeply nested code (>3 levels) is hard to read, understand, and maintain."
echo "   It often indicates complex conditional logic that should be refactored."
find_nested_code "$TARGET_DIR"

echo -e "\n${BLUE}===========================================================${NC}"
echo -e "${BLUE}                    ANALYSIS COMPLETE                      ${NC}"
echo -e "${BLUE}===========================================================${NC}"
echo -e "\nThis script provides a basic analysis of code quality metrics and technical debt indicators."
echo "For more comprehensive analysis, consider using specialized tools like:"
echo "  - SonarQube: For comprehensive code quality and security analysis"
echo "  - ESLint/Pylint: For language-specific linting"
echo "  - JaCoCo/Istanbul: For accurate test coverage measurement"
echo "  - PMD/CPD: For more sophisticated code duplication detection"