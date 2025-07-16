#!/bin/bash

# =========================================================================
# Performance Metrics Analysis Script
# =========================================================================
# This script monitors and analyzes system performance metrics to identify
# potential bottlenecks and resource usage patterns.
#
# Usage: ./performance_metrics.sh [options]
#   Options:
#     -d, --duration SECONDS   Duration of monitoring in seconds (default: 60)
#     -i, --interval SECONDS   Sampling interval in seconds (default: 5)
#     -p, --process PID        Monitor specific process ID
#     -n, --name PROCESS_NAME  Monitor specific process by name
#     -o, --output FILE        Save results to file
#     -h, --help               Display this help message
#
# =========================================================================

# Default configuration
DURATION=60
INTERVAL=5
PROCESS_ID=""
PROCESS_NAME=""
OUTPUT_FILE=""
TEMP_DIR=$(mktemp -d)

# Function to display usage information
usage() {
    grep "^# Usage:" "$0" | sed 's/^# //'
    grep "^#   " "$0" | sed 's/^# //'
    exit 1
}

# Function to clean up temporary files
cleanup() {
    echo "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
    exit 0
}

# Set up trap for cleanup on script exit
trap cleanup EXIT INT TERM

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--duration)
            DURATION="$2"
            shift 2
            ;;
        -i|--interval)
            INTERVAL="$2"
            shift 2
            ;;
        -p|--process)
            PROCESS_ID="$2"
            shift 2
            ;;
        -n|--name)
            PROCESS_NAME="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate inputs
if ! [[ "$DURATION" =~ ^[0-9]+$ ]]; then
    echo "Error: Duration must be a positive integer"
    exit 1
fi

if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]]; then
    echo "Error: Interval must be a positive integer"
    exit 1
fi

if [[ -n "$PROCESS_ID" && ! "$PROCESS_ID" =~ ^[0-9]+$ ]]; then
    echo "Error: Process ID must be a positive integer"
    exit 1
fi

# If process name is provided, try to get its PID
if [[ -n "$PROCESS_NAME" ]]; then
    echo "Looking for process: $PROCESS_NAME"
    PROCESS_ID=$(pgrep -f "$PROCESS_NAME" | head -1)
    if [[ -z "$PROCESS_ID" ]]; then
        echo "Error: Process '$PROCESS_NAME' not found"
        exit 1
    fi
    echo "Found process with PID: $PROCESS_ID"
fi

# =========================================================================
# Monitoring Functions
# =========================================================================

# Function to monitor CPU usage
monitor_cpu() {
    echo "Monitoring CPU usage for ${DURATION} seconds (sampling every ${INTERVAL} seconds)..."
    
    # Create files for storing metrics
    CPU_FILE="$TEMP_DIR/cpu_usage.dat"
    > "$CPU_FILE"
    
    # Monitor CPU usage
    for ((i=0; i<DURATION; i+=INTERVAL)); do
        if [[ -n "$PROCESS_ID" ]]; then
            # Process-specific CPU monitoring
            CPU_USAGE=$(ps -p "$PROCESS_ID" -o %cpu= 2>/dev/null || echo "0")
        else
            # System-wide CPU monitoring
            CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
        fi
        
        echo "$i $CPU_USAGE" >> "$CPU_FILE"
        sleep "$INTERVAL"
    done
    
    # Calculate statistics
    if [[ -s "$CPU_FILE" ]]; then
        CPU_AVG=$(awk '{ sum += $2 } END { print sum / NR }' "$CPU_FILE")
        CPU_MAX=$(awk 'BEGIN { max = 0 } { if ($2 > max) max = $2 } END { print max }' "$CPU_FILE")
        CPU_MIN=$(awk 'BEGIN { min = 100 } { if ($2 < min) min = $2 } END { print min }' "$CPU_FILE")
    else
        CPU_AVG=0
        CPU_MAX=0
        CPU_MIN=0
    fi
}

# Function to monitor memory usage
monitor_memory() {
    echo "Monitoring memory usage for ${DURATION} seconds (sampling every ${INTERVAL} seconds)..."
    
    # Create files for storing metrics
    MEM_FILE="$TEMP_DIR/memory_usage.dat"
    > "$MEM_FILE"
    
    # Monitor memory usage
    for ((i=0; i<DURATION; i+=INTERVAL)); do
        if [[ -n "$PROCESS_ID" ]]; then
            # Process-specific memory monitoring (in KB)
            MEM_USAGE=$(ps -p "$PROCESS_ID" -o rss= 2>/dev/null || echo "0")
            # Convert to MB
            MEM_USAGE=$(echo "scale=2; $MEM_USAGE / 1024" | bc)
        else
            # System-wide memory usage (percentage)
            MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
        fi
        
        echo "$i $MEM_USAGE" >> "$MEM_FILE"
        sleep "$INTERVAL"
    done
    
    # Calculate statistics
    if [[ -s "$MEM_FILE" ]]; then
        MEM_AVG=$(awk '{ sum += $2 } END { print sum / NR }' "$MEM_FILE")
        MEM_MAX=$(awk 'BEGIN { max = 0 } { if ($2 > max) max = $2 } END { print max }' "$MEM_FILE")
        MEM_MIN=$(awk 'BEGIN { min = 999999 } { if ($2 < min) min = $2 } END { print min }' "$MEM_FILE")
    else
        MEM_AVG=0
        MEM_MAX=0
        MEM_MIN=0
    fi
}

# Function to monitor disk I/O
monitor_disk() {
    echo "Monitoring disk I/O for ${DURATION} seconds (sampling every ${INTERVAL} seconds)..."
    
    # Create files for storing metrics
    DISK_FILE="$TEMP_DIR/disk_usage.dat"
    > "$DISK_FILE"
    
    # Get initial disk stats
    if [[ -n "$PROCESS_ID" ]]; then
        # Process-specific disk monitoring is complex and requires tools like iotop
        echo "Process-specific disk I/O monitoring requires root privileges and specialized tools."
        echo "Using system-wide disk I/O statistics instead."
    fi
    
    # Get initial disk stats
    PREV_DISK_STATS=$(cat /proc/diskstats)
    
    # Monitor disk I/O
    for ((i=0; i<DURATION; i+=INTERVAL)); do
        sleep "$INTERVAL"
        
        # Get current disk stats
        CURR_DISK_STATS=$(cat /proc/diskstats)
        
        # Calculate disk I/O rate (simplified)
        # This extracts the 6th field (sectors read) and 10th field (sectors written) for the first disk
        DISK_READ=$(echo "$CURR_DISK_STATS" | grep -m1 "sda " | awk '{print $6}')
        PREV_READ=$(echo "$PREV_DISK_STATS" | grep -m1 "sda " | awk '{print $6}')
        DISK_WRITE=$(echo "$CURR_DISK_STATS" | grep -m1 "sda " | awk '{print $10}')
        PREV_WRITE=$(echo "$PREV_DISK_STATS" | grep -m1 "sda " | awk '{print $10}')
        
        # Calculate rates (sectors per second, 1 sector = 512 bytes)
        READ_RATE=$(echo "scale=2; ($DISK_READ - $PREV_READ) / $INTERVAL * 512 / 1024" | bc)
        WRITE_RATE=$(echo "scale=2; ($DISK_WRITE - $PREV_WRITE) / $INTERVAL * 512 / 1024" | bc)
        
        echo "$i $READ_RATE $WRITE_RATE" >> "$DISK_FILE"
        
        # Update previous stats
        PREV_DISK_STATS="$CURR_DISK_STATS"
    done
    
    # Calculate statistics
    if [[ -s "$DISK_FILE" ]]; then
        DISK_READ_AVG=$(awk '{ sum += $2 } END { print sum / NR }' "$DISK_FILE")
        DISK_WRITE_AVG=$(awk '{ sum += $3 } END { print sum / NR }' "$DISK_FILE")
        DISK_READ_MAX=$(awk 'BEGIN { max = 0 } { if ($2 > max) max = $2 } END { print max }' "$DISK_FILE")
        DISK_WRITE_MAX=$(awk 'BEGIN { max = 0 } { if ($3 > max) max = $3 } END { print max }' "$DISK_FILE")
    else
        DISK_READ_AVG=0
        DISK_WRITE_AVG=0
        DISK_READ_MAX=0
        DISK_WRITE_MAX=0
    fi
}

# Function to monitor network usage
monitor_network() {
    echo "Monitoring network usage for ${DURATION} seconds (sampling every ${INTERVAL} seconds)..."
    
    # Create files for storing metrics
    NET_FILE="$TEMP_DIR/network_usage.dat"
    > "$NET_FILE"
    
    # Get initial network stats (assuming eth0 or similar interface)
    INTERFACE=$(ip -o link show | grep -v "lo" | awk -F': ' '{print $2}' | head -1)
    if [[ -z "$INTERFACE" ]]; then
        echo "No network interface found. Skipping network monitoring."
        return
    fi
    
    echo "Monitoring network interface: $INTERFACE"
    PREV_RX=$(cat /proc/net/dev | grep "$INTERFACE" | awk '{print $2}')
    PREV_TX=$(cat /proc/net/dev | grep "$INTERFACE" | awk '{print $10}')
    
    # Monitor network usage
    for ((i=0; i<DURATION; i+=INTERVAL)); do
        sleep "$INTERVAL"
        
        # Get current network stats
        CURR_RX=$(cat /proc/net/dev | grep "$INTERFACE" | awk '{print $2}')
        CURR_TX=$(cat /proc/net/dev | grep "$INTERFACE" | awk '{print $10}')
        
        # Calculate rates (bytes per second)
        RX_RATE=$(echo "scale=2; ($CURR_RX - $PREV_RX) / $INTERVAL / 1024" | bc)
        TX_RATE=$(echo "scale=2; ($CURR_TX - $PREV_TX) / $INTERVAL / 1024" | bc)
        
        echo "$i $RX_RATE $TX_RATE" >> "$NET_FILE"
        
        # Update previous stats
        PREV_RX="$CURR_RX"
        PREV_TX="$CURR_TX"
    done
    
    # Calculate statistics
    if [[ -s "$NET_FILE" ]]; then
        NET_RX_AVG=$(awk '{ sum += $2 } END { print sum / NR }' "$NET_FILE")
        NET_TX_AVG=$(awk '{ sum += $3 } END { print sum / NR }' "$NET_FILE")
        NET_RX_MAX=$(awk 'BEGIN { max = 0 } { if ($2 > max) max = $2 } END { print max }' "$NET_FILE")
        NET_TX_MAX=$(awk 'BEGIN { max = 0 } { if ($3 > max) max = $3 } END { print max }' "$NET_FILE")
    else
        NET_RX_AVG=0
        NET_TX_AVG=0
        NET_RX_MAX=0
        NET_TX_MAX=0
    fi
}

# =========================================================================
# Analysis Functions
# =========================================================================

# Function to analyze CPU usage and identify bottlenecks
analyze_cpu() {
    echo -e "\n========== CPU Usage Analysis =========="
    echo "Average CPU usage: ${CPU_AVG}%"
    echo "Maximum CPU usage: ${CPU_MAX}%"
    echo "Minimum CPU usage: ${CPU_MIN}%"
    
    # Analyze CPU bottlenecks
    if (( $(echo "$CPU_MAX > 90" | bc -l) )); then
        echo -e "\n[CRITICAL] CPU BOTTLENECK DETECTED"
        echo "The CPU usage peaked above 90%, indicating severe CPU bottleneck."
        echo "This can cause system-wide slowdowns and unresponsive applications."
        echo "Recommendations:"
        echo "  - Identify and optimize CPU-intensive processes"
        echo "  - Consider distributing workload across multiple cores/threads"
        echo "  - Upgrade CPU if consistently at high utilization"
    elif (( $(echo "$CPU_AVG > 70" | bc -l) )); then
        echo -e "\n[WARNING] HIGH CPU UTILIZATION"
        echo "The average CPU usage is above 70%, indicating potential CPU pressure."
        echo "Recommendations:"
        echo "  - Monitor for performance degradation"
        echo "  - Review application code for CPU optimization opportunities"
        echo "  - Consider scaling horizontally if possible"
    else
        echo -e "\n[OK] CPU utilization is within acceptable limits."
    fi
}

# Function to analyze memory usage and identify bottlenecks
analyze_memory() {
    echo -e "\n========== Memory Usage Analysis =========="
    
    if [[ -n "$PROCESS_ID" ]]; then
        echo "Average memory usage: ${MEM_AVG} MB"
        echo "Maximum memory usage: ${MEM_MAX} MB"
        echo "Minimum memory usage: ${MEM_MIN} MB"
        
        # Analyze memory bottlenecks for process
        if (( $(echo "$MEM_MAX > 1024" | bc -l) )); then
            echo -e "\n[WARNING] HIGH MEMORY USAGE"
            echo "The process is using more than 1GB of memory at peak."
            echo "This might indicate memory inefficiency or potential memory leaks."
            echo "Recommendations:"
            echo "  - Check for memory leaks using tools like valgrind"
            echo "  - Review memory allocation patterns in the application"
            echo "  - Consider implementing memory pooling or garbage collection"
        fi
    else
        echo "Average memory usage: ${MEM_AVG}%"
        echo "Maximum memory usage: ${MEM_MAX}%"
        echo "Minimum memory usage: ${MEM_MIN}%"
        
        # Analyze memory bottlenecks for system
        if (( $(echo "$MEM_MAX > 90" | bc -l) )); then
            echo -e "\n[CRITICAL] MEMORY BOTTLENECK DETECTED"
            echo "The system memory usage peaked above 90%, indicating severe memory pressure."
            echo "This can cause excessive swapping and system slowdowns."
            echo "Recommendations:"
            echo "  - Identify memory-intensive processes and optimize them"
            echo "  - Increase system RAM"
            echo "  - Adjust swappiness parameter for better performance"
        elif (( $(echo "$MEM_AVG > 80" | bc -l) )); then
            echo -e "\n[WARNING] HIGH MEMORY UTILIZATION"
            echo "The average memory usage is above 80%, indicating potential memory pressure."
            echo "Recommendations:"
            echo "  - Monitor for increased swap activity"
            echo "  - Review application memory requirements"
        else
            echo -e "\n[OK] Memory utilization is within acceptable limits."
        fi
    fi
}

# Function to analyze disk I/O and identify bottlenecks
analyze_disk() {
    echo -e "\n========== Disk I/O Analysis =========="
    echo "Average disk read rate: ${DISK_READ_AVG} KB/s"
    echo "Maximum disk read rate: ${DISK_READ_MAX} KB/s"
    echo "Average disk write rate: ${DISK_WRITE_AVG} KB/s"
    echo "Maximum disk write rate: ${DISK_WRITE_MAX} KB/s"
    
    # Analyze disk I/O bottlenecks
    if (( $(echo "$DISK_READ_MAX > 50000" | bc -l) || $(echo "$DISK_WRITE_MAX > 50000" | bc -l) )); then
        echo -e "\n[CRITICAL] DISK I/O BOTTLENECK DETECTED"
        echo "Extremely high disk I/O rates detected, which can cause system-wide slowdowns."
        echo "Recommendations:"
        echo "  - Identify I/O-intensive processes"
        echo "  - Consider using SSD or NVMe storage"
        echo "  - Implement I/O scheduling optimizations"
        echo "  - Use caching mechanisms to reduce disk access"
    elif (( $(echo "$DISK_READ_AVG > 10000" | bc -l) || $(echo "$DISK_WRITE_AVG > 10000" | bc -l) )); then
        echo -e "\n[WARNING] HIGH DISK I/O ACTIVITY"
        echo "The average disk I/O rate is high, which may impact system performance."
        echo "Recommendations:"
        echo "  - Review application disk access patterns"
        echo "  - Consider implementing read/write caching"
        echo "  - Optimize database queries if applicable"
    else
        echo -e "\n[OK] Disk I/O activity is within acceptable limits."
    fi
}

# Function to analyze network usage and identify bottlenecks
analyze_network() {
    echo -e "\n========== Network Usage Analysis =========="
    echo "Average network receive rate: ${NET_RX_AVG} KB/s"
    echo "Maximum network receive rate: ${NET_RX_MAX} KB/s"
    echo "Average network transmit rate: ${NET_TX_AVG} KB/s"
    echo "Maximum network transmit rate: ${NET_TX_MAX} KB/s"
    
    # Analyze network bottlenecks
    if (( $(echo "$NET_RX_MAX > 100000" | bc -l) || $(echo "$NET_TX_MAX > 100000" | bc -l) )); then
        echo -e "\n[CRITICAL] NETWORK BOTTLENECK DETECTED"
        echo "Extremely high network traffic detected, which may saturate network bandwidth."
        echo "Recommendations:"
        echo "  - Identify network-intensive processes"
        echo "  - Implement traffic shaping or QoS"
        echo "  - Consider upgrading network infrastructure"
        echo "  - Optimize data transfer protocols"
    elif (( $(echo "$NET_RX_AVG > 50000" | bc -l) || $(echo "$NET_TX_AVG > 50000" | bc -l) )); then
        echo -e "\n[WARNING] HIGH NETWORK ACTIVITY"
        echo "The average network traffic is high, which may impact application responsiveness."
        echo "Recommendations:"
        echo "  - Review application network usage patterns"
        echo "  - Implement data compression"
        echo "  - Consider content delivery networks for static content"
    else
        echo -e "\n[OK] Network activity is within acceptable limits."
    fi
}

# Function to provide overall system health assessment
analyze_overall() {
    echo -e "\n========== Overall System Health Assessment =========="
    
    # Count the number of critical and warning issues
    CRITICAL_COUNT=0
    WARNING_COUNT=0
    
    # CPU assessment
    if (( $(echo "$CPU_MAX > 90" | bc -l) )); then
        CRITICAL_COUNT=$((CRITICAL_COUNT + 1))
    elif (( $(echo "$CPU_AVG > 70" | bc -l) )); then
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
    
    # Memory assessment
    if [[ -z "$PROCESS_ID" ]]; then
        if (( $(echo "$MEM_MAX > 90" | bc -l) )); then
            CRITICAL_COUNT=$((CRITICAL_COUNT + 1))
        elif (( $(echo "$MEM_AVG > 80" | bc -l) )); then
            WARNING_COUNT=$((WARNING_COUNT + 1))
        fi
    else
        if (( $(echo "$MEM_MAX > 1024" | bc -l) )); then
            WARNING_COUNT=$((WARNING_COUNT + 1))
        fi
    fi
    
    # Disk I/O assessment
    if (( $(echo "$DISK_READ_MAX > 50000" | bc -l) || $(echo "$DISK_WRITE_MAX > 50000" | bc -l) )); then
        CRITICAL_COUNT=$((CRITICAL_COUNT + 1))
    elif (( $(echo "$DISK_READ_AVG > 10000" | bc -l) || $(echo "$DISK_WRITE_AVG > 10000" | bc -l) )); then
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
    
    # Network assessment
    if (( $(echo "$NET_RX_MAX > 100000" | bc -l) || $(echo "$NET_TX_MAX > 100000" | bc -l) )); then
        CRITICAL_COUNT=$((CRITICAL_COUNT + 1))
    elif (( $(echo "$NET_RX_AVG > 50000" | bc -l) || $(echo "$NET_TX_AVG > 50000" | bc -l) )); then
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
    
    # Overall assessment
    if [[ $CRITICAL_COUNT -gt 0 ]]; then
        echo -e "\n[CRITICAL] SYSTEM PERFORMANCE ISSUES DETECTED"
        echo "The system is experiencing critical performance bottlenecks that require immediate attention."
        echo "Review the detailed analysis above for specific recommendations."
    elif [[ $WARNING_COUNT -gt 0 ]]; then
        echo -e "\n[WARNING] POTENTIAL PERFORMANCE ISSUES DETECTED"
        echo "The system is showing signs of performance pressure that should be monitored."
        echo "Review the detailed analysis above for specific recommendations."
    else
        echo -e "\n[OK] SYSTEM PERFORMANCE IS HEALTHY"
        echo "No significant performance bottlenecks were detected during the monitoring period."
    fi
}

# =========================================================================
# Main Execution
# =========================================================================

# Display header
echo "=========================================================="
echo "Performance Metrics Analysis"
echo "Duration: $DURATION seconds, Interval: $INTERVAL seconds"
if [[ -n "$PROCESS_ID" ]]; then
    echo "Monitoring process with PID: $PROCESS_ID"
else
    echo "Monitoring system-wide metrics"
fi
echo "=========================================================="

# Run monitoring functions
monitor_cpu
monitor_memory
monitor_disk
monitor_network

# Run analysis functions
analyze_cpu
analyze_memory
analyze_disk
analyze_network
analyze_overall

# Save results to file if specified
if [[ -n "$OUTPUT_FILE" ]]; then
    {
        echo "=========================================================="
        echo "Performance Metrics Analysis"
        echo "Duration: $DURATION seconds, Interval: $INTERVAL seconds"
        if [[ -n "$PROCESS_ID" ]]; then
            echo "Monitoring process with PID: $PROCESS_ID"
        else
            echo "Monitoring system-wide metrics"
        fi
        echo "=========================================================="
        
        echo -e "\n========== CPU Usage Analysis =========="
        echo "Average CPU usage: ${CPU_AVG}%"
        echo "Maximum CPU usage: ${CPU_MAX}%"
        echo "Minimum CPU usage: ${CPU_MIN}%"
        
        echo -e "\n========== Memory Usage Analysis =========="
        if [[ -n "$PROCESS_ID" ]]; then
            echo "Average memory usage: ${MEM_AVG} MB"
            echo "Maximum memory usage: ${MEM_MAX} MB"
            echo "Minimum memory usage: ${MEM_MIN} MB"
        else
            echo "Average memory usage: ${MEM_AVG}%"
            echo "Maximum memory usage: ${MEM_MAX}%"
            echo "Minimum memory usage: ${MEM_MIN}%"
        fi
        
        echo -e "\n========== Disk I/O Analysis =========="
        echo "Average disk read rate: ${DISK_READ_AVG} KB/s"
        echo "Maximum disk read rate: ${DISK_READ_MAX} KB/s"
        echo "Average disk write rate: ${DISK_WRITE_AVG} KB/s"
        echo "Maximum disk write rate: ${DISK_WRITE_MAX} KB/s"
        
        echo -e "\n========== Network Usage Analysis =========="
        echo "Average network receive rate: ${NET_RX_AVG} KB/s"
        echo "Maximum network receive rate: ${NET_RX_MAX} KB/s"
        echo "Average network transmit rate: ${NET_TX_AVG} KB/s"
        echo "Maximum network transmit rate: ${NET_TX_MAX} KB/s"
        
    } > "$OUTPUT_FILE"
    
    echo -e "\nResults saved to: $OUTPUT_FILE"
fi

echo -e "\nPerformance analysis complete."
