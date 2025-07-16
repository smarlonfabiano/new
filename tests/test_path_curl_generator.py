#!/usr/bin/env python3
"""
Unit tests for the Path Curl Generator module
"""

import unittest
import json
from src.path_curl_generator import (
    normalize_url_path,
    combine_url_parts,
    generate_curl_command
)


class TestPathCurlGenerator(unittest.TestCase):
    """Test cases for the Path Curl Generator module"""
    
    def test_normalize_url_path(self):
        """Test the normalize_url_path function"""
        # Test empty path
        self.assertEqual(normalize_url_path(""), "/")
        
        # Test path without leading slash
        self.assertEqual(normalize_url_path("api/v1"), "/api/v1")
        
        # Test path with leading slash
        self.assertEqual(normalize_url_path("/api/v1"), "/api/v1")
        
        # Test path with trailing slash
        self.assertEqual(normalize_url_path("/api/v1/"), "/api/v1")
        
        # Test root path
        self.assertEqual(normalize_url_path("/"), "/")
    
    def test_combine_url_parts(self):
        """Test the combine_url_parts function"""
        # Test basic combination
        self.assertEqual(
            combine_url_parts("https://api.example.com", "/users"),
            "https://api.example.com/users"
        )
        
        # Test with trailing slash in base URL
        self.assertEqual(
            combine_url_parts("https://api.example.com/", "/users"),
            "https://api.example.com/users"
        )
        
        # Test without leading slash in path
        self.assertEqual(
            combine_url_parts("https://api.example.com", "users"),
            "https://api.example.com/users"
        )
        
        # Test with empty path
        self.assertEqual(
            combine_url_parts("https://api.example.com", ""),
            "https://api.example.com/"
        )
    
    def test_generate_curl_command_basic(self):
        """Test basic curl command generation"""
        result = generate_curl_command(
            base_url="https://api.example.com",
            path="/users"
        )
        
        # Check that the result contains the expected parts
        self.assertIn("curl -X GET", result)
        self.assertIn("'https://api.example.com/users'", result)
        self.assertIn("# Base URL: https://api.example.com", result)
        self.assertIn("# Path: /users", result)
    
    def test_generate_curl_command_with_headers(self):
        """Test curl command generation with headers"""
        headers = {
            "Authorization": "Bearer token123",
            "Content-Type": "application/json"
        }
        
        result = generate_curl_command(
            base_url="https://api.example.com",
            path="/users",
            headers=headers
        )
        
        # Check that the headers are included
        self.assertIn("-H 'Authorization: Bearer token123'", result)
        self.assertIn("-H 'Content-Type: application/json'", result)
    
    def test_generate_curl_command_with_data(self):
        """Test curl command generation with data"""
        data = {"name": "John Doe", "email": "john@example.com"}
        
        result = generate_curl_command(
            base_url="https://api.example.com",
            path="/users",
            method="POST",
            data=data
        )
        
        # Check that the data is included
        json_data = json.dumps(data)
        self.assertIn(f"-d '{json_data}'", result)
        self.assertIn("-X POST", result)
    
    def test_generate_curl_command_with_params(self):
        """Test curl command generation with query parameters"""
        params = {"page": "1", "limit": "10"}
        
        result = generate_curl_command(
            base_url="https://api.example.com",
            path="/users",
            params=params
        )
        
        # Check that the query parameters are included
        self.assertIn("'https://api.example.com/users?", result)
        self.assertIn("page=1", result)
        self.assertIn("limit=10", result)


if __name__ == "__main__":
    unittest.main()