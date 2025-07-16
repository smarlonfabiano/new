#!/usr/bin/env python3
"""
Unit tests for the webhook implementation.
"""

import json
import unittest
from unittest.mock import patch, MagicMock

from webhook import WebhookSender
from config import DEFAULT_WEBHOOK_URL

class TestWebhookSender(unittest.TestCase):
    """Test cases for the WebhookSender class."""
    
    def setUp(self):
        """Set up test fixtures."""
        self.webhook_url = DEFAULT_WEBHOOK_URL
        self.test_data = {"message": "Test webhook", "timestamp": 1234567890}
        
    @patch('webhook.requests.post')
    def test_send_success(self, mock_post):
        """Test successful webhook sending."""
        # Configure the mock
        mock_response = MagicMock()
        mock_response.status_code = 200
        mock_response.text = "Webhook received"
        mock_post.return_value = mock_response
        
        # Create webhook sender and send data
        sender = WebhookSender(webhook_url=self.webhook_url)
        response = sender.send(self.test_data)
        
        # Verify the mock was called correctly
        mock_post.assert_called_once()
        call_args = mock_post.call_args[1]
        self.assertEqual(call_args['headers']['Content-Type'], 'application/json')
        self.assertEqual(json.loads(call_args['data']), self.test_data)
        self.assertEqual(call_args['timeout'], 10)  # From config
        
        # Verify response
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.text, "Webhook received")
        
    @patch('webhook.requests.post')
    @patch('webhook.time.sleep')
    def test_retry_on_failure(self, mock_sleep, mock_post):
        """Test retry behavior on failure."""
        # Configure the mock to fail twice then succeed
        mock_error_response = MagicMock()
        mock_error_response.raise_for_status.side_effect = Exception("Server Error")
        
        mock_success_response = MagicMock()
        mock_success_response.status_code = 200
        
        mock_post.side_effect = [
            mock_error_response,  # First attempt fails
            mock_error_response,  # Second attempt fails
            mock_success_response  # Third attempt succeeds
        ]
        
        # Create webhook sender with 3 retries
        sender = WebhookSender(webhook_url=self.webhook_url, max_retries=3)
        response = sender.send(self.test_data)
        
        # Verify post was called 3 times
        self.assertEqual(mock_post.call_count, 3)
        
        # Verify sleep was called twice (after first and second failures)
        self.assertEqual(mock_sleep.call_count, 2)
        
        # Verify final response
        self.assertEqual(response.status_code, 200)
        
    @patch('webhook.requests.post')
    @patch('webhook.time.sleep')
    def test_max_retries_exceeded(self, mock_sleep, mock_post):
        """Test behavior when max retries are exceeded."""
        # Configure the mock to always fail
        mock_response = MagicMock()
        mock_response.raise_for_status.side_effect = Exception("Server Error")
        mock_post.return_value = mock_response
        
        # Create webhook sender with 3 retries
        sender = WebhookSender(webhook_url=self.webhook_url, max_retries=3)
        
        # Expect an exception when all retries fail
        with self.assertRaises(Exception):
            sender.send(self.test_data)
        
        # Verify post was called 3 times
        self.assertEqual(mock_post.call_count, 3)
        
        # Verify sleep was called twice (after first and second failures)
        self.assertEqual(mock_sleep.call_count, 2)
        
    @patch('webhook.requests.post')
    def test_string_payload(self, mock_post):
        """Test sending a string payload instead of JSON."""
        # Configure the mock
        mock_response = MagicMock()
        mock_response.status_code = 200
        mock_post.return_value = mock_response
        
        # Create webhook sender and send string data
        sender = WebhookSender(webhook_url=self.webhook_url)
        test_string = "Plain text message"
        sender.send(test_string)
        
        # Verify the mock was called with the string payload
        call_args = mock_post.call_args[1]
        self.assertEqual(call_args['data'], test_string)

if __name__ == '__main__':
    unittest.main()