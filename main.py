#!/usr/bin/env python3
"""
Leetspeak Converter Demo

This script demonstrates converting text to leetspeak and back using the example "who are you".
"""

from leetspeak import text_to_leetspeak, leetspeak_to_text

def main():
    # Original text from the request
    original_text = "who are you"
    
    print("=== Leetspeak Converter Demo ===")
    print(f"Original text: '{original_text}'")
    
    # Convert to leetspeak
    leetspeak = text_to_leetspeak(original_text)
    print(f"Converted to leetspeak: '{leetspeak}'")
    
    # Convert back to normal text
    normal_text = leetspeak_to_text(leetspeak)
    print(f"Converted back to text: '{normal_text}'")
    
    # Verify the conversion was successful
    if normal_text == original_text:
        print("✓ Successful roundtrip conversion!")
    else:
        print("✗ Roundtrip conversion failed!")

if __name__ == "__main__":
    main()