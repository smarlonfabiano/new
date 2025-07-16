# Database Schema Analysis Tool

This repository contains a bash script for analyzing database schemas, relationships, and data models in a software system.

## Overview

The `analyze_db_schema.sh` script is designed to scan a codebase and identify database-related files, extract schema information, and report on the database structure including tables, relationships, and data models.

## Features

- Detects and analyzes multiple database technologies:
  - SQL files (CREATE TABLE statements, foreign keys, indexes)
  - Ruby on Rails (schema.rb, migrations)
  - Django ORM (models.py)
  - Sequelize ORM (JavaScript/TypeScript)
  - Prisma Schema
  - TypeORM Entities
  - Hibernate/JPA Entities (Java)
  - MongoDB Mongoose Schemas

- Identifies:
  - Table/model definitions
  - Column/field definitions
  - Relationships between tables/models
  - Indexes and constraints
  - Database configuration files

## Usage

```bash
# Run on the current directory
bash analyze_db_schema.sh

# Run on a specific directory
bash analyze_db_schema.sh /path/to/project
```

## Testing

A test script is included to verify the functionality of the database schema analysis tool:

```bash
bash test_db_schema.sh
```

This will create a test directory structure with sample database files in various formats and run the analysis script on it.

## How It Works

The script performs the following steps:

1. **Database Files Overview**: Searches for common database-related files (SQL, SQLite, ORM models)
2. **Framework Detection**: Identifies database frameworks based on project structure and configuration files
3. **Detailed Analysis**:
   - Analyzes database configuration files
   - Parses SQL files for table definitions and relationships
   - Examines ORM model files to extract schema information
   - Identifies relationships between models/tables

## Supported Database Technologies

- SQL (generic SQL files)
- Ruby on Rails ActiveRecord
- Django ORM
- Sequelize ORM (Node.js)
- TypeORM (Node.js/TypeScript)
- Prisma (Node.js/TypeScript)
- Hibernate/JPA (Java)
- MongoDB with Mongoose (Node.js)

## Output

The script provides a structured output that includes:
- List of database-related files found
- Detected database frameworks
- Table/model definitions
- Column/field definitions
- Relationships between tables/models
- Indexes and constraints

## Limitations

- The script performs static analysis and may not capture dynamically generated schemas
- Complex or non-standard schema definitions might not be fully recognized
- For comprehensive database analysis, database-specific tools are recommended