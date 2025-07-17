"""
Leetspeak converter module for text transformation
"""

class LeetspeakConverter:
    LEET_DICT = {
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
    
    REVERSE_DICT = {v: k for k, v in LEET_DICT.items()}
    
    @classmethod
    def to_leetspeak(cls, text):
        """Convert normal text to leetspeak"""
        if not isinstance(text, str):
            raise TypeError("Input must be a string")
            
        result = text.lower()
        for char, leet in cls.LEET_DICT.items():
            result = result.replace(char, leet)
        return result
    
    @classmethod
    def from_leetspeak(cls, text):
        """Convert leetspeak back to normal text"""
        if not isinstance(text, str):
            raise TypeError("Input must be a string")
            
        result = text
        for leet, char in cls.REVERSE_DICT.items():
            result = result.replace(leet, char)
        return result