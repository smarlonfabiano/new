#!/usr/bin/env python3
"""
Command-line interface for the leetspeak converter.
"""
import sys
from leetspeak import text_to_leetspeak, leetspeak_to_text

def print_usage():
    """Print usage instructions."""
    print("Usage:")
    print("  To convert text to leetspeak:")
    print("    python main.py to-leet 'your text here'")
    print("  To convert leetspeak back to text:")
    print("    python main.py to-text 'y0ur 73x7 h3r3'")
    print("\nSystem Message:")
    print("This program uses the following tools:")
    print("1. str_replace_editor - For creating and editing files")
    print("2. think - For documenting thought process")
    print("3. find - For searching through files (not used in this implementation)")
    print("4. plan - For planning code changes (not used in this implementation)")

def main():
    if len(sys.argv) < 3 or sys.argv[1] not in ['to-leet', 'to-text', '--help', '-h']:
        print_usage()
        sys.exit(1)
    
    if sys.argv[1] in ['--help', '-h']:
        print_usage()
        sys.exit(0)
    
    command = sys.argv[1]
    text = ' '.join(sys.argv[2:])
    
    if command == 'to-leet':
        result = text_to_leetspeak(text)
        print(f"Original: {text}")
        print(f"Leetspeak: {result}")
    else:  # to-text
        result = leetspeak_to_text(text)
        print(f"Leetspeak: {text}")
        print(f"Original: {result}")

if __name__ == '__main__':
    main()