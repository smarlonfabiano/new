# Configuration Repository

This repository contains configuration files for the application.

## Files

- `config.yaml`: Main configuration file for the application
- `test_config.py`: Test script to validate the YAML configuration

## Usage

### Configuration

The `config.yaml` file contains various configuration settings for the application, including:

- Application settings
- Server configuration
- Database connection details
- Logging configuration
- Feature flags

You can modify these settings according to your environment requirements.

### Testing

To validate the YAML configuration file, run:

```bash
python test_config.py
```

This will check if:
1. The config.yaml file exists
2. It can be parsed as valid YAML
3. It contains the expected top-level keys

## Requirements

To run the test script, you need:
- Python 3.x
- PyYAML package (`pip install pyyaml`)