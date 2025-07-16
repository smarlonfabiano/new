#!/usr/bin/env python3
"""
Example usage of the Path Curl Generator
"""

from src.path_curl_generator import generate_curl_command

# Example 1: Basic GET request
print("Example 1: Basic GET request")
print("-" * 50)
curl_command = generate_curl_command(
    base_url="https://api.example.com",
    path="/v1/users"
)
print(curl_command)
print("\n")

# Example 2: POST request with JSON data
print("Example 2: POST request with JSON data")
print("-" * 50)
curl_command = generate_curl_command(
    base_url="https://api.example.com",
    path="/v1/users",
    method="POST",
    headers={"Authorization": "Bearer token123"},
    data={"name": "John Doe", "email": "john@example.com"}
)
print(curl_command)
print("\n")

# Example 3: GET request with query parameters
print("Example 3: GET request with query parameters")
print("-" * 50)
curl_command = generate_curl_command(
    base_url="https://api.example.com",
    path="/v1/users/search",
    params={"name": "John", "role": "admin"}
)
print(curl_command)
print("\n")

# Example 4: PUT request with path parameters
print("Example 4: PUT request with path parameters")
print("-" * 50)
user_id = "12345"
curl_command = generate_curl_command(
    base_url="https://api.example.com",
    path=f"/v1/users/{user_id}",
    method="PUT",
    data={"name": "John Smith", "email": "john.smith@example.com"}
)
print(curl_command)