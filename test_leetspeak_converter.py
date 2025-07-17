#!/usr/bin/env python3
"""
Unit tests for the Leetspeak Converter.
"""
import unittest
from leetspeak_converter import text_to_leetspeak, leetspeak_to_text

class TestLeetspeakConverter(unittest.TestCase):
    """
    Test cases for the Leetspeak Converter.
    """
    
    def test_text_to_leetspeak(self):
        """
        Test converting text to leetspeak.
        """
        test_cases = [
            ("hello", "h3110"),
            ("HELLO", "H3110"),
            ("Hello World", "H3110 W0r1d"),
            ("abcdefghijklmnopqrstuvwxyz", "48cd3f6h1jk1mn0pqr57uvwxy2"),
            ("1234567890", "1234567890"),
            ("!@#$%^&*()", "!@#$%^&*()"),
            ("", "")
        ]
        
        for text, expected in test_cases:
            with self.subTest(text=text):
                self.assertEqual(text_to_leetspeak(text), expected)
    
    def test_leetspeak_to_text(self):
        """
        Test converting leetspeak back to normal text.
        """
        test_cases = [
            ("h3110", "hello"),
            ("H3110", "Hello"),
            ("H3110 W0r1d", "Hello World"),
            ("48cd3f6h1jk1mn0pqr57uvwxy2", "abcdefghijkimnopqrstuvwxyz"),
            ("1234567890", "i234567890"),
            ("!@#$%^&*()", "!@#$%^&*()"),
            ("", "")
        ]
        
        for leetspeak, expected in test_cases:
            with self.subTest(leetspeak=leetspeak):
                self.assertEqual(leetspeak_to_text(leetspeak), expected)
    
    def test_roundtrip(self):
        """
        Test converting text to leetspeak and back.
        Note: This won't always match the original text due to ambiguities
        (e.g., both 'i' and 'l' convert to '1').
        """
        test_cases = [
            "hello",
            "world",
            "python",
            "testing",
            "123",
            "!@#"
        ]
        
        for text in test_cases:
            with self.subTest(text=text):
                leetspeak = text_to_leetspeak(text)
                back_to_text = leetspeak_to_text(leetspeak)
                # We can't always expect exact matches due to ambiguities
                # but we can check that the length is the same
                self.assertEqual(len(text), len(back_to_text))

if __name__ == '__main__':
    unittest.main()