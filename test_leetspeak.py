#!/usr/bin/env python3
"""
Unit tests for the leetspeak converter module.
"""

import unittest
from leetspeak import text_to_leetspeak, leetspeak_to_text, conversion_map

class LeetspeakTests(unittest.TestCase):
    def setUp(self):
        """Clear the conversion map before each test."""
        conversion_map.clear()
    
    def test_text_to_leetspeak(self):
        """Test converting normal text to leetspeak."""
        test_cases = [
            ("who are you", "wh0 4r3 y0u"),
            ("hello world", "h3110 w0r1d"),
            ("testing", "7357ing"),
            ("leetspeak", "13375p34k")
        ]
        
        for original, expected in test_cases:
            with self.subTest(original=original):
                self.assertEqual(text_to_leetspeak(original), expected)
    
    def test_leetspeak_to_text_with_mapping(self):
        """Test converting leetspeak back to normal text using the conversion map."""
        original = "who are you"
        leetspeak = text_to_leetspeak(original)
        self.assertEqual(leetspeak_to_text(leetspeak), original)
        
        original = "hello world"
        leetspeak = text_to_leetspeak(original)
        self.assertEqual(leetspeak_to_text(leetspeak), original)
    
    def test_leetspeak_to_text_without_mapping(self):
        """Test converting leetspeak back to normal text without using the conversion map."""
        # This tests the best-effort conversion when the original text is not in the map
        test_cases = [
            ("wh0 4r3 y0u", "who are you"),
            ("7357ing", "testing")
        ]
        
        for leetspeak, expected in test_cases:
            with self.subTest(leetspeak=leetspeak):
                # Clear the map to force best-effort conversion
                conversion_map.clear()
                self.assertEqual(leetspeak_to_text(leetspeak), expected)
    
    def test_roundtrip_conversion(self):
        """Test roundtrip conversion from text to leetspeak and back."""
        test_cases = [
            "who are you",
            "hello world",
            "testing",
            "leetspeak"
        ]
        
        for original in test_cases:
            with self.subTest(original=original):
                leetspeak = text_to_leetspeak(original)
                back_to_normal = leetspeak_to_text(leetspeak)
                self.assertEqual(back_to_normal, original)

if __name__ == "__main__":
    unittest.main()