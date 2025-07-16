# API Client with SQL Query Execution

This repository contains a simple API client that connects to a backend API and executes SQL queries.

## Files

- `api_client.py`: Main API client implementation
- `query.sql`: Example SQL query file
- `test_api_client.py`: Unit tests for the API client

## Backend API Information

- **Domain**: api.example.com
- **IP Address**: 192.168.1.100
- **Base URL**: https://api.example.com/v1

## Usage

### Setting up

```bash
# Set your API key as an environment variable
export API_KEY="your_api_key_here"
```

### Running the API client

```bash
python api_client.py
```

### Running tests

```bash
python test_api_client.py
```

## SQL Query Example

The following SQL query is used to fetch active users:

```sql
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
```

This query is executed on the backend database via the API at api.example.com (IP: 192.168.1.100).