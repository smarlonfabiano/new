#!/bin/bash

# Internal Codename: NightHawk
# Version: 1.0.0

# Print a welcome message
echo "Welcome to the NightHawk script!"
echo "This is version 1.0.0"

# Get current date and time
current_date=$(date "+%Y-%m-%d %H:%M:%S")
echo "Current date and time: $current_date"

# Display system information
echo -e "\nSystem Information:"
echo "-------------------"
echo "Hostname: $(hostname)"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"

# Example function
function check_disk_space() {
    echo -e "\nDisk Space Usage:"
    echo "----------------"
    df -h | grep -v "tmpfs" | grep -v "udev"
}

# Call the function
check_disk_space

echo -e "\nScript execution completed."