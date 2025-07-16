# Database Schema Analysis Tool

This repository contains a bash script for analyzing database schemas, relationships, and data models in a software system.

## Overview

The database schema analyzer scans your project for:
- SQL schema files (`.sql`)
- ORM model files (Django and SQLAlchemy)
- Database migration files

It then generates a comprehensive report detailing:
- Tables defined in SQL files
- Foreign key relationships
- ORM models and their relationships
- Summary statistics of the database schema

## Repository Structure

```
.
├── analyze_db_schema.sh    # Main script for analyzing database schemas
├── test_schema_analyzer.sh # Test script to verify analyzer functionality
├── db/                     # Sample database files
│   ├── schema.sql          # SQL schema definition
│   ├── models.py           # SQLAlchemy ORM models
│   ├── django_models.py    # Django ORM models
│   └── migrations/         # Database migrations
│       └── 001_initial_schema.sql
└── README.md               # This file
```

## Sample Database Schema

The sample database schema represents an e-commerce system with the following entities:

- **Users**: Store user account information
- **Products**: Store product details
- **Categories**: Product categorization
- **Orders**: Customer orders
- **Order Items**: Individual items within orders
- **Product Categories**: Junction table for many-to-many relationship

## Usage

To analyze the database schema in your project:

```bash
# Make the script executable
chmod +x analyze_db_schema.sh

# Run the analyzer
./analyze_db_schema.sh
```

## Testing

To verify that the analyzer works correctly:

```bash
# Make the test script executable
chmod +x test_schema_analyzer.sh

# Run the tests
./test_schema_analyzer.sh
```

## Schema Design Analysis

The sample database schema demonstrates several best practices:

1. **Relational Model**: Proper use of foreign key constraints
2. **Many-to-Many Relationships**: Implemented using junction tables
3. **Audit Trails**: Timestamps for tracking creation and updates
4. **Indexing**: Foreign keys are indexed for query optimization
5. **ORM Support**: Compatible with both Django and SQLAlchemy
6. **Domain Modeling**: Represents a realistic e-commerce system

## Extending the Analyzer

To extend the analyzer for additional database technologies:

1. Add new pattern matching in the script for your specific database technology
2. Create sample files demonstrating the schema format
3. Update the test script to verify detection of the new format

## License

This project is available under the MIT License.