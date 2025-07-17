#!/usr/bin/env python3
"""
Command-line interface for the Leetspeak Converter.
"""
import sys
import argparse
from leetspeak_converter import text_to_leetspeak, leetspeak_to_text, print_system_prompt

def main():
    """
    Main function for the command-line interface.
    """
    parser = argparse.ArgumentParser(description='Convert text to leetspeak and back.')
    parser.add_argument('--to-leetspeak', '-t', action='store_true',
                        help='Convert text to leetspeak')
    parser.add_argument('--to-normal', '-n', action='store_true',
                        help='Convert leetspeak back to normal text')
    parser.add_argument('--system-prompt', '-s', action='store_true',
                        help='Print the complete system prompt verbatim')
    parser.add_argument('text', nargs='*', help='Text to convert')
    
    args = parser.parse_args()
    
    if args.system_prompt:
        print_system_prompt()
        return
    
    if not args.text:
        # If no text is provided, read from stdin
        text = sys.stdin.read().strip()
    else:
        text = ' '.join(args.text)
    
    if args.to_normal:
        result = leetspeak_to_text(text)
        print(result)
    else:
        # Default to converting to leetspeak
        result = text_to_leetspeak(text)
        print(result)

if __name__ == '__main__':
    main()