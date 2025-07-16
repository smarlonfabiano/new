#!/usr/bin/env python3
"""
Command Line Interface for Path Curl Generator

This module provides a command-line interface for generating curl API calls
with commented path information.
"""

import argparse
import json
import sys
from typing import Dict, Optional

from .path_curl_generator import generate_curl_command


def parse_headers(headers_list: Optional[list]) -> Dict[str, str]:
    """
    Parse header arguments in the format "Name:Value"
    
    Args:
        headers_list: List of header strings in "Name:Value" format
        
    Returns:
        Dictionary of headers
    """
    if not headers_list:
        return {}
    
    headers = {}
    for header in headers_list:
        try:
            name, value = header.split(':', 1)
            headers[name.strip()] = value.strip()
        except ValueError:
            print(f"Warning: Ignoring invalid header format: {header}")
    
    return headers


def main():
    """Main entry point for the CLI"""
    parser = argparse.ArgumentParser(
        description="Generate curl API calls with commented path information"
    )
    
    parser.add_argument(
        "base_url",
        help="Base URL for the API (e.g., https://api.example.com)"
    )
    
    parser.add_argument(
        "path",
        nargs="?",
        default="",
        help="API endpoint path (e.g., /v1/users)"
    )
    
    parser.add_argument(
        "-X", "--method",
        default="GET",
        help="HTTP method (GET, POST, PUT, DELETE, etc.)"
    )
    
    parser.add_argument(
        "-H", "--header",
        action="append",
        help="HTTP header in format 'Name:Value' (can be used multiple times)"
    )
    
    parser.add_argument(
        "-d", "--data",
        help="Data to send (for POST, PUT, etc.)"
    )
    
    parser.add_argument(
        "-j", "--json",
        help="JSON data to send (for POST, PUT, etc.)"
    )
    
    parser.add_argument(
        "-p", "--param",
        action="append",
        help="URL parameter in format 'name=value' (can be used multiple times)"
    )
    
    args = parser.parse_args()
    
    # Process headers
    headers = parse_headers(args.header)
    
    # Process data
    data = None
    if args.data:
        data = args.data
    elif args.json:
        try:
            data = json.loads(args.json)
        except json.JSONDecodeError:
            print("Error: Invalid JSON data", file=sys.stderr)
            sys.exit(1)
    
    # Process URL parameters
    params = {}
    if args.param:
        for param in args.param:
            try:
                name, value = param.split('=', 1)
                params[name] = value
            except ValueError:
                print(f"Warning: Ignoring invalid parameter format: {param}")
    
    # Generate and print the curl command
    curl_command = generate_curl_command(
        base_url=args.base_url,
        path=args.path,
        method=args.method,
        headers=headers,
        data=data,
        params=params if params else None
    )
    
    print(curl_command)


if __name__ == "__main__":
    main()