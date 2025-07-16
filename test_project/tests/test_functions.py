#!/usr/bin/env python3
"""
Test file for the functions in the src directory.
"""

import unittest
import sys
import os

# Add the src directory to the path so we can import the modules
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../src')))

from long_functions import calculate_average, is_prime
from duplicate_functions import find_max, process_data

class TestFunctions(unittest.TestCase):
    """Test case for the functions in the src directory."""
    
    def test_calculate_average(self):
        """Test the calculate_average function."""
        self.assertEqual(calculate_average([1, 2, 3, 4, 5]), 3)
        self.assertEqual(calculate_average([]), 0)
        self.assertEqual(calculate_average([10]), 10)
    
    def test_is_prime(self):
        """Test the is_prime function."""
        self.assertTrue(is_prime(2))
        self.assertTrue(is_prime(3))
        self.assertTrue(is_prime(5))
        self.assertTrue(is_prime(7))
        self.assertTrue(is_prime(11))
        self.assertTrue(is_prime(13))
        self.assertFalse(is_prime(1))
        self.assertFalse(is_prime(4))
        self.assertFalse(is_prime(6))
        self.assertFalse(is_prime(8))
        self.assertFalse(is_prime(9))
        self.assertFalse(is_prime(10))
    
    def test_find_max(self):
        """Test the find_max function."""
        self.assertEqual(find_max([1, 2, 3, 4, 5]), 5)
        self.assertEqual(find_max([5, 4, 3, 2, 1]), 5)
        self.assertEqual(find_max([1]), 1)
        self.assertIsNone(find_max([]))
    
    def test_process_data(self):
        """Test the process_data function."""
        data = [1, 2, 3, 4, 5]
        result = process_data(data)
        self.assertEqual(result["count"], 5)
        self.assertEqual(result["average"], 3)
        self.assertEqual(result["max"], 5)
        self.assertEqual(result["min"], 1)
        
        # Test with empty data
        result = process_data([])
        self.assertEqual(result["count"], 0)
        self.assertEqual(result["average"], 0)
        self.assertIsNone(result["max"])
        self.assertIsNone(result["min"])

if __name__ == "__main__":
    unittest.main()