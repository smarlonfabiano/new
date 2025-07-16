#!/usr/bin/env python3
import json
import unittest
import os

class TestJSONPayload(unittest.TestCase):
    def test_json_format(self):
        """Test that the payload.json file exists and contains valid JSON."""
        # Check if file exists
        self.assertTrue(os.path.exists('payload.json'), "payload.json file does not exist")
        
        # Try to parse the JSON content (skipping comment lines)
        try:
            with open('payload.json', 'r') as f:
                content = f.read()
            
            # Skip comment lines that start with //
            json_content = '\n'.join([line for line in content.split('\n') if not line.strip().startswith('//')])
            parsed_json = json.loads(json_content)
            
            # Check if the parsed JSON has the expected structure
            self.assertIn('request', parsed_json, "JSON should contain a 'request' key")
            self.assertIn('metadata', parsed_json, "JSON should contain a 'metadata' key")
            
            # Check if the request contains required fields
            request = parsed_json['request']
            self.assertIn('model', request, "Request should specify a model")
            self.assertIn('messages', request, "Request should contain messages")
            
            # Check if there's a comment with AI provider details at the top
            with open('payload.json', 'r') as f:
                first_line = f.readline().strip()
            
            self.assertTrue(first_line.startswith('//'), "File should start with a comment")
            self.assertIn('AI Provider', first_line, "First comment should mention AI Provider")
            
        except json.JSONDecodeError as e:
            self.fail(f"Invalid JSON format: {e}")

if __name__ == '__main__':
    unittest.main()