# Database Schema Analysis Tool - Usage Guide

## Overview

This repository contains a comprehensive tool for analyzing database schemas, relationships, and data models in a software system. The main script (`analyze_db_schema.sh`) scans a codebase for database-related files and extracts schema information, providing insights into the database structure.

## Files in this Repository

- `analyze_db_schema.sh`: The main script for analyzing database schemas
- `test_db_schema.sh`: Script to create test database files and run the analysis
- `test_analyze_db_schema.sh`: Unit tests for the analysis script
- `example_schema.sql`: Example SQL schema file for demonstration
- `models.py`: Example Django ORM models for demonstration
- `run_analysis.sh`: Wrapper script to run the analysis and save results
- `README.md`: Documentation about the tool and its features
- `USAGE.md`: This file, with detailed usage instructions

## How to Use

### Basic Usage

1. Make the script executable:
   ```bash
   chmod +x analyze_db_schema.sh
   ```

2. Run the script on a directory:
   ```bash
   ./analyze_db_schema.sh /path/to/project
   ```

   Or run it on the current directory:
   ```bash
   ./analyze_db_schema.sh
   ```

### Using the Wrapper Script

For convenience, you can use the wrapper script which runs the analysis and saves the results to a file:

1. Make the wrapper script executable:
   ```bash
   chmod +x run_analysis.sh
   ```

2. Run the wrapper script:
   ```bash
   ./run_analysis.sh
   ```

3. Check the results in `analysis_results.txt`

### Running Tests

To verify that the script works correctly, you can run the test scripts:

1. Make the test scripts executable:
   ```bash
   chmod +x test_db_schema.sh
   chmod +x test_analyze_db_schema.sh
   ```

2. Run the test script that creates sample database files:
   ```bash
   ./test_db_schema.sh
   ```

3. Run the unit tests:
   ```bash
   ./test_analyze_db_schema.sh
   ```

## Example Output

The script provides output in the following format:

```
=== Database Files Overview ===
Found 1 SQL files:
/path/to/example_schema.sql

=== Database Frameworks Detection ===
Detected Django with migrations

=== SQL Schema Analysis ===
Analyzing /path/to/example_schema.sql...
  Tables defined:
    CREATE TABLE users (
    CREATE TABLE posts (
    ...
  Foreign key relationships:
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    ...
  Indexes:
    CREATE INDEX idx_users_email ON users(email);
    ...

=== Django ORM Models Analysis ===
Analyzing /path/to/models.py...
  Models defined:
    class User(AbstractUser):
    class Category(models.Model):
    ...
  Fields and relationships:
    bio = models.TextField(blank=True)
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name='posts')
    ...
```

## Customizing the Analysis

If you need to analyze specific types of database files or frameworks, you can modify the script to add additional detection and analysis functions. The script is structured in a modular way, with separate functions for each type of database technology.

## Troubleshooting

If the script doesn't detect your database files:

1. Check that the files have the expected extensions (`.sql`, `.py`, etc.)
2. Verify that the files contain the expected patterns (CREATE TABLE, models.Model, etc.)
3. Consider adding custom detection logic for your specific database technology

## Extending the Script

To add support for additional database technologies:

1. Create a new function in the script following the pattern of existing analysis functions
2. Add detection logic in the main execution flow
3. Call your new analysis function at the end of the script