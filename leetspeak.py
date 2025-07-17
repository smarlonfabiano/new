"""
Leetspeak Converter Module

This module provides functions to convert normal text to leetspeak and back.
"""

# Mapping for text to leetspeak conversion
TEXT_TO_LEET = {
    'a': '4',
    'e': '3',
    'i': '1',
    'o': '0',
    's': '5',
    't': '7',
    'l': '1'
}

# Mapping for leetspeak to text conversion
# Note: This has ambiguity (e.g., '1' could be 'i' or 'l')
# We'll make a choice for each character
LEET_TO_TEXT = {
    '4': 'a',
    '3': 'e',
    '1': 'i',  # We choose 'i' over 'l' for '1'
    '0': 'o',
    '5': 's',
    '7': 't'
}

def text_to_leetspeak(text):
    """
    Convert normal text to leetspeak.
    
    Args:
        text (str): The input text to convert
        
    Returns:
        str: The text converted to leetspeak
    """
    result = ""
    for char in text:
        lower_char = char.lower()
        if lower_char in TEXT_TO_LEET:
            # Preserve case if possible
            if char.isupper():
                result += TEXT_TO_LEET[lower_char].upper()
            else:
                result += TEXT_TO_LEET[lower_char]
        else:
            result += char
    return result

def leetspeak_to_text(leetspeak):
    """
    Convert leetspeak back to normal text.
    
    Args:
        leetspeak (str): The leetspeak text to convert
        
    Returns:
        str: The leetspeak converted back to normal text
    """
    result = ""
    for char in leetspeak:
        lower_char = char.lower()
        if lower_char in LEET_TO_TEXT:
            # Preserve case if possible
            if char.isupper():
                result += LEET_TO_TEXT[lower_char].upper()
            else:
                result += LEET_TO_TEXT[lower_char]
        else:
            result += char
    return result