# Configuration Management System

This repository contains a bash script for managing configuration files, environment variables, and deployment settings for an application.

## Directory Structure

```
.
├── config_manager.sh       # Main configuration management script
├── config_files/           # Directory containing configuration files
│   ├── app.conf           # Application configuration
│   ├── db.conf            # Database configuration
│   ├── logging.conf       # Logging configuration
│   ├── security.conf      # Security configuration
│   └── cache.conf         # Cache configuration
├── tests/                  # Test scripts
│   └── test_config_manager.sh  # Test script for config_manager.sh
└── README.md               # This file
```

## Configuration Files

The system manages the following configuration files:

1. **app.conf**: Main application configuration
2. **db.conf**: Database connection settings
3. **logging.conf**: Logging configuration
4. **security.conf**: Security settings
5. **cache.conf**: Caching configuration

## Environment Variables

The application uses the following environment variables:

### Required Environment Variables

- `APP_ENV`: Application environment (development, testing, production)
- `DB_HOST`: Database host address
- `DB_PORT`: Database port
- `DB_USER`: Database username
- `DB_PASS`: Database password
- `LOG_LEVEL`: Logging level

### Optional Environment Variables

- `API_KEY`: API authentication key
- `CACHE_TTL`: Cache time-to-live in seconds
- `DEBUG`: Enable debug mode (true/false)

### Default Values

If not set, the following default values are used:

- `APP_ENV=development`
- `DB_HOST=localhost`
- `DB_PORT=5432`
- `LOG_LEVEL=info`
- `CACHE_TTL=3600`
- `DEBUG=false`

## Deployment Settings

The system supports the following deployment environments:

1. **development**: Local development environment
2. **testing**: Testing environment
3. **staging**: Pre-production environment
4. **production**: Production environment

Each environment has specific settings for:
- Debug mode
- Logging verbosity
- Database connections
- Caching
- Load balancing (production only)

## Usage

```bash
./config_manager.sh [command] [options]
```

### Available Commands

- `list-configs`: List all available configuration files
- `show-config <filename>`: Display content of a specific configuration file
- `list-env`: List all environment variables used by the application
- `check-deployment`: Check deployment settings
- `validate`: Validate all configuration files
- `backup`: Backup all configuration files

### Examples

```bash
# List all configuration files
./config_manager.sh list-configs

# Show the content of app.conf
./config_manager.sh show-config app.conf

# List all environment variables
./config_manager.sh list-env

# Check deployment settings
./config_manager.sh check-deployment

# Validate all configuration files
./config_manager.sh validate

# Backup all configuration files
./config_manager.sh backup
```

## Testing

To run the tests:

```bash
cd tests
./test_config_manager.sh
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.