#!/usr/bin/env python3
"""
Host Header API

This module provides a simple Flask API with an endpoint that displays
the host header from incoming HTTP requests.
"""

from flask import Flask, request, jsonify

# Initialize the Flask application
app = Flask(__name__)

@app.route('/host-header', methods=['GET'])
def get_host_header():
    """
    API Endpoint: /host-header
    Method: GET
    
    This endpoint extracts and returns the Host header from the incoming HTTP request.
    The Host header specifies the domain name of the server and optionally the TCP port number.
    
    Returns:
        JSON response containing:
        - host_header: The value of the Host header from the request
        - description: A brief explanation of what the Host header represents
    """
    # Extract the Host header from the request
    host_header = request.headers.get('Host', 'Not provided')
    
    # Return the host header as a JSON response
    return jsonify({
        'host_header': host_header,
        'description': 'The Host header specifies the domain name of the server (or IP address) and '
                      'optionally the port number on which the server is listening.'
    })

@app.route('/', methods=['GET'])
def index():
    """
    API Endpoint: /
    Method: GET
    
    Root endpoint that provides basic information about the API.
    
    Returns:
        JSON response with API information and available endpoints
    """
    return jsonify({
        'api_name': 'Host Header API',
        'description': 'A simple API that demonstrates how to access HTTP headers',
        'endpoints': {
            '/host-header': 'Returns the Host header from the request',
            '/': 'This information page'
        },
        'current_host': request.headers.get('Host', 'Not provided')
    })

if __name__ == '__main__':
    # Run the Flask application in debug mode
    # Note: Debug mode should be turned off in production
    app.run(debug=True, host='0.0.0.0', port=5000)