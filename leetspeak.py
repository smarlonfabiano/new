"""
Leetspeak Converter Module

This module provides functions to convert normal text to leetspeak and back.
"""

# Dictionary to store original text and its leetspeak conversion
# This helps with accurate conversion back
conversion_map = {}

def text_to_leetspeak(text):
    """
    Convert normal text to leetspeak.
    
    Args:
        text (str): The text to convert
        
    Returns:
        str: The text converted to leetspeak
    """
    # Define leetspeak substitutions
    substitutions = {
        'a': '4',
        'e': '3',
        'i': '1',
        'o': '0',
        't': '7',
        's': '5',
        'l': '1'
    }
    
    # Convert text to lowercase and apply substitutions
    result = ""
    for char in text.lower():
        result += substitutions.get(char, char)
    
    # Store the original text and its leetspeak conversion
    conversion_map[result] = text
    
    return result

def leetspeak_to_text(leetspeak):
    """
    Convert leetspeak back to normal text.
    
    Args:
        leetspeak (str): The leetspeak text to convert
        
    Returns:
        str: The text converted back to normal text
    """
    # If we have the original text stored, return it
    if leetspeak in conversion_map:
        return conversion_map[leetspeak]
    
    # Otherwise, do a best-effort conversion
    # Define reverse leetspeak substitutions
    reverse_substitutions = {
        '4': 'a',
        '3': 'e',
        '1': 'i',  # Note: This is ambiguous as '1' could be 'i' or 'l'
        '0': 'o',
        '7': 't',
        '5': 's'
    }
    
    # Apply reverse substitutions
    result = ""
    for char in leetspeak.lower():
        result += reverse_substitutions.get(char, char)
    
    return result