"""
Unit tests for the leetspeak converter module.
"""
import unittest
from leetspeak import text_to_leetspeak, leetspeak_to_text

class TestLeetspeakConverter(unittest.TestCase):
    def test_text_to_leetspeak(self):
        test_cases = [
            ("hello", "h3110"),
            ("test", "7357"),
            ("HELLO", "H3110"),
            ("Test", "7357"),
            ("leetspeak", "13375p34k"),
            ("", ""),  # Empty string
            ("123", "123"),  # Numbers only
            ("!@#", "!@#"),  # Special characters
        ]
        
        for input_text, expected in test_cases:
            with self.subTest(input_text=input_text):
                result = text_to_leetspeak(input_text)
                self.assertEqual(result, expected)
    
    def test_leetspeak_to_text(self):
        test_cases = [
            ("h3110", "hello"),
            ("7357", "test"),
            ("H3110", "Hello"),
            ("13375p34k", "leetspeak"),
            ("", ""),  # Empty string
            ("123", "123"),  # Numbers that aren't leetspeak
            ("!@#", "!@#"),  # Special characters
        ]
        
        for input_text, expected in test_cases:
            with self.subTest(input_text=input_text):
                result = leetspeak_to_text(input_text)
                self.assertEqual(result, expected)

if __name__ == '__main__':
    unittest.main()