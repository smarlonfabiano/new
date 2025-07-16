# Webhook Implementation

This repository contains a Python implementation for sending data to a webhook endpoint.

## Features

- Send JSON or text data to webhook endpoints
- Configurable retry mechanism for handling failures
- Timeout handling
- Command-line interface for easy usage
- Comprehensive unit tests

## Installation

Install the required dependencies:

```bash
pip install -r requirements.txt
```

## Configuration

The default webhook URL is set to:
```
https://webhook.site/3e7ec7be-8801-4b4e-b88c-f7ca1fea7fc3
```

You can modify other settings in the `config.py` file:
- `MAX_RETRIES`: Number of retry attempts (default: 3)
- `RETRY_DELAY_SECONDS`: Delay between retries in seconds (default: 2)
- `REQUEST_TIMEOUT`: HTTP request timeout in seconds (default: 10)
- `DEFAULT_HEADERS`: Default HTTP headers for requests

## Usage

### As a Python Module

```python
from webhook import WebhookSender

# Create a webhook sender with default settings
webhook = WebhookSender()

# Send JSON data
response = webhook.send({"message": "Hello from webhook!", "timestamp": 1234567890})
print(f"Response status: {response.status_code}")

# Or specify a different webhook URL
custom_webhook = WebhookSender(webhook_url="https://your-webhook-url.com")
custom_webhook.send({"custom": "data"})
```

### Command Line Interface

Use the `send_webhook.py` script to send webhooks from the command line:

```bash
# Send data to the default webhook URL
python send_webhook.py --data '{"message": "Hello from CLI"}'

# Send to a custom URL
python send_webhook.py --url "https://your-webhook-url.com" --data '{"message": "Custom URL"}'

# Configure retries
python send_webhook.py --data '{"message": "With retries"}' --retries 5 --delay 3
```

### Example Application

Check out the `example.py` script for a more realistic example that simulates a system monitoring application that sends alerts via webhook:

```bash
python example.py
```

This example:
- Simulates collecting system metrics (CPU, memory, disk usage)
- Checks if any metrics exceed thresholds
- Sends alerts via webhook when thresholds are exceeded

## Verification

To verify that the webhook implementation is working correctly:

```bash
# Run the verification script
python verify_webhook.py
```

This script will send a test payload to the configured webhook URL and display the results.

You can also view the received webhooks at:
[https://webhook.site/#!/3e7ec7be-8801-4b4e-b88c-f7ca1fea7fc3](https://webhook.site/#!/3e7ec7be-8801-4b4e-b88c-f7ca1fea7fc3)

## Running Tests

Run the unit tests with:

```bash
python -m unittest test_webhook.py
```

The tests use mocking to simulate HTTP requests, so they don't actually send data to the webhook endpoint.

## License

This project is open source and available under the MIT License.