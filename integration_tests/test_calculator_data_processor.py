"""
Integration tests for the calculator and data_processor modules.
"""

import unittest
from src.calculator import Calculator
from src.data_processor import DataProcessor

class TestCalculatorDataProcessor(unittest.TestCase):
    """Integration tests for Calculator and DataProcessor."""
    
    def setUp(self):
        """Set up test fixtures."""
        self.calc = Calculator()
        self.processor = DataProcessor()
    
    def test_process_calculations(self):
        """Test processing a series of calculations."""
        # Perform calculations and add results to the processor
        self.processor.add_item(self.calc.add(5, 3))
        self.processor.add_item(self.calc.subtract(10, 4))
        self.processor.add_item(self.calc.multiply(2, 3))
        self.processor.add_item(self.calc.divide(10, 2))
        
        # Check the collected results
        self.assertEqual(self.processor.data, [8, 6, 6, 5])
        
        # Calculate the average of the results
        avg = self.processor.get_average()
        self.assertEqual(avg, 6.25)
    
    def test_filter_and_transform(self):
        """Test filtering and transforming calculation results."""
        # Add some calculation results
        self.processor.add_item(self.calc.add(1, 1))  # 2
        self.processor.add_item(self.calc.add(2, 2))  # 4
        self.processor.add_item(self.calc.add(3, 3))  # 6
        self.processor.add_item(self.calc.add(4, 4))  # 8
        self.processor.add_item(self.calc.add(5, 5))  # 10
        
        # Filter for even numbers greater than 5
        filtered = self.processor.filter_data(lambda x: x > 5 and x % 2 == 0)
        self.assertEqual(filtered, [6, 8, 10])
        
        # Transform the filtered results by squaring them
        transformed = self.processor.transform_data(lambda x: self.calc.power(x, 2))
        self.assertEqual(transformed, [4, 16, 36, 64, 100])
    
    def test_complex_workflow(self):
        """Test a more complex workflow combining multiple operations."""
        # Generate some data
        numbers = [1, 2, 3, 4, 5]
        
        # Square each number using the calculator
        squared = [self.calc.power(n, 2) for n in numbers]
        
        # Create a processor with the squared values
        processor = DataProcessor(squared)
        
        # Filter for values greater than 10
        filtered = processor.filter_data(lambda x: x > 10)
        self.assertEqual(filtered, [16, 25])
        
        # Calculate the average of the filtered values
        filtered_processor = DataProcessor(filtered)
        avg = filtered_processor.get_average()
        self.assertEqual(avg, 20.5)
        
        # Add the average to the original processor
        processor.add_item(avg)
        
        # Check the final data
        self.assertEqual(processor.data, [1, 4, 9, 16, 25, 20.5])


if __name__ == '__main__':
    unittest.main()