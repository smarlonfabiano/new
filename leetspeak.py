"""
Leetspeak Converter Module

This module provides functionality to convert regular text to leetspeak.
Leetspeak is a form of internet slang where standard letters are replaced
with numbers or special characters.
"""

def text_to_leetspeak(text):
    """
    Convert regular text to leetspeak.
    
    Args:
        text (str): The input text to convert
        
    Returns:
        str: The converted leetspeak text
    """
    # Define leetspeak character mappings
    leet_dict = {
        'a': '4',
        'b': '8',
        'c': 'c',  # Sometimes 'c' is replaced with '(' or '<'
        'd': 'd',  # Sometimes 'd' is replaced with '|)'
        'e': '3',
        'f': 'f',  # Sometimes 'f' is replaced with 'ph'
        'g': '6',
        'h': 'h',  # Sometimes 'h' is replaced with '|-|'
        'i': '1',
        'j': 'j',
        'k': 'k',  # Sometimes 'k' is replaced with '|<'
        'l': '1',
        'm': 'm',  # Sometimes 'm' is replaced with '|v|'
        'n': 'n',  # Sometimes 'n' is replaced with '|\|'
        'o': '0',
        'p': 'p',
        'q': 'q',
        'r': 'r',  # Sometimes 'r' is replaced with '|2'
        's': '5',
        't': '7',
        'u': 'u',  # Sometimes 'u' is replaced with '|_|'
        'v': 'v',
        'w': 'w',  # Sometimes 'w' is replaced with '\/\/'
        'x': 'x',  # Sometimes 'x' is replaced with '><'
        'y': 'y',  # Sometimes 'y' is replaced with '`/'
        'z': '2',
        'A': '4',
        'B': '8',
        'C': 'C',
        'D': 'D',
        'E': '3',
        'F': 'F',
        'G': '6',
        'H': 'H',
        'I': '1',
        'J': 'J',
        'K': 'K',
        'L': '1',
        'M': 'M',
        'N': 'N',
        'O': '0',
        'P': 'P',
        'Q': 'Q',
        'R': 'R',
        'S': '5',
        'T': '7',
        'U': 'U',
        'V': 'V',
        'W': 'W',
        'X': 'X',
        'Y': 'Y',
        'Z': '2'
    }
    
    # Convert each character to its leetspeak equivalent if available
    result = ""
    for char in text:
        result += leet_dict.get(char, char)
    
    return result