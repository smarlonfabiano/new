"""
Unit tests for the data_processor module.
"""

import unittest
from src.data_processor import DataProcessor

class TestDataProcessor(unittest.TestCase):
    """Test cases for the DataProcessor class."""
    
    def setUp(self):
        """Set up test fixtures."""
        self.empty_processor = DataProcessor()
        self.numeric_processor = DataProcessor([1, 2, 3, 4, 5])
        self.mixed_processor = DataProcessor([1, 'a', 2, 'b', 3])
    
    def test_init(self):
        """Test the initialization of DataProcessor."""
        self.assertEqual(self.empty_processor.data, [])
        self.assertEqual(self.numeric_processor.data, [1, 2, 3, 4, 5])
    
    def test_add_item(self):
        """Test the add_item method."""
        self.empty_processor.add_item(1)
        self.assertEqual(self.empty_processor.data, [1])
        
        self.numeric_processor.add_item(6)
        self.assertEqual(self.numeric_processor.data, [1, 2, 3, 4, 5, 6])
    
    def test_remove_item(self):
        """Test the remove_item method."""
        self.numeric_processor.remove_item(3)
        self.assertEqual(self.numeric_processor.data, [1, 2, 4, 5])
    
    def test_remove_nonexistent_item(self):
        """Test removing a nonexistent item raises an exception."""
        with self.assertRaises(ValueError):
            self.numeric_processor.remove_item(10)
    
    def test_get_average(self):
        """Test the get_average method."""
        self.assertEqual(self.numeric_processor.get_average(), 3.0)
        
        processor = DataProcessor([10, 20, 30])
        self.assertEqual(processor.get_average(), 20.0)
    
    def test_get_average_empty(self):
        """Test get_average with empty data raises an exception."""
        with self.assertRaises(ValueError):
            self.empty_processor.get_average()
    
    def test_get_average_non_numeric(self):
        """Test get_average with non-numeric data raises an exception."""
        with self.assertRaises(ValueError):
            self.mixed_processor.get_average()
    
    def test_filter_data(self):
        """Test the filter_data method."""
        result = self.numeric_processor.filter_data(lambda x: x > 3)
        self.assertEqual(result, [4, 5])
        
        result = self.mixed_processor.filter_data(lambda x: isinstance(x, int))
        self.assertEqual(result, [1, 2, 3])
    
    def test_transform_data(self):
        """Test the transform_data method."""
        result = self.numeric_processor.transform_data(lambda x: x * 2)
        self.assertEqual(result, [2, 4, 6, 8, 10])


if __name__ == '__main__':
    unittest.main()