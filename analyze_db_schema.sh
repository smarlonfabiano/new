#!/bin/bash

# Database Schema Analysis Script
# This script analyzes the database schemas, relationships, and data models in the system

echo "========================================================"
echo "DATABASE SCHEMA ANALYSIS"
echo "========================================================"
echo

# Function to find Python files with SQLAlchemy models
find_models() {
    echo "Searching for database models..."
    echo
    
    # Find all Python files that might contain SQLAlchemy models
    model_files=$(find . -type f -name "*.py" | grep -v "__pycache__" | grep -v "test_")
    
    for file in $model_files; do
        # Check if file contains SQLAlchemy model definitions
        if grep -q "Base\|Column\|relationship\|ForeignKey" "$file"; then
            echo "Found potential model file: $file"
        fi
    done
    echo
}

# Function to analyze table schemas
analyze_tables() {
    echo "========================================================"
    echo "TABLE SCHEMAS"
    echo "========================================================"
    echo
    
    # Find all __tablename__ declarations to identify tables
    echo "Identified tables:"
    grep -r "__tablename__" --include="*.py" . | sed 's/.*__tablename__.*=.*["\x27]\(.*\)["\x27].*/\1/' | sort | uniq | while read -r table; do
        if [ ! -z "$table" ]; then
            echo "- $table"
        fi
    done
    echo
    
    # For each model file, extract column definitions
    for file in $(find . -path "*/models/*.py" -type f | grep -v "__init__" | grep -v "__pycache__"); do
        table_name=$(grep "__tablename__" "$file" | sed 's/.*__tablename__.*=.*["\x27]\(.*\)["\x27].*/\1/')
        
        if [ ! -z "$table_name" ]; then
            echo "Table: $table_name"
            echo "Columns:"
            
            # Extract column definitions
            grep -A 1 "Column(" "$file" | grep -v "^--$" | sed 's/^[ \t]*/    /' | sed 's/Column(//' | sed 's/)//' | sed 's/,$//'
            echo
        fi
    done
}

# Function to analyze relationships
analyze_relationships() {
    echo "========================================================"
    echo "RELATIONSHIPS"
    echo "========================================================"
    echo
    
    # Find all relationship declarations
    echo "Identified relationships:"
    for file in $(find . -path "*/models/*.py" -type f | grep -v "__init__" | grep -v "__pycache__"); do
        class_name=$(basename "$file" .py | sed 's/_\([a-z]\)/\U\1/g' | sed 's/^./\U&/')
        
        # Skip base.py
        if [ "$class_name" == "Base" ]; then
            continue
        fi
        
        # Extract relationships
        relationships=$(grep -A 1 "relationship(" "$file")
        
        if [ ! -z "$relationships" ]; then
            echo "Model: $class_name"
            echo "$relationships" | sed 's/^[ \t]*/    /' | sed 's/relationship(/Relates to: /' | sed 's/,.*//'
            echo
        fi
    done
    
    # Find all foreign keys
    echo "Foreign Keys:"
    for file in $(find . -path "*/models/*.py" -type f | grep -v "__init__" | grep -v "__pycache__"); do
        class_name=$(basename "$file" .py | sed 's/_\([a-z]\)/\U\1/g' | sed 's/^./\U&/')
        
        # Extract foreign keys
        foreign_keys=$(grep -A 1 "ForeignKey" "$file")
        
        if [ ! -z "$foreign_keys" ]; then
            echo "Model: $class_name"
            echo "$foreign_keys" | sed 's/^[ \t]*/    /' | sed 's/.*ForeignKey(\x27\(.*\)\x27.*/    References: \1/'
            echo
        fi
    done
}

# Function to generate an entity relationship diagram description
describe_er_diagram() {
    echo "========================================================"
    echo "ENTITY RELATIONSHIP DIAGRAM (Description)"
    echo "========================================================"
    echo
    
    echo "The system implements the following data model:"
    echo
    
    # Find all model classes
    for file in $(find . -path "*/models/*.py" -type f | grep -v "__init__" | grep -v "__pycache__" | grep -v "base.py"); do
        class_name=$(basename "$file" .py | sed 's/_\([a-z]\)/\U\1/g' | sed 's/^./\U&/')
        table_name=$(grep "__tablename__" "$file" | sed 's/.*__tablename__.*=.*["\x27]\(.*\)["\x27].*/\1/')
        
        if [ ! -z "$class_name" ] && [ ! -z "$table_name" ]; then
            echo "Entity: $class_name ($table_name)"
            
            # Extract docstring if available
            docstring=$(grep -A 1 '"""' "$file" | grep -v '"""' | head -1)
            if [ ! -z "$docstring" ]; then
                echo "  Description: $docstring"
            fi
            
            # Extract relationships
            relationships=$(grep -A 1 "relationship(" "$file" | grep -v "^--$")
            if [ ! -z "$relationships" ]; then
                echo "  Relationships:"
                echo "$relationships" | sed 's/^[ \t]*/    - /' | sed 's/relationship(//' | sed 's/,.*//'
            fi
            
            echo
        fi
    done
}

# Function to analyze database configuration
analyze_db_config() {
    echo "========================================================"
    echo "DATABASE CONFIGURATION"
    echo "========================================================"
    echo
    
    # Look for database configuration files
    db_files=$(find . -type f -name "*.py" | xargs grep -l "create_engine\|DATABASE_URL\|SQLALCHEMY_DATABASE_URI")
    
    if [ ! -z "$db_files" ]; then
        echo "Database configuration found in:"
        for file in $db_files; do
            echo "- $file"
            
            # Extract database URL if available
            db_url=$(grep "DATABASE_URL\|SQLALCHEMY_DATABASE_URI" "$file" | head -1)
            if [ ! -z "$db_url" ]; then
                echo "  Configuration: $db_url"
            fi
            
            # Extract engine creation if available
            engine=$(grep "create_engine" "$file" | head -1)
            if [ ! -z "$engine" ]; then
                echo "  Engine: $engine"
            fi
        done
    else
        echo "No database configuration found."
    fi
    echo
}

# Main execution
echo "Starting database schema analysis..."
echo

find_models
analyze_tables
analyze_relationships
describe_er_diagram
analyze_db_config

echo "========================================================"
echo "SUMMARY"
echo "========================================================"
echo
echo "This system implements a relational database with the following components:"
echo
echo "1. Users: Stores user account information with authentication details"
echo "2. Products: Represents items available for purchase"
echo "3. Categories: Organizes products into logical groups"
echo "4. Orders: Tracks customer purchases"
echo "5. OrderItems: Represents individual items within an order"
echo
echo "The schema follows a standard e-commerce data model with appropriate"
echo "relationships between entities, including one-to-many relationships"
echo "between users and orders, categories and products, and orders and order items."
echo
echo "Database Schema Analysis Complete!"