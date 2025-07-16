"""
A module for processing data with various operations.
"""

class DataProcessor:
    """A class for processing data with various operations."""
    
    def __init__(self, data=None):
        """
        Initialize the DataProcessor with optional data.
        
        Args:
            data (list, optional): Initial data to process. Defaults to None.
        """
        self.data = data if data is not None else []
    
    def add_item(self, item):
        """
        Add an item to the data.
        
        Args:
            item: The item to add.
        """
        self.data.append(item)
    
    def remove_item(self, item):
        """
        Remove an item from the data.
        
        Args:
            item: The item to remove.
            
        Raises:
            ValueError: If the item is not in the data.
        """
        if item in self.data:
            self.data.remove(item)
        else:
            raise ValueError(f"Item {item} not found in data")
    
    def get_average(self):
        """
        Calculate the average of numeric data.
        
        Returns:
            float: The average of the data.
            
        Raises:
            ValueError: If the data is empty or contains non-numeric values.
        """
        if not self.data:
            raise ValueError("Cannot calculate average of empty data")
        
        try:
            return sum(self.data) / len(self.data)
        except TypeError:
            raise ValueError("Data contains non-numeric values")
    
    def filter_data(self, condition):
        """
        Filter data based on a condition function.
        
        Args:
            condition (callable): A function that takes an item and returns a boolean.
            
        Returns:
            list: Filtered data.
        """
        return [item for item in self.data if condition(item)]
    
    def transform_data(self, transformation):
        """
        Transform data using a transformation function.
        
        Args:
            transformation (callable): A function that transforms each item.
            
        Returns:
            list: Transformed data.
        """
        return [transformation(item) for item in self.data]