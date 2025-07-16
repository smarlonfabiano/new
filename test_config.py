#!/usr/bin/env python3
"""
Test script to validate the YAML configuration file.
This script checks if:
1. The config.yaml file exists
2. It can be parsed as valid YAML
3. It contains the expected top-level keys
"""

import os
import sys
import yaml

def test_yaml_config():
    """Test the YAML configuration file."""
    # Check if the file exists
    config_path = os.path.join(os.path.dirname(__file__), 'config.yaml')
    if not os.path.exists(config_path):
        print("ERROR: config.yaml file not found")
        return False
    
    # Try to parse the YAML file
    try:
        with open(config_path, 'r') as file:
            config = yaml.safe_load(file)
    except yaml.YAMLError as e:
        print(f"ERROR: Invalid YAML format: {e}")
        return False
    
    # Check if it's a dictionary (as expected)
    if not isinstance(config, dict):
        print("ERROR: YAML content is not a dictionary")
        return False
    
    # Check for expected top-level keys
    expected_keys = ['app', 'server', 'database', 'logging', 'features']
    missing_keys = [key for key in expected_keys if key not in config]
    
    if missing_keys:
        print(f"ERROR: Missing expected keys: {', '.join(missing_keys)}")
        return False
    
    print("SUCCESS: YAML configuration file is valid")
    return True

if __name__ == "__main__":
    success = test_yaml_config()
    sys.exit(0 if success else 1)