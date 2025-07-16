#!/bin/bash

# =============================================================================
# Configuration Management Script
# =============================================================================
# This script demonstrates how to manage configuration from various sources:
# 1. Configuration files (.env, .json, .yaml)
# 2. Environment variables
# 3. Deployment settings
#
# Usage: ./config_manager.sh [environment]
#   environment: dev (default), staging, prod
# =============================================================================

set -e  # Exit immediately if a command exits with a non-zero status

# =============================================================================
# CONFIGURATION SOURCES AND PRIORITIES
# =============================================================================
# Configuration is loaded in the following order (later sources override earlier ones):
# 1. Default values (hardcoded in this script)
# 2. Configuration files (config.json, config.yaml)
# 3. Environment-specific files (dev.env, staging.env, prod.env)
# 4. Environment variables (set before running the script)
# 5. Command line arguments

# =============================================================================
# DEFAULT CONFIGURATION
# =============================================================================
# These are fallback values if not specified elsewhere

APP_NAME="MyApp"
APP_VERSION="1.0.0"
LOG_LEVEL="info"
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="myapp"
DB_USER="user"
DB_PASSWORD="password"
CACHE_ENABLED="false"
CACHE_TTL="3600"
API_ENDPOINT="http://api.example.com"
MAX_CONNECTIONS="100"
TIMEOUT="30"
DEBUG_MODE="false"

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

# Display script usage information
show_usage() {
    echo "Usage: $0 [environment]"
    echo "  environment: dev (default), staging, prod"
    exit 1
}

# Display a section header
print_header() {
    echo
    echo "=== $1 ==="
    echo
}

# Load .env file if it exists
load_env_file() {
    local env_file=$1
    if [[ -f "$env_file" ]]; then
        echo "Loading environment from $env_file"
        # Use export to make variables available to child processes
        set -a
        source "$env_file"
        set +a
    else
        echo "Environment file $env_file not found, skipping..."
    fi
}

# Load JSON configuration if jq is available
load_json_config() {
    local json_file=$1
    if [[ -f "$json_file" ]]; then
        if command -v jq &> /dev/null; then
            echo "Loading configuration from $json_file"
            
            # Extract each key-value pair from JSON and set as variables
            while IFS="=" read -r key value; do
                # Remove quotes from the value
                value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//')
                # Export the variable
                export "$key"="$value"
            done < <(jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" "$json_file")
        else
            echo "Warning: jq is not installed. Cannot parse JSON configuration."
        fi
    else
        echo "JSON configuration file $json_file not found, skipping..."
    fi
}

# Load YAML configuration if yq is available
load_yaml_config() {
    local yaml_file=$1
    if [[ -f "$yaml_file" ]]; then
        if command -v yq &> /dev/null; then
            echo "Loading configuration from $yaml_file"
            
            # Extract each key-value pair from YAML and set as variables
            while IFS="=" read -r key value; do
                # Export the variable
                export "$key"="$value"
            done < <(yq eval '.[] | key + "=" + value' "$yaml_file")
        else
            echo "Warning: yq is not installed. Cannot parse YAML configuration."
        fi
    else
        echo "YAML configuration file $yaml_file not found, skipping..."
    fi
}

# Validate required configuration values
validate_config() {
    local missing_vars=()
    
    # List of required variables
    local required_vars=(
        "APP_NAME"
        "DB_HOST"
        "DB_PORT"
        "DB_NAME"
        "DB_USER"
        "DB_PASSWORD"
    )
    
    for var in "${required_vars[@]}"; do
        if [[ -z "${!var}" ]]; then
            missing_vars+=("$var")
        fi
    done
    
    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        echo "Error: The following required configuration variables are missing:"
        for var in "${missing_vars[@]}"; do
            echo "  - $var"
        done
        exit 1
    fi
    
    # Validate specific values
    if ! [[ "$DB_PORT" =~ ^[0-9]+$ ]]; then
        echo "Error: DB_PORT must be a number"
        exit 1
    fi
    
    if ! [[ "$CACHE_ENABLED" =~ ^(true|false)$ ]]; then
        echo "Error: CACHE_ENABLED must be 'true' or 'false'"
        exit 1
    fi
}

# Apply environment-specific overrides
apply_environment_settings() {
    local env=$1
    
    case "$env" in
        dev)
            # Development environment settings
            DEBUG_MODE="true"
            LOG_LEVEL="debug"
            ;;
        staging)
            # Staging environment settings
            DEBUG_MODE="false"
            LOG_LEVEL="info"
            API_ENDPOINT="http://staging-api.example.com"
            ;;
        prod)
            # Production environment settings
            DEBUG_MODE="false"
            LOG_LEVEL="warn"
            API_ENDPOINT="http://api.example.com"
            CACHE_ENABLED="true"
            CACHE_TTL="7200"
            MAX_CONNECTIONS="500"
            ;;
        *)
            echo "Error: Unknown environment '$env'"
            show_usage
            ;;
    esac
    
    echo "Applied $env environment settings"
}

# Display current configuration
show_config() {
    print_header "CURRENT CONFIGURATION"
    
    # Application settings
    echo "Application Settings:"
    echo "  APP_NAME: $APP_NAME"
    echo "  APP_VERSION: $APP_VERSION"
    echo "  DEBUG_MODE: $DEBUG_MODE"
    echo "  LOG_LEVEL: $LOG_LEVEL"
    
    # Database settings
    echo
    echo "Database Settings:"
    echo "  DB_HOST: $DB_HOST"
    echo "  DB_PORT: $DB_PORT"
    echo "  DB_NAME: $DB_NAME"
    echo "  DB_USER: $DB_USER"
    echo "  DB_PASSWORD: ${DB_PASSWORD//?/*}"  # Mask password
    
    # API settings
    echo
    echo "API Settings:"
    echo "  API_ENDPOINT: $API_ENDPOINT"
    echo "  TIMEOUT: $TIMEOUT"
    
    # Cache settings
    echo
    echo "Cache Settings:"
    echo "  CACHE_ENABLED: $CACHE_ENABLED"
    echo "  CACHE_TTL: $CACHE_TTL"
    
    # Performance settings
    echo
    echo "Performance Settings:"
    echo "  MAX_CONNECTIONS: $MAX_CONNECTIONS"
}

# Export configuration as environment variables for child processes
export_config() {
    export APP_NAME
    export APP_VERSION
    export LOG_LEVEL
    export DB_HOST
    export DB_PORT
    export DB_NAME
    export DB_USER
    export DB_PASSWORD
    export CACHE_ENABLED
    export CACHE_TTL
    export API_ENDPOINT
    export MAX_CONNECTIONS
    export TIMEOUT
    export DEBUG_MODE
}

# Generate a configuration file based on current settings
generate_config_file() {
    local output_file=$1
    local format=$2
    
    case "$format" in
        env)
            echo "# Configuration file generated on $(date)" > "$output_file"
            echo "APP_NAME=$APP_NAME" >> "$output_file"
            echo "APP_VERSION=$APP_VERSION" >> "$output_file"
            echo "LOG_LEVEL=$LOG_LEVEL" >> "$output_file"
            echo "DB_HOST=$DB_HOST" >> "$output_file"
            echo "DB_PORT=$DB_PORT" >> "$output_file"
            echo "DB_NAME=$DB_NAME" >> "$output_file"
            echo "DB_USER=$DB_USER" >> "$output_file"
            echo "DB_PASSWORD=$DB_PASSWORD" >> "$output_file"
            echo "CACHE_ENABLED=$CACHE_ENABLED" >> "$output_file"
            echo "CACHE_TTL=$CACHE_TTL" >> "$output_file"
            echo "API_ENDPOINT=$API_ENDPOINT" >> "$output_file"
            echo "MAX_CONNECTIONS=$MAX_CONNECTIONS" >> "$output_file"
            echo "TIMEOUT=$TIMEOUT" >> "$output_file"
            echo "DEBUG_MODE=$DEBUG_MODE" >> "$output_file"
            ;;
        json)
            cat > "$output_file" << EOF
{
  "APP_NAME": "$APP_NAME",
  "APP_VERSION": "$APP_VERSION",
  "LOG_LEVEL": "$LOG_LEVEL",
  "DB_HOST": "$DB_HOST",
  "DB_PORT": "$DB_PORT",
  "DB_NAME": "$DB_NAME",
  "DB_USER": "$DB_USER",
  "DB_PASSWORD": "$DB_PASSWORD",
  "CACHE_ENABLED": $CACHE_ENABLED,
  "CACHE_TTL": $CACHE_TTL,
  "API_ENDPOINT": "$API_ENDPOINT",
  "MAX_CONNECTIONS": $MAX_CONNECTIONS,
  "TIMEOUT": $TIMEOUT,
  "DEBUG_MODE": $DEBUG_MODE
}
EOF
            ;;
        *)
            echo "Error: Unsupported format '$format'"
            exit 1
            ;;
    esac
    
    echo "Generated configuration file: $output_file"
}

# =============================================================================
# MAIN SCRIPT
# =============================================================================

# Parse command line arguments
ENVIRONMENT="dev"  # Default environment
if [[ $# -gt 0 ]]; then
    ENVIRONMENT="$1"
fi

print_header "CONFIGURATION LOADING PROCESS"

# 1. Load base configuration files
load_json_config "config.json"
load_yaml_config "config.yaml"

# 2. Load environment-specific configuration
load_env_file "${ENVIRONMENT}.env"

# 3. Apply environment-specific settings
apply_environment_settings "$ENVIRONMENT"

# 4. Validate configuration
validate_config

# 5. Export configuration for child processes
export_config

# 6. Display current configuration
show_config

# Example of generating a configuration file
if [[ "$ENVIRONMENT" == "dev" ]]; then
    print_header "GENERATING SAMPLE CONFIG FILES"
    generate_config_file "generated.env" "env"
    generate_config_file "generated.json" "json"
fi

print_header "CONFIGURATION MANAGEMENT COMPLETE"
echo "Environment: $ENVIRONMENT"
echo "Application: $APP_NAME v$APP_VERSION"
echo "Debug mode: $DEBUG_MODE"

exit 0