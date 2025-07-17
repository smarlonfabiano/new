"""
Tests for the leetspeak converter module.
"""

import unittest
from leetspeak import text_to_leetspeak

class TestLeetspeakConverter(unittest.TestCase):
    """Test cases for the leetspeak converter."""
    
    def test_basic_conversion(self):
        """Test basic text conversion to leetspeak."""
        input_text = "hello world"
        expected = "h3110 w0r1d"
        self.assertEqual(text_to_leetspeak(input_text), expected)
    
    def test_mixed_case(self):
        """Test conversion with mixed case text."""
        input_text = "Hello World"
        expected = "H3110 W0r1d"
        self.assertEqual(text_to_leetspeak(input_text), expected)
    
    def test_numbers_and_symbols(self):
        """Test that numbers and symbols remain unchanged."""
        input_text = "hello123!@#"
        expected = "h3110123!@#"
        self.assertEqual(text_to_leetspeak(input_text), expected)
    
    def test_empty_string(self):
        """Test conversion of an empty string."""
        input_text = ""
        expected = ""
        self.assertEqual(text_to_leetspeak(input_text), expected)
    
    def test_all_convertible_chars(self):
        """Test all convertible characters."""
        input_text = "abegiostzABEGIOSTZ"
        expected = "48361057248361057Z"
        self.assertEqual(text_to_leetspeak(input_text), expected)
        
    def test_full_alphabet(self):
        """Test the full alphabet conversion."""
        input_text = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        expected = "48cd3f6h1jk1mn0pqr57uvwxy248CD3F6H1JK1MN0PQR57UVWXY2"
        self.assertEqual(text_to_leetspeak(input_text), expected)

if __name__ == "__main__":
    unittest.main()