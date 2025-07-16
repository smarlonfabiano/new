#!/bin/bash

# API Documentation Script
# This script documents the API endpoints, request/response formats, and authentication methods

# Set text formatting
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# API base URL - change this to match your deployment
API_BASE_URL="http://localhost:5000"

echo -e "${BOLD}===== API ENDPOINTS DOCUMENTATION =====${NC}\n"

echo -e "${BOLD}AUTHENTICATION METHODS${NC}"
echo -e "${YELLOW}This API uses JWT (JSON Web Token) authentication.${NC}"
echo -e "1. Obtain a token by sending a POST request to ${BLUE}/api/login${NC} with your credentials."
echo -e "2. Include the token in the Authorization header for protected endpoints:"
echo -e "   ${GREEN}Authorization: Bearer <your_token>${NC}\n"

echo -e "${BOLD}AVAILABLE ENDPOINTS${NC}"

# Function to display endpoint information
display_endpoint() {
    local path=$1
    local method=$2
    local description=$3
    local request=$4
    local response=$5
    local auth=$6

    echo -e "\n${BOLD}${method} ${path}${NC}"
    echo -e "${YELLOW}Description:${NC} ${description}"
    echo -e "${YELLOW}Authentication:${NC} ${auth}"
    echo -e "${YELLOW}Request Format:${NC}"
    echo -e "${request}"
    echo -e "${YELLOW}Response Format:${NC}"
    echo -e "${response}"
    echo -e "${BLUE}-------------------------------------${NC}"
}

# Authentication endpoint
display_endpoint "/api/login" "POST" "Authenticate user and get JWT token" \
'{
  "username": "string",
  "password": "string"
}' \
'{
  "token": "JWT token string"
}' \
"None"

# Get all items endpoint
display_endpoint "/api/items" "GET" "Get all items" \
"No request body needed
Headers:
  Authorization: Bearer <token>" \
'[
  {
    "id": integer,
    "name": "string",
    "description": "string"
  }
]' \
"JWT Bearer token"

# Get specific item endpoint
display_endpoint "/api/items/{item_id}" "GET" "Get a specific item by ID" \
"No request body needed
Headers:
  Authorization: Bearer <token>" \
'{
  "id": integer,
  "name": "string",
  "description": "string"
}' \
"JWT Bearer token"

# Create item endpoint
display_endpoint "/api/items" "POST" "Create a new item" \
'{
  "name": "string",
  "description": "string"
}
Headers:
  Authorization: Bearer <token>
  Content-Type: application/json' \
'{
  "id": integer,
  "name": "string",
  "description": "string"
}' \
"JWT Bearer token"

# Update item endpoint
display_endpoint "/api/items/{item_id}" "PUT" "Update an existing item" \
'{
  "name": "string",
  "description": "string"
}
Headers:
  Authorization: Bearer <token>
  Content-Type: application/json' \
'{
  "id": integer,
  "name": "string",
  "description": "string"
}' \
"JWT Bearer token"

# Delete item endpoint
display_endpoint "/api/items/{item_id}" "DELETE" "Delete an item" \
"No request body needed
Headers:
  Authorization: Bearer <token>" \
'{
  "message": "string"
}' \
"JWT Bearer token"

# API documentation endpoint
display_endpoint "/api/docs" "GET" "Get API documentation" \
"No request body needed" \
'{
  "endpoints": [
    {
      "path": "string",
      "method": "string",
      "description": "string",
      "request_format": {},
      "response_format": {},
      "authentication": "string"
    }
  ]
}' \
"None"

echo -e "\n${BOLD}EXAMPLE USAGE${NC}"
echo -e "Here's how to use the API with curl:\n"

echo -e "${BOLD}1. Login and get token:${NC}"
echo -e "${GREEN}curl -X POST ${API_BASE_URL}/api/login -H \"Content-Type: application/json\" -d '{\"username\":\"user1\",\"password\":\"password1\"}'${NC}\n"

echo -e "${BOLD}2. Get all items (with token):${NC}"
echo -e "${GREEN}curl -X GET ${API_BASE_URL}/api/items -H \"Authorization: Bearer <your_token>\"${NC}\n"

echo -e "${BOLD}3. Create a new item:${NC}"
echo -e "${GREEN}curl -X POST ${API_BASE_URL}/api/items -H \"Authorization: Bearer <your_token>\" -H \"Content-Type: application/json\" -d '{\"name\":\"New Item\",\"description\":\"Description for new item\"}'${NC}\n"

echo -e "${BOLD}LIVE API DOCUMENTATION${NC}"
echo -e "To get the latest API documentation directly from the API, use:"
echo -e "${GREEN}curl -X GET ${API_BASE_URL}/api/docs${NC}\n"

# Make the script executable
chmod +x "$0"