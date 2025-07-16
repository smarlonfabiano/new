#!/usr/bin/env python3
"""
Command-line utility for sending webhooks.
"""

import argparse
import json
import sys
import time
from webhook import WebhookSender

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description='Send data to a webhook endpoint.')
    parser.add_argument('--url', '-u', help='Webhook URL (overrides default)')
    parser.add_argument('--data', '-d', required=True, help='JSON data to send')
    parser.add_argument('--retries', '-r', type=int, help='Number of retries on failure')
    parser.add_argument('--delay', '-w', type=int, help='Delay between retries in seconds')
    return parser.parse_args()

def main():
    """Main entry point for the script."""
    args = parse_args()
    
    # Parse the JSON data
    try:
        data = json.loads(args.data)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON data - {e}")
        sys.exit(1)
    
    # Create webhook sender with optional parameters
    webhook = WebhookSender(
        webhook_url=args.url,
        max_retries=args.retries,
        retry_delay=args.delay
    )
    
    # Send the webhook
    try:
        start_time = time.time()
        response = webhook.send(data)
        elapsed = time.time() - start_time
        
        print(f"Webhook sent successfully in {elapsed:.2f} seconds")
        print(f"Status code: {response.status_code}")
        print(f"Response: {response.text[:100]}{'...' if len(response.text) > 100 else ''}")
        return 0
    except Exception as e:
        print(f"Error sending webhook: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())