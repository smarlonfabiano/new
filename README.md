# Business Logic Analyzer

This repository contains a bash script that analyzes codebases to identify business logic rules, validation patterns, and data processing workflows.

## Overview

The Business Logic Analyzer is a tool designed to scan codebases and identify:

1. **Business Logic Rules**: Core rules and processes that define how an application operates, including conditional statements, functions, and classes that implement specific business requirements.

2. **Validation Patterns**: Code that ensures data integrity and enforces constraints on inputs and outputs, including input validation, error handling, and data consistency checks.

3. **Data Processing Workflows**: Code that handles the transformation, storage, and retrieval of data, including database operations, API calls, and data transformation logic.

## Files in this Repository

- `business_logic_analyzer.sh`: The main analysis script
- `sample_code.py`: A sample Python file demonstrating various business logic patterns
- `run_analysis.sh`: A helper script to run the analyzer
- `README.md`: This documentation file

## How to Use

1. Make the scripts executable:
   ```bash
   chmod +x business_logic_analyzer.sh run_analysis.sh
   ```

2. Run the analyzer on a specific directory:
   ```bash
   ./business_logic_analyzer.sh /path/to/codebase
   ```

   Or use the helper script to analyze the current directory:
   ```bash
   ./run_analysis.sh
   ```

## Features

- **Multi-language Support**: Analyzes code in Python, JavaScript, Java, Ruby, PHP, and more
- **Pattern Recognition**: Identifies common patterns associated with business logic, validation, and data processing
- **Detailed Reporting**: Provides a comprehensive report with findings and insights
- **Code Distribution Analysis**: Shows the distribution of different code concerns in your codebase

## Example Output

The analyzer generates a report that includes:

- Count and examples of business logic rules found
- Count and examples of validation patterns found
- Count and examples of data processing workflows found
- Analysis of code distribution
- Insights and recommendations based on findings

## Limitations

- The analyzer uses pattern matching and may not catch all business logic implementations
- Complex or non-standard coding patterns might not be recognized
- The tool is designed for analysis and does not modify any code