# API Documentation Project

This project provides a RESTful API with JWT authentication and a bash script to document the API endpoints, request/response formats, and authentication methods.

## Project Structure

- `api.py`: Main API implementation with Flask
- `document_api.sh`: Bash script that documents the API endpoints
- `test_api.py`: Unit tests for the API
- `requirements.txt`: Python dependencies

## Installation

1. Clone the repository
2. Make the bash scripts executable:

```bash
chmod +x document_api.sh run_api.sh
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```

## Running the API

Start the API server using either:

```bash
python api.py
```

Or use the provided script:

```bash
./run_api.sh
```

The API will be available at http://localhost:5000

## API Documentation

To view the API documentation, run the documentation script:

```bash
./document_api.sh
```

This script will display:
- Available API endpoints
- Request and response formats for each endpoint
- Authentication methods
- Example usage with curl commands

## API Endpoints

The API provides the following endpoints:

- `POST /api/login`: Authenticate and get JWT token
- `GET /api/items`: Get all items (requires authentication)
- `GET /api/items/{item_id}`: Get a specific item (requires authentication)
- `POST /api/items`: Create a new item (requires authentication)
- `PUT /api/items/{item_id}`: Update an existing item (requires authentication)
- `DELETE /api/items/{item_id}`: Delete an item (requires authentication)
- `GET /api/docs`: Get API documentation (no authentication required)

## Authentication

The API uses JWT (JSON Web Token) authentication:

1. Obtain a token by sending a POST request to `/api/login` with your credentials
2. Include the token in the Authorization header for protected endpoints:
   ```
   Authorization: Bearer <your_token>
   ```

## Running Tests

Run the test suite:

```bash
python -m unittest test_api.py
```

## Example Usage

### Login and get token:

```bash
curl -X POST http://localhost:5000/api/login -H "Content-Type: application/json" -d '{"username":"user1","password":"password1"}'
```

### Get all items (with token):

```bash
curl -X GET http://localhost:5000/api/items -H "Authorization: Bearer <your_token>"
```

### Create a new item:

```bash
curl -X POST http://localhost:5000/api/items -H "Authorization: Bearer <your_token>" -H "Content-Type: application/json" -d '{"name":"New Item","description":"Description for new item"}'
```