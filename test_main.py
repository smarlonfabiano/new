#!/usr/bin/env python3
"""
Test file for main.py
"""

import unittest
import json
from datetime import datetime
from main import example_api_usage, main

class TestMainFunctions(unittest.TestCase):
    """Test cases for functions in main.py"""
    
    def test_example_api_usage(self):
        """Test the example_api_usage function"""
        result = example_api_usage()
        
        # Check that the function returns a dictionary
        self.assertIsInstance(result, dict)
        
        # Check that the status is 'success'
        self.assertEqual(result['status'], 'success')
        
        # Check that timestamp is present and in ISO format
        self.assertIn('timestamp', result)
        # Verify it's a valid ISO format by parsing it
        try:
            datetime.fromisoformat(result['timestamp'])
            is_valid_iso = True
        except ValueError:
            is_valid_iso = False
        self.assertTrue(is_valid_iso)
    
    def test_main_function(self):
        """Test the main function (simple execution test)"""
        # This just tests that the main function runs without errors
        try:
            main()
            execution_successful = True
        except Exception:
            execution_successful = False
        
        self.assertTrue(execution_successful)

if __name__ == '__main__':
    unittest.main()