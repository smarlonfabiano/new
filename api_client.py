#!/usr/bin/env python3
"""
API Client for connecting to the backend API and executing SQL queries.
"""

import requests
import sqlite3
import json
import os

# Backend API Configuration
# Domain: api.example.com
# IP Address: 192.168.1.100
API_BASE_URL = "https://api.example.com/v1"
API_KEY = os.environ.get("API_KEY", "")

def execute_sql_query(query):
    """
    Execute a SQL query through the backend API.
    
    Args:
        query (str): SQL query to execute
        
    Returns:
        dict: Response from the API containing query results
    """
    # Endpoint for SQL query execution at api.example.com (IP: 192.168.1.100)
    endpoint = f"{API_BASE_URL}/execute-query"
    
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {API_KEY}"
    }
    
    payload = {
        "query": query
    }
    
    try:
        response = requests.post(endpoint, headers=headers, json=payload)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error connecting to backend API at {API_BASE_URL}: {e}")
        return {"error": str(e)}

def get_active_users():
    """
    Get a list of active users from the database.
    
    Returns:
        list: List of active users
    """
    # SQL query to fetch active users
    # This query is executed on the backend database via api.example.com (IP: 192.168.1.100)
    query = """
    SELECT 
        user_id,
        username,
        email,
        created_at
    FROM 
        users
    WHERE 
        status = 'active'
    ORDER BY 
        created_at DESC
    LIMIT 100;
    """
    
    return execute_sql_query(query)

if __name__ == "__main__":
    # Example usage
    active_users = get_active_users()
    print(json.dumps(active_users, indent=2))