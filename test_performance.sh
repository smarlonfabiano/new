#!/bin/bash

# This is a simple test script to generate some load for testing the performance metrics script

# Function to generate CPU load
generate_cpu_load() {
    echo "Generating CPU load..."
    for i in {1..5}; do
        # Start a background process that consumes CPU
        yes > /dev/null &
    done
    
    # Let it run for a few seconds
    sleep 10
    
    # Kill the background processes
    killall yes 2>/dev/null
}

# Function to generate memory load
generate_memory_load() {
    echo "Generating memory load..."
    # Create a large array in memory
    for i in {1..500}; do
        # Each iteration allocates about 1MB
        dd if=/dev/zero bs=1024 count=1024 2>/dev/null | cat > /dev/null
        sleep 0.01
    done
}

# Function to generate disk I/O load
generate_disk_load() {
    echo "Generating disk I/O load..."
    # Create a temporary file and write to it
    TEMP_FILE=$(mktemp)
    for i in {1..20}; do
        dd if=/dev/zero of="$TEMP_FILE" bs=1M count=100 conv=fdatasync 2>/dev/null
        sleep 0.5
    done
    rm -f "$TEMP_FILE"
}

# Main execution
echo "Starting test workload..."
generate_cpu_load
generate_memory_load
generate_disk_load
echo "Test workload completed."