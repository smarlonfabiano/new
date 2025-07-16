#!/usr/bin/env python3
"""
Example script demonstrating webhook usage in a real-world scenario.
This example simulates monitoring a system and sending alerts via webhook.
"""

import time
import random
import datetime
from webhook import WebhookSender

def get_system_metrics():
    """
    Simulate getting system metrics.
    In a real application, this would collect actual system data.
    """
    return {
        "cpu_usage": random.uniform(0, 100),
        "memory_usage": random.uniform(0, 100),
        "disk_usage": random.uniform(0, 100),
        "network_traffic": random.uniform(0, 1000),
        "timestamp": datetime.datetime.now().isoformat()
    }

def check_thresholds(metrics):
    """
    Check if any metrics exceed thresholds.
    Returns a list of alerts.
    """
    alerts = []
    
    if metrics["cpu_usage"] > 90:
        alerts.append(f"HIGH CPU USAGE: {metrics['cpu_usage']:.2f}%")
    
    if metrics["memory_usage"] > 85:
        alerts.append(f"HIGH MEMORY USAGE: {metrics['memory_usage']:.2f}%")
    
    if metrics["disk_usage"] > 80:
        alerts.append(f"HIGH DISK USAGE: {metrics['disk_usage']:.2f}%")
    
    return alerts

def main():
    """Main monitoring loop."""
    print("Starting system monitoring with webhook alerts...")
    webhook = WebhookSender()
    
    # In a real application, this would run continuously
    for i in range(5):
        print(f"\nMonitoring cycle {i+1}...")
        
        # Get metrics
        metrics = get_system_metrics()
        print(f"CPU: {metrics['cpu_usage']:.2f}%, "
              f"Memory: {metrics['memory_usage']:.2f}%, "
              f"Disk: {metrics['disk_usage']:.2f}%")
        
        # Check for alerts
        alerts = check_thresholds(metrics)
        
        # Send alerts via webhook if needed
        if alerts:
            print(f"Alerts detected: {', '.join(alerts)}")
            
            # Prepare webhook payload
            payload = {
                "alert_type": "system_monitor",
                "alerts": alerts,
                "metrics": metrics,
                "severity": "high" if len(alerts) > 1 else "medium"
            }
            
            # Send webhook
            try:
                response = webhook.send(payload)
                print(f"Webhook sent successfully. Status: {response.status_code}")
            except Exception as e:
                print(f"Failed to send webhook: {e}")
        else:
            print("No alerts detected.")
        
        # Wait before next check
        time.sleep(2)
    
    print("\nMonitoring complete.")

if __name__ == "__main__":
    main()