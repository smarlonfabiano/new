#!/usr/bin/env python3
"""
Verification script for testing the webhook implementation.
"""

import sys
import time
import uuid
from webhook import WebhookSender

def main():
    """Send a test webhook and verify the response."""
    print("Webhook Verification Script")
    print("--------------------------")
    
    # Create a unique test payload
    test_id = str(uuid.uuid4())
    timestamp = time.time()
    
    payload = {
        "message": "Webhook verification test",
        "test_id": test_id,
        "timestamp": timestamp,
        "source": "verify_webhook.py"
    }
    
    print(f"Sending test payload with ID: {test_id}")
    
    # Create webhook sender
    webhook = WebhookSender()
    
    try:
        # Send the webhook
        start_time = time.time()
        response = webhook.send(payload)
        elapsed = time.time() - start_time
        
        # Check response
        if response.status_code >= 200 and response.status_code < 300:
            print(f"✅ Webhook sent successfully in {elapsed:.2f} seconds")
            print(f"Status code: {response.status_code}")
            print(f"Response: {response.text[:100]}{'...' if len(response.text) > 100 else ''}")
            return 0
        else:
            print(f"❌ Webhook received non-success status code: {response.status_code}")
            print(f"Response: {response.text[:100]}{'...' if len(response.text) > 100 else ''}")
            return 1
            
    except Exception as e:
        print(f"❌ Error sending webhook: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())