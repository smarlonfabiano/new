#!/usr/bin/env python3
"""
Unit tests for the API client.
"""

import unittest
from unittest.mock import patch, MagicMock
import json
import api_client

class TestAPIClient(unittest.TestCase):
    """Test cases for the API client."""
    
    @patch('api_client.requests.post')
    def test_execute_sql_query(self, mock_post):
        """Test the execute_sql_query function."""
        # Mock response
        mock_response = MagicMock()
        mock_response.json.return_value = {
            "results": [
                {"user_id": 1, "username": "user1", "email": "user1@example.com", "created_at": "2023-01-01T00:00:00Z"},
                {"user_id": 2, "username": "user2", "email": "user2@example.com", "created_at": "2023-01-02T00:00:00Z"}
            ]
        }
        mock_response.raise_for_status.return_value = None
        mock_post.return_value = mock_response
        
        # Test query
        query = "SELECT * FROM users"
        result = api_client.execute_sql_query(query)
        
        # Verify the API endpoint was called correctly
        mock_post.assert_called_once()
        args, kwargs = mock_post.call_args
        
        # Check that the API URL is correct (api.example.com with IP 192.168.1.100)
        self.assertEqual(args[0], "https://api.example.com/v1/execute-query")
        
        # Check that the query was sent in the payload
        self.assertEqual(kwargs['json']['query'], query)
        
        # Check that the result is as expected
        self.assertEqual(len(result['results']), 2)
        self.assertEqual(result['results'][0]['username'], "user1")
    
    @patch('api_client.execute_sql_query')
    def test_get_active_users(self, mock_execute_query):
        """Test the get_active_users function."""
        # Mock response
        mock_execute_query.return_value = {
            "results": [
                {"user_id": 1, "username": "user1", "email": "user1@example.com", "created_at": "2023-01-01T00:00:00Z"},
                {"user_id": 2, "username": "user2", "email": "user2@example.com", "created_at": "2023-01-02T00:00:00Z"}
            ]
        }
        
        # Call the function
        result = api_client.get_active_users()
        
        # Verify execute_sql_query was called with the correct SQL
        mock_execute_query.assert_called_once()
        args, _ = mock_execute_query.call_args
        sql = args[0].strip()
        
        # Check that the SQL contains the expected clauses
        self.assertIn("SELECT", sql)
        self.assertIn("FROM users", sql)
        self.assertIn("WHERE status = 'active'", sql)
        self.assertIn("ORDER BY created_at DESC", sql)
        
        # Check that the result is as expected
        self.assertEqual(len(result['results']), 2)

if __name__ == '__main__':
    unittest.main()