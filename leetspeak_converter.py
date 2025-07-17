#!/usr/bin/env python3
"""
Leetspeak Converter

This module provides functions to convert text to leetspeak and back.
"""
import sys
from system_prompt import print_system_prompt

def text_to_leetspeak(text):
    """
    Convert normal text to leetspeak.
    
    Args:
        text (str): The text to convert
        
    Returns:
        str: The text converted to leetspeak
    """
    leet_map = {
        'a': '4',
        'b': '8',
        'e': '3',
        'g': '6',
        'i': '1',
        'l': '1',
        'o': '0',
        's': '5',
        't': '7',
        'z': '2'
    }
    
    result = ""
    for char in text:
        lower_char = char.lower()
        if lower_char in leet_map:
            result += leet_map[lower_char]
        else:
            result += char
    
    return result

def leetspeak_to_text(leetspeak):
    """
    Convert leetspeak back to normal text.
    
    Args:
        leetspeak (str): The leetspeak text to convert
        
    Returns:
        str: The text converted back from leetspeak
    """
    # Create reverse mapping
    leet_map = {
        '4': 'a',
        '8': 'b',
        '3': 'e',
        '6': 'g',
        '1': 'i',  # Note: This is ambiguous (could be 'i' or 'l')
        '0': 'o',
        '5': 's',
        '7': 't',
        '2': 'z'
    }
    
    result = ""
    for char in leetspeak:
        if char in leet_map:
            result += leet_map[char]
        else:
            result += char
    
    return result