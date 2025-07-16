#!/usr/bin/env python3
"""
Path Curl Generator

This module provides functionality to generate curl API calls and comment
the full request path including the base URL.
"""

import urllib.parse
import json
from typing import Dict, List, Optional, Union


def normalize_url_path(path: str) -> str:
    """
    Normalize a URL path by ensuring it starts with a forward slash
    and doesn't end with one (unless it's just a root path '/').
    
    Args:
        path: The URL path to normalize
        
    Returns:
        The normalized path
    """
    if not path:
        return "/"
    
    # Ensure path starts with /
    if not path.startswith('/'):
        path = '/' + path
    
    # Remove trailing slash if it's not just the root path
    if path != '/' and path.endswith('/'):
        path = path.rstrip('/')
    
    return path


def combine_url_parts(base_url: str, path: str = "") -> str:
    """
    Combine a base URL with a path, ensuring proper formatting.
    
    Args:
        base_url: The base URL (e.g., 'https://api.example.com')
        path: The path to append (e.g., '/v1/users')
        
    Returns:
        The combined URL
    """
    # Remove trailing slash from base_url if it exists
    base_url = base_url.rstrip('/')
    
    # Normalize the path
    path = normalize_url_path(path)
    
    # Combine the parts
    return base_url + path


def generate_curl_command(
    base_url: str,
    path: str = "",
    method: str = "GET",
    headers: Optional[Dict[str, str]] = None,
    data: Optional[Union[Dict, List, str]] = None,
    params: Optional[Dict[str, str]] = None
) -> str:
    """
    Generate a curl command for an API call with comments about the path.
    
    Args:
        base_url: The base URL for the API
        path: The specific endpoint path
        method: The HTTP method (GET, POST, PUT, DELETE, etc.)
        headers: Optional dictionary of headers
        data: Optional data to send (for POST, PUT, etc.)
        params: Optional query parameters
        
    Returns:
        A formatted curl command string with comments
    """
    # Normalize inputs
    if headers is None:
        headers = {}
    
    # Build the full URL
    full_url = combine_url_parts(base_url, path)
    
    # Add query parameters if provided
    if params:
        query_string = urllib.parse.urlencode(params)
        full_url = f"{full_url}?{query_string}"
    
    # Start building the curl command
    curl_parts = [f"curl -X {method}"]
    
    # Add headers
    for header_name, header_value in headers.items():
        curl_parts.append(f"-H '{header_name}: {header_value}'")
    
    # Add data if provided
    if data:
        if isinstance(data, (dict, list)):
            # Convert dict/list to JSON string
            json_data = json.dumps(data)
            headers['Content-Type'] = 'application/json'
            curl_parts.append(f"-H 'Content-Type: application/json'")
            curl_parts.append(f"-d '{json_data}'")
        else:
            # Assume it's already a string
            curl_parts.append(f"-d '{data}'")
    
    # Add the URL
    curl_parts.append(f"'{full_url}'")
    
    # Build the final command
    curl_command = " \\\n  ".join(curl_parts)
    
    # Add comments about the path
    comments = [
        "# Full request path breakdown:",
        f"# Base URL: {base_url}",
        f"# Path: {path}",
        f"# Complete URL: {full_url}"
    ]
    
    # Combine everything
    result = "\n".join(comments) + "\n\n" + curl_command
    
    return result


if __name__ == "__main__":
    # Example usage
    print(generate_curl_command(
        base_url="https://api.example.com",
        path="/v1/users",
        method="POST",
        headers={"Authorization": "Bearer token123"},
        data={"name": "John Doe", "email": "john@example.com"}
    ))