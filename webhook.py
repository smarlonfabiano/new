#!/usr/bin/env python3
"""
Webhook implementation for sending data to a specified webhook URL.
"""

import json
import logging
import time
from typing import Dict, Any, Optional, Union
import requests

from config import (
    DEFAULT_WEBHOOK_URL,
    MAX_RETRIES,
    RETRY_DELAY_SECONDS,
    REQUEST_TIMEOUT,
    DEFAULT_HEADERS
)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class WebhookSender:
    """
    A class to handle sending data to webhook endpoints.
    """
    
    def __init__(self, webhook_url: str = None, max_retries: int = None, retry_delay: int = None):
        """
        Initialize the WebhookSender with the target URL and retry settings.
        
        Args:
            webhook_url: The URL to send webhook data to
            max_retries: Maximum number of retry attempts on failure
            retry_delay: Delay between retries in seconds
        """
        self.webhook_url = webhook_url or DEFAULT_WEBHOOK_URL
        self.max_retries = max_retries or MAX_RETRIES
        self.retry_delay = retry_delay or RETRY_DELAY_SECONDS
        
    def send(self, data: Union[Dict[str, Any], str], headers: Optional[Dict[str, str]] = None) -> requests.Response:
        """
        Send data to the webhook URL.
        
        Args:
            data: The data to send (dictionary will be converted to JSON)
            headers: Optional HTTP headers to include
            
        Returns:
            requests.Response: The HTTP response
            
        Raises:
            requests.RequestException: If the request fails after all retries
        """
        if headers is None:
            headers = DEFAULT_HEADERS
            
        # Convert dict to JSON string if needed
        payload = data
        if isinstance(data, dict):
            payload = json.dumps(data)
            
        # Attempt to send with retries
        attempt = 0
        last_exception = None
        
        while attempt < self.max_retries:
            try:
                logger.info(f"Sending webhook to {self.webhook_url}")
                response = requests.post(
                    self.webhook_url, 
                    data=payload, 
                    headers=headers,
                    timeout=REQUEST_TIMEOUT
                )
                response.raise_for_status()  # Raise exception for 4XX/5XX responses
                
                logger.info(f"Webhook sent successfully. Status code: {response.status_code}")
                return response
                
            except requests.RequestException as e:
                attempt += 1
                last_exception = e
                logger.warning(f"Webhook attempt {attempt} failed: {str(e)}")
                
                if attempt < self.max_retries:
                    logger.info(f"Retrying in {self.retry_delay} seconds...")
                    time.sleep(self.retry_delay)
        
        # If we get here, all retries failed
        logger.error(f"All webhook attempts failed after {self.max_retries} retries")
        raise last_exception

# Example usage
if __name__ == "__main__":
    webhook = WebhookSender()
    try:
        response = webhook.send({"message": "Hello from webhook!", "timestamp": time.time()})
        print(f"Response status: {response.status_code}")
        print(f"Response body: {response.text}")
    except Exception as e:
        print(f"Failed to send webhook: {e}")