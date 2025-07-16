# Host Header API

A simple Flask API that demonstrates how to access and display the HTTP Host header from incoming requests.

## Features

- API endpoint that extracts and returns the Host header
- Comprehensive documentation in code comments
- Unit tests to verify functionality

## Installation

1. Clone this repository
2. Install the required dependencies:

```bash
pip install -r requirements.txt
```

## Usage

### Running the API

Start the Flask application:

```bash
python app.py
```

The API will be available at `http://localhost:5000/`.

### Available Endpoints

- `GET /`: Returns basic API information and the current host header
- `GET /host-header`: Returns the Host header from the request

### Example Request

```bash
curl -H "Host: example.com" http://localhost:5000/host-header
```

Example response:
```json
{
  "description": "The Host header specifies the domain name of the server (or IP address) and optionally the port number on which the server is listening.",
  "host_header": "example.com"
}
```

## Running Tests

Execute the test suite:

```bash
python -m unittest test_app.py
```

or using pytest:

```bash
pytest test_app.py
```