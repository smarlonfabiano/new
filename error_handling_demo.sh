#!/bin/bash
# =========================================================================
# Error Handling Patterns Demo Script
# 
# This script demonstrates various error handling mechanisms, exception
# patterns, and logging strategies in Bash scripting.
# =========================================================================

# =========================================================================
# LOGGING STRATEGY IMPLEMENTATION
# =========================================================================
# Logging strategy: Define log levels and functions for structured logging
# This implements a comprehensive logging system with different severity levels
# and consistent formatting including timestamps

# Define log file
LOG_FILE="./application.log"
touch "$LOG_FILE" 2>/dev/null || { echo "Cannot create log file"; exit 1; }

# Define log levels
readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_WARNING=2
readonly LOG_LEVEL_ERROR=3
readonly LOG_LEVEL_CRITICAL=4

# Set current log level (can be changed via environment variable)
CURRENT_LOG_LEVEL=${LOG_LEVEL:-$LOG_LEVEL_INFO}

# Logging functions for different severity levels
log_debug() {
    # Debug level logging - most verbose, for development use
    [[ $CURRENT_LOG_LEVEL -le $LOG_LEVEL_DEBUG ]] && log "DEBUG" "$1"
}

log_info() {
    # Info level logging - general information about normal operation
    [[ $CURRENT_LOG_LEVEL -le $LOG_LEVEL_INFO ]] && log "INFO" "$1"
}

log_warning() {
    # Warning level logging - potential issues that don't stop execution
    [[ $CURRENT_LOG_LEVEL -le $LOG_LEVEL_WARNING ]] && log "WARNING" "$1"
}

log_error() {
    # Error level logging - issues that may cause incorrect behavior
    [[ $CURRENT_LOG_LEVEL -le $LOG_LEVEL_ERROR ]] && log "ERROR" "$1"
}

log_critical() {
    # Critical level logging - severe issues that prevent execution
    [[ $CURRENT_LOG_LEVEL -le $LOG_LEVEL_CRITICAL ]] && log "CRITICAL" "$1"
}

# Core logging function with timestamp and formatting
log() {
    # $1 - log level
    # $2 - message
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local message="[$timestamp] [$1] $2"
    
    # Log to console with color coding
    case "$1" in
        "DEBUG")    echo -e "\033[36m$message\033[0m" ;;  # Cyan
        "INFO")     echo -e "\033[32m$message\033[0m" ;;  # Green
        "WARNING")  echo -e "\033[33m$message\033[0m" ;;  # Yellow
        "ERROR")    echo -e "\033[31m$message\033[0m" ;;  # Red
        "CRITICAL") echo -e "\033[35m$message\033[0m" ;;  # Purple
    esac
    
    # Log to file (without color codes)
    echo "$message" >> "$LOG_FILE"
}

# =========================================================================
# ERROR HANDLING MECHANISMS
# =========================================================================

# Error handling mechanism: Exit on error
# This makes the script exit immediately if any command fails
# Prevents cascading errors by stopping at the first failure
set -e

# Error handling mechanism: Exit on undefined variables
# Prevents using variables that haven't been defined
set -u

# Error handling mechanism: Prevent pipeline errors from being masked
# Returns the exit code of the last command to exit with non-zero status
set -o pipefail

# Error handling mechanism: Error trapping
# This function is called whenever a command returns a non-zero exit code
# Allows for cleanup operations and detailed error reporting
trap 'handle_error $? $LINENO $BASH_COMMAND' ERR

# Error handling function for the trap
handle_error() {
    local exit_code=$1
    local line_number=$2
    local command=$3
    
    log_critical "Error occurred: command '$command' exited with status $exit_code at line $line_number"
    
    # Cleanup operations can be performed here
    cleanup
    
    # Exit with the original error code
    exit $exit_code
}

# Cleanup function to handle resources before exit
cleanup() {
    log_info "Performing cleanup operations"
    # Remove temporary files, close connections, etc.
    # For demonstration purposes, we'll just log the action
    log_info "Cleanup completed"
}

# Ensure cleanup happens even on normal exit
trap cleanup EXIT

# =========================================================================
# EXCEPTION PATTERNS
# =========================================================================

# Exception pattern: Try-catch style error handling
# This mimics try-catch blocks from other languages
try_command() {
    log_info "Attempting operation: $1"
    
    # Run the command in a subshell to prevent script termination
    if output=$(eval "$1" 2>&1); then
        log_info "Operation succeeded"
        return 0
    else
        local exit_code=$?
        log_error "Operation failed with exit code $exit_code: $output"
        return $exit_code
    fi
}

# Exception pattern: Default values for missing parameters
# Provides fallback values when parameters aren't provided
get_param() {
    # $1 - parameter value
    # $2 - default value
    local result=${1:-$2}
    if [[ -z "$1" && -n "$2" ]]; then
        log_warning "Using default value: $2"
    fi
    echo "$result"
}

# Exception pattern: Input validation
# Ensures inputs meet expected criteria before processing
validate_input() {
    local input=$1
    local pattern=$2
    local error_message=$3
    
    if [[ ! $input =~ $pattern ]]; then
        log_error "$error_message"
        return 1
    fi
    return 0
}

# Exception pattern: Retry mechanism
# Attempts an operation multiple times before giving up
retry_command() {
    local cmd=$1
    local max_attempts=${2:-3}
    local delay=${3:-5}
    local attempt=1
    
    while [[ $attempt -le $max_attempts ]]; do
        log_info "Attempt $attempt of $max_attempts: $cmd"
        
        if eval "$cmd"; then
            log_info "Command succeeded on attempt $attempt"
            return 0
        else
            local exit_code=$?
            log_warning "Command failed on attempt $attempt with exit code $exit_code"
            
            if [[ $attempt -lt $max_attempts ]]; then
                log_info "Waiting $delay seconds before retry..."
                sleep $delay
            fi
        fi
        
        ((attempt++))
    done
    
    log_error "Command failed after $max_attempts attempts"
    return 1
}

# Exception pattern: Graceful degradation
# Falls back to simpler functionality when preferred method fails
perform_operation() {
    log_info "Attempting primary operation method"
    
    if primary_method "$@"; then
        log_info "Primary method succeeded"
    else
        log_warning "Primary method failed, falling back to secondary method"
        
        if secondary_method "$@"; then
            log_info "Secondary method succeeded"
        else
            log_error "Both primary and secondary methods failed"
            return 1
        fi
    fi
    
    return 0
}

# Mock implementation of primary and secondary methods
primary_method() {
    # Simulate a failure for demonstration
    return 1
}

secondary_method() {
    # Simulate a success for demonstration
    return 0
}

# =========================================================================
# DEMONSTRATION
# =========================================================================

main() {
    log_info "Starting error handling demonstration script"
    
    # Demonstrate parameter handling with defaults
    local username=$(get_param "$1" "default_user")
    log_info "Using username: $username"
    
    # Demonstrate input validation
    if validate_input "$username" "^[a-zA-Z0-9_]+$" "Username contains invalid characters"; then
        log_info "Username validation passed"
    else
        log_warning "Using username despite validation failure"
    fi
    
    # Demonstrate try-catch pattern
    try_command "ls -la /tmp"
    try_command "ls -la /nonexistent_directory"
    
    # Demonstrate retry mechanism
    retry_command "test -d /tmp" 3 1
    
    # Demonstrate graceful degradation
    perform_operation
    
    # Demonstrate conditional error checking
    if ! mkdir -p ./test_dir; then
        log_error "Failed to create test directory"
    else
        log_info "Successfully created test directory"
        rm -rf ./test_dir
    fi
    
    log_info "Error handling demonstration completed successfully"
}

# Run the main function with all script arguments
main "$@"