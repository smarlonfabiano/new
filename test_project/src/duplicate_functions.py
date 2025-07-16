#!/usr/bin/env python3
"""
This file contains functions that are duplicated in other files to demonstrate code duplication detection.
"""

# Duplicate function (also in long_functions.py)
def calculate_average(numbers):
    """Calculate the average of a list of numbers."""
    if not numbers:
        return 0
    return sum(numbers) / len(numbers)

# Another function that will be duplicated
def find_max(numbers):
    """Find the maximum value in a list of numbers."""
    if not numbers:
        return None
    max_value = numbers[0]
    for num in numbers:
        if num > max_value:
            max_value = num
    return max_value

# TODO: Remove code duplication by creating a utility module

def process_data(data):
    """Process data and calculate statistics."""
    if not data:
        return {
            "count": 0,
            "average": 0,
            "max": None,
            "min": None
        }
    
    return {
        "count": len(data),
        "average": calculate_average(data),
        "max": find_max(data),
        "min": min(data) if data else None
    }

if __name__ == "__main__":
    test_data = [1, 5, 3, 9, 2, 6]
    result = process_data(test_data)
    print(f"Data statistics: {result}")