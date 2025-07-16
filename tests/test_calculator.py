"""
Unit tests for the calculator module.
"""

import unittest
from src.calculator import Calculator, is_prime

class TestCalculator(unittest.TestCase):
    """Test cases for the Calculator class."""
    
    def setUp(self):
        """Set up test fixtures."""
        self.calc = Calculator()
    
    def test_add(self):
        """Test the add method."""
        self.assertEqual(self.calc.add(1, 2), 3)
        self.assertEqual(self.calc.add(-1, 1), 0)
        self.assertEqual(self.calc.add(-1, -1), -2)
    
    def test_subtract(self):
        """Test the subtract method."""
        self.assertEqual(self.calc.subtract(3, 2), 1)
        self.assertEqual(self.calc.subtract(1, 1), 0)
        self.assertEqual(self.calc.subtract(-1, -1), 0)
    
    def test_multiply(self):
        """Test the multiply method."""
        self.assertEqual(self.calc.multiply(2, 3), 6)
        self.assertEqual(self.calc.multiply(0, 5), 0)
        self.assertEqual(self.calc.multiply(-2, 3), -6)
    
    def test_divide(self):
        """Test the divide method."""
        self.assertEqual(self.calc.divide(6, 3), 2)
        self.assertEqual(self.calc.divide(5, 2), 2.5)
        self.assertEqual(self.calc.divide(-6, 3), -2)
        
    def test_divide_by_zero(self):
        """Test division by zero raises an exception."""
        with self.assertRaises(ZeroDivisionError):
            self.calc.divide(5, 0)
    
    def test_power(self):
        """Test the power method."""
        self.assertEqual(self.calc.power(2, 3), 8)
        self.assertEqual(self.calc.power(5, 0), 1)
        self.assertEqual(self.calc.power(2, -1), 0.5)


class TestIsPrime(unittest.TestCase):
    """Test cases for the is_prime function."""
    
    def test_is_prime_with_primes(self):
        """Test is_prime with prime numbers."""
        primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
        for prime in primes:
            with self.subTest(prime=prime):
                self.assertTrue(is_prime(prime))
    
    def test_is_prime_with_non_primes(self):
        """Test is_prime with non-prime numbers."""
        non_primes = [0, 1, 4, 6, 8, 9, 10, 12, 14, 15]
        for non_prime in non_primes:
            with self.subTest(non_prime=non_prime):
                self.assertFalse(is_prime(non_prime))


if __name__ == '__main__':
    unittest.main()