#!/bin/bash

# Database Schema Analysis Script
# This script analyzes database schemas, relationships, and data models in a system
# It searches for common database definition files and extracts schema information

echo "=== Database Schema Analysis ==="
echo "Searching for database schema definitions..."
echo ""

# Set the root directory for search (default: current directory)
ROOT_DIR=${1:-.}

# Function to count files of a specific type
count_files() {
    local pattern=$1
    local count=$(find "$ROOT_DIR" -type f -name "$pattern" | wc -l)
    echo "$count"
}

# Function to list files of a specific type
list_files() {
    local pattern=$1
    local description=$2
    local count=$(count_files "$pattern")
    
    if [ "$count" -gt 0 ]; then
        echo "Found $count $description files:"
        find "$ROOT_DIR" -type f -name "$pattern" | sort
        echo ""
    fi
}

# Function to analyze SQL files
analyze_sql_files() {
    local sql_files=$(find "$ROOT_DIR" -type f -name "*.sql" | sort)
    
    if [ -z "$sql_files" ]; then
        return
    fi
    
    echo "=== SQL Schema Analysis ==="
    
    for file in $sql_files; do
        echo "Analyzing $file..."
        
        # Extract CREATE TABLE statements
        echo "  Tables defined:"
        grep -i "CREATE TABLE" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No tables found"
        
        # Extract foreign key constraints
        echo "  Foreign key relationships:"
        grep -i "FOREIGN KEY" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No foreign keys found"
        
        # Extract indexes
        echo "  Indexes:"
        grep -i "CREATE INDEX\|CREATE UNIQUE INDEX" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No indexes found"
        
        echo ""
    done
}

# Function to analyze Ruby on Rails schema.rb
analyze_rails_schema() {
    local schema_file="$ROOT_DIR/db/schema.rb"
    
    if [ ! -f "$schema_file" ]; then
        return
    fi
    
    echo "=== Ruby on Rails Schema Analysis ==="
    echo "Analyzing $schema_file..."
    
    # Extract table definitions
    echo "  Tables defined:"
    grep -i "create_table" "$schema_file" | sed 's/^[[:space:]]*/    /' || echo "    No tables found"
    
    # Extract foreign keys
    echo "  Foreign key relationships:"
    grep -i "add_foreign_key" "$schema_file" | sed 's/^[[:space:]]*/    /' || echo "    No foreign keys found"
    
    # Extract indexes
    echo "  Indexes:"
    grep -i "add_index" "$schema_file" | sed 's/^[[:space:]]*/    /' || echo "    No indexes found"
    
    echo ""
}

# Function to analyze Django models.py files
analyze_django_models() {
    local models_files=$(find "$ROOT_DIR" -type f -name "models.py" | sort)
    
    if [ -z "$models_files" ]; then
        return
    fi
    
    echo "=== Django ORM Models Analysis ==="
    
    for file in $models_files; do
        echo "Analyzing $file..."
        
        # Extract model classes
        echo "  Models defined:"
        grep -i "class.*models.Model" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No models found"
        
        # Extract fields
        echo "  Fields and relationships:"
        grep -i "models\.\(Foreign\|One\|Many\|Char\|Integer\|Text\|Boolean\|Date\|DateTime\)Field" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No fields found"
        
        echo ""
    done
}

# Function to analyze Sequelize models (JavaScript/TypeScript)
analyze_sequelize_models() {
    local model_files=$(find "$ROOT_DIR" -type f -name "*.js" -o -name "*.ts" | xargs grep -l "sequelize.define\|DataTypes" | sort)
    
    if [ -z "$model_files" ]; then
        return
    fi
    
    echo "=== Sequelize ORM Models Analysis ==="
    
    for file in $model_files; do
        echo "Analyzing $file..."
        
        # Extract model definitions
        echo "  Models defined:"
        grep -i "sequelize.define\|\.init(" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No models found"
        
        # Extract associations
        echo "  Relationships:"
        grep -i "\.hasMany\|\.belongsTo\|\.hasOne\|\.belongsToMany" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No relationships found"
        
        echo ""
    done
}

# Function to analyze Prisma schema
analyze_prisma_schema() {
    local prisma_files=$(find "$ROOT_DIR" -type f -name "*.prisma" | sort)
    
    if [ -z "$prisma_files" ]; then
        return
    fi
    
    echo "=== Prisma Schema Analysis ==="
    
    for file in $prisma_files; do
        echo "Analyzing $file..."
        
        # Extract model definitions
        echo "  Models defined:"
        grep -i "model " "$file" | sed 's/^[[:space:]]*/    /' || echo "    No models found"
        
        # Extract relationships
        echo "  Relationships:"
        grep -i "@relation" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No relationships found"
        
        echo ""
    done
}

# Function to analyze TypeORM entities
analyze_typeorm_entities() {
    local entity_files=$(find "$ROOT_DIR" -type f -name "*.entity.ts" -o -name "*.entity.js" | sort)
    
    if [ -z "$entity_files" ]; then
        return
    fi
    
    echo "=== TypeORM Entities Analysis ==="
    
    for file in $entity_files; do
        echo "Analyzing $file..."
        
        # Extract entity definitions
        echo "  Entities defined:"
        grep -i "@Entity" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No entities found"
        
        # Extract columns
        echo "  Columns:"
        grep -i "@Column" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No columns found"
        
        # Extract relationships
        echo "  Relationships:"
        grep -i "@\(One\|Many\)To\(One\|Many\)" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No relationships found"
        
        echo ""
    done
}

# Function to analyze Hibernate/JPA entities
analyze_java_entities() {
    local entity_files=$(find "$ROOT_DIR" -type f -name "*.java" | xargs grep -l "@Entity\|@Table" | sort)
    
    if [ -z "$entity_files" ]; then
        return
    fi
    
    echo "=== Java Hibernate/JPA Entities Analysis ==="
    
    for file in $entity_files; do
        echo "Analyzing $file..."
        
        # Extract entity definitions
        echo "  Entities defined:"
        grep -i "@Entity\|@Table" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No entities found"
        
        # Extract columns
        echo "  Columns:"
        grep -i "@Column" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No columns found"
        
        # Extract relationships
        echo "  Relationships:"
        grep -i "@\(One\|Many\)To\(One\|Many\)\|@JoinColumn" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No relationships found"
        
        echo ""
    done
}

# Function to analyze MongoDB schemas (Mongoose)
analyze_mongoose_schemas() {
    local schema_files=$(find "$ROOT_DIR" -type f -name "*.js" -o -name "*.ts" | xargs grep -l "mongoose.Schema\|new Schema" | sort)
    
    if [ -z "$schema_files" ]; then
        return
    fi
    
    echo "=== MongoDB Mongoose Schemas Analysis ==="
    
    for file in $schema_files; do
        echo "Analyzing $file..."
        
        # Extract schema definitions
        echo "  Schemas defined:"
        grep -i "mongoose.Schema\|new Schema" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No schemas found"
        
        # Extract references (relationships)
        echo "  References (relationships):"
        grep -i "ref:" "$file" | sed 's/^[[:space:]]*/    /' || echo "    No references found"
        
        echo ""
    done
}

# Function to analyze database configuration files
analyze_db_config() {
    echo "=== Database Configuration Analysis ==="
    
    # Check for common database configuration files
    for config_pattern in "database.yml" "database.json" "*.db.config.*" "application.properties" "application.yml" ".env"; do
        local config_files=$(find "$ROOT_DIR" -type f -name "$config_pattern" 2>/dev/null)
        
        if [ -n "$config_files" ]; then
            echo "Found database configuration in:"
            echo "$config_files" | sed 's/^/    /'
        fi
    done
    
    echo ""
}

# Main execution flow

# 1. Count and list database-related files
echo "=== Database Files Overview ==="

list_files "*.sql" "SQL"
list_files "*.db" "SQLite database"
list_files "models.py" "Django model"
list_files "*.entity.ts" "TypeORM entity"
list_files "*.entity.js" "TypeORM entity"
list_files "*.prisma" "Prisma schema"

# 2. Check for specific database frameworks
echo "=== Database Frameworks Detection ==="

if [ -d "$ROOT_DIR/db/migrate" ]; then
    echo "Detected Ruby on Rails migrations in db/migrate/"
fi

if [ -f "$ROOT_DIR/db/schema.rb" ]; then
    echo "Detected Ruby on Rails schema.rb"
fi

if [ -f "$ROOT_DIR/manage.py" ] && [ -d "$ROOT_DIR/migrations" ]; then
    echo "Detected Django with migrations"
fi

if [ -f "$ROOT_DIR/prisma/schema.prisma" ]; then
    echo "Detected Prisma ORM"
fi

if [ -f "$ROOT_DIR/package.json" ]; then
    if grep -q "sequelize" "$ROOT_DIR/package.json"; then
        echo "Detected Sequelize ORM (Node.js)"
    fi
    if grep -q "typeorm" "$ROOT_DIR/package.json"; then
        echo "Detected TypeORM (Node.js/TypeScript)"
    fi
    if grep -q "mongoose" "$ROOT_DIR/package.json"; then
        echo "Detected Mongoose (MongoDB ODM for Node.js)"
    fi
fi

if [ -f "$ROOT_DIR/pom.xml" ] || [ -f "$ROOT_DIR/build.gradle" ]; then
    if grep -q "hibernate\|spring-data\|javax.persistence" "$ROOT_DIR/pom.xml" 2>/dev/null || 
       grep -q "hibernate\|spring-data\|javax.persistence" "$ROOT_DIR/build.gradle" 2>/dev/null; then
        echo "Detected Hibernate/JPA (Java)"
    fi
fi

echo ""

# 3. Perform detailed analysis
analyze_db_config
analyze_sql_files
analyze_rails_schema
analyze_django_models
analyze_sequelize_models
analyze_prisma_schema
analyze_typeorm_entities
analyze_java_entities
analyze_mongoose_schemas

echo "=== Database Schema Analysis Complete ==="
echo "Note: This script provides a high-level overview of database schemas."
echo "For more detailed analysis, consider using database-specific tools."