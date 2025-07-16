#!/usr/bin/env python3
"""
Configuration settings for the webhook implementation.
"""

# Default webhook URL from the requirements
DEFAULT_WEBHOOK_URL = "https://webhook.site/3e7ec7be-8801-4b4e-b88c-f7ca1fea7fc3"

# Retry settings
MAX_RETRIES = 3
RETRY_DELAY_SECONDS = 2

# Timeout settings (in seconds)
REQUEST_TIMEOUT = 10

# Default headers
DEFAULT_HEADERS = {
    'Content-Type': 'application/json',
    'User-Agent': 'Python-Webhook-Client/1.0'
}