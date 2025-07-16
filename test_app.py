#!/usr/bin/env python3
"""
Tests for the Host Header API

This module contains unit tests for the Host Header API endpoints.
"""

import unittest
from app import app

class TestHostHeaderAPI(unittest.TestCase):
    """Test cases for the Host Header API."""

    def setUp(self):
        """Set up the test client before each test."""
        self.app = app.test_client()
        self.app.testing = True

    def test_host_header_endpoint(self):
        """Test the /host-header endpoint returns the correct host header."""
        # Make a request with a custom host header
        response = self.app.get('/host-header', headers={'Host': 'test.example.com'})
        
        # Check if the response is successful
        self.assertEqual(response.status_code, 200)
        
        # Parse the JSON response
        data = response.get_json()
        
        # Check if the host header is correctly extracted
        self.assertEqual(data['host_header'], 'test.example.com')
        
        # Check if the description field is present
        self.assertIn('description', data)

    def test_index_endpoint(self):
        """Test the root (/) endpoint returns correct information."""
        # Make a request with a custom host header
        response = self.app.get('/', headers={'Host': 'api.example.org'})
        
        # Check if the response is successful
        self.assertEqual(response.status_code, 200)
        
        # Parse the JSON response
        data = response.get_json()
        
        # Check if the API information is present
        self.assertIn('api_name', data)
        self.assertIn('endpoints', data)
        
        # Check if the current host is correctly extracted
        self.assertEqual(data['current_host'], 'api.example.org')

if __name__ == '__main__':
    unittest.main()