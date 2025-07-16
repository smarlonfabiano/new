# Caching and Storage Analysis

This repository contains a bash script that demonstrates various caching strategies, data storage patterns, and memory management techniques commonly used in software development.

## Scripts

- `caching_storage_analysis.sh`: The main script that demonstrates caching strategies, data storage patterns, and memory management techniques
- `test_caching_storage_analysis.sh`: A test script to verify the functionality of the main script
- `make_executable.sh`: A utility script to make the other scripts executable

## Caching Strategies Demonstrated

1. **Memoization Cache**
   - Stores results of expensive function calls
   - Reuses stored results when the same inputs occur again
   - Example: Fibonacci calculation with caching

2. **LRU (Least Recently Used) Cache**
   - Tracks what was used when
   - Discards least recently used items first when cache is full
   - Prioritizes frequently accessed items

3. **Time-based Cache Expiration**
   - Stores data with a timestamp
   - Invalidates data after a certain period of time
   - Ensures data freshness

## Data Storage Patterns Demonstrated

1. **File-based Storage**
   - Persists data to the filesystem
   - Reliable storage between program executions
   - Simple key-value file storage

2. **In-memory Storage**
   - Keeps data in RAM for fast access
   - Temporary storage that's lost when program terminates
   - Fast but volatile

3. **Key-value Storage Pattern**
   - Stores and retrieves data using unique keys
   - Organizes data in collections
   - Foundation of many NoSQL databases

## Memory Management Techniques Demonstrated

1. **Garbage Collection Simulation**
   - Automatically frees memory that's no longer referenced
   - Tracks object references
   - Collects unreferenced objects

2. **Memory Allocation and Deallocation**
   - Explicit memory management
   - Simulates malloc/free or new/delete operations
   - Tracks memory usage

3. **Memory Usage Monitoring**
   - Monitors system and process memory usage
   - Detects potential memory leaks
   - Reports memory statistics

## Usage

1. Make the scripts executable:
   ```
   bash make_executable.sh
   ```

2. Run the main script:
   ```
   ./caching_storage_analysis.sh
   ```

3. Run the test script:
   ```
   ./test_caching_storage_analysis.sh
   ```

## Notes

- The script creates temporary files and directories in `/tmp/`
- Some features may not work on non-Linux systems (e.g., memory monitoring)
- This is for educational purposes to demonstrate various techniques