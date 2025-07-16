# Configuration Management System

This repository contains a comprehensive configuration management system implemented as a bash script. The system demonstrates how to manage configuration from various sources including configuration files, environment variables, and deployment settings.

## Features

- Load configuration from multiple file formats:
  - Environment files (.env)
  - JSON files (.json)
  - YAML files (.yaml)
- Override configuration with environment variables
- Environment-specific configuration (dev, staging, prod)
- Configuration validation
- Generate configuration files from current settings
- Comprehensive testing

## Files

- `config_manager.sh`: Main configuration management script
- `dev.env`, `staging.env`, `prod.env`: Environment-specific configuration files
- `config.json`: Sample JSON configuration
- `config.yaml`: Sample YAML configuration
- `test_config_manager.sh`: Test script to verify functionality

## Usage

### Basic Usage

```bash
# Use default environment (dev)
./config_manager.sh

# Specify an environment
./config_manager.sh staging
./config_manager.sh prod
```

### Override with Environment Variables

```bash
# Override specific settings with environment variables
DB_HOST=custom-db.example.com LOG_LEVEL=debug ./config_manager.sh prod
```

### Running Tests

```bash
# Run the test script
./test_config_manager.sh
```

## Configuration Sources and Priorities

Configuration is loaded in the following order (later sources override earlier ones):

1. Default values (hardcoded in the script)
2. Configuration files (config.json, config.yaml)
3. Environment-specific files (dev.env, staging.env, prod.env)
4. Environment variables (set before running the script)
5. Command line arguments

## Configuration Categories

### Application Settings
- `APP_NAME`: Name of the application
- `APP_VERSION`: Version of the application
- `DEBUG_MODE`: Enable/disable debug mode
- `LOG_LEVEL`: Logging level (debug, info, warn, error)

### Database Settings
- `DB_HOST`: Database host
- `DB_PORT`: Database port
- `DB_NAME`: Database name
- `DB_USER`: Database user
- `DB_PASSWORD`: Database password

### API Settings
- `API_ENDPOINT`: API endpoint URL
- `TIMEOUT`: API request timeout in seconds

### Cache Settings
- `CACHE_ENABLED`: Enable/disable caching
- `CACHE_TTL`: Cache time-to-live in seconds

### Performance Settings
- `MAX_CONNECTIONS`: Maximum number of connections

## Environment-Specific Settings

### Development (dev)
- Debug mode enabled
- Verbose logging
- Local database
- Short cache TTL

### Staging
- Debug mode disabled
- Standard logging
- Staging database
- Moderate cache TTL

### Production (prod)
- Debug mode disabled
- Minimal logging
- Production database
- Long cache TTL
- Higher connection limits

## Dependencies

For full functionality, the following tools are recommended:
- `jq`: For parsing JSON configuration files
- `yq`: For parsing YAML configuration files

## License

This project is licensed under the MIT License - see the LICENSE file for details.