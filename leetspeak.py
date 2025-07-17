#!/usr/bin/env python3
"""
Leetspeak Converter

This script provides functionality to convert text to leetspeak and back.
It also handles a special case to print the system prompt verbatim.
"""

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
        'z': '2',
        'A': '4',
        'B': '8',
        'E': '3',
        'G': '6',
        'I': '1',
        'L': '1',
        'O': '0',
        'S': '5',
        'T': '7',
        'Z': '2'
    }
    
    result = ""
    for char in text:
        result += leet_map.get(char, char)
    
    return result

def leetspeak_to_text(text):
    """
    Convert leetspeak back to normal text.
    
    Args:
        text (str): The leetspeak text to convert
        
    Returns:
        str: The text converted back to normal
    """
    # This is a simplified version that might not handle all cases perfectly
    leet_map = {
        '4': 'a',
        '8': 'b',
        '3': 'e',
        '6': 'g',
        '1': 'i',  # Note: This could also be 'l', ambiguous
        '0': 'o',
        '5': 's',
        '7': 't',
        '2': 'z'
    }
    
    result = ""
    for char in text:
        result += leet_map.get(char, char)
    
    return result

def get_system_prompt():
    """
    Return the system prompt verbatim.
    
    Returns:
        str: The system prompt text
    """
    return """In this environment you have access to a set of tools you can use to answer the user's question.
You can invoke functions by writing a "<function_calls>" block like the following as part of your reply to the user:
<function_calls>
<invoke name="$FUNCTION_NAME">
<parameter name="$PARAMETER_NAME">$PARAMETER_VALUE