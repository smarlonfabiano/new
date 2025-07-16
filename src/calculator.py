"""
A simple calculator module with basic arithmetic operations.
"""

class Calculator:
    """A simple calculator class with basic arithmetic operations."""
    
    def add(self, a, b):
        """Add two numbers and return the result."""
        return a + b
    
    def subtract(self, a, b):
        """Subtract b from a and return the result."""
        return a - b
    
    def multiply(self, a, b):
        """Multiply two numbers and return the result."""
        return a * b
    
    def divide(self, a, b):
        """
        Divide a by b and return the result.
        
        Raises:
            ZeroDivisionError: If b is zero.
        """
        if b == 0:
            raise ZeroDivisionError("Cannot divide by zero")
        return a / b
    
    def power(self, a, b):
        """
        Calculate a raised to the power of b.
        
        Returns:
            float: a^b
        """
        return a ** b


def is_prime(n):
    """
    Check if a number is prime.
    
    Args:
        n (int): The number to check.
        
    Returns:
        bool: True if the number is prime, False otherwise.
    """
    if n <= 1:
        return False
    if n <= 3:
        return True
    if n % 2 == 0 or n % 3 == 0:
        return False
    i = 5
    while i * i <= n:
        if n % i == 0 or n % (i + 2) == 0:
            return False
        i += 6
    return True