# Performance Metrics Analysis Tool

This repository contains a bash script for monitoring and analyzing system performance metrics to identify potential bottlenecks and resource usage patterns.

## Features

The performance metrics script provides comprehensive monitoring and analysis of:

- **CPU Usage**: Monitors CPU utilization and identifies CPU bottlenecks
- **Memory Usage**: Tracks memory consumption and detects memory pressure
- **Disk I/O**: Measures disk read/write rates and identifies I/O bottlenecks
- **Network Activity**: Monitors network traffic and identifies bandwidth issues

## Usage

```bash
./performance_metrics.sh [options]
```

### Options

- `-d, --duration SECONDS`: Duration of monitoring in seconds (default: 60)
- `-i, --interval SECONDS`: Sampling interval in seconds (default: 5)
- `-p, --process PID`: Monitor specific process ID
- `-n, --name PROCESS_NAME`: Monitor specific process by name
- `-o, --output FILE`: Save results to file
- `-h, --help`: Display help message

### Examples

Monitor system-wide metrics for 2 minutes with 10-second intervals:
```bash
./performance_metrics.sh --duration 120 --interval 10
```

Monitor a specific process by PID:
```bash
./performance_metrics.sh --process 1234
```

Monitor a specific process by name:
```bash
./performance_metrics.sh --name "firefox"
```

Save results to a file:
```bash
./performance_metrics.sh --output performance_report.txt
```

## Performance Bottlenecks Analysis

The script analyzes the collected metrics and identifies potential bottlenecks:

### CPU Bottlenecks

- **Critical**: CPU usage peaks above 90%
- **Warning**: Average CPU usage above 70%

### Memory Bottlenecks

- **Critical**: Memory usage peaks above 90%
- **Warning**: Average memory usage above 80%
- For specific processes, warnings are issued for memory usage above 1GB

### Disk I/O Bottlenecks

- **Critical**: Disk read/write rates above 50,000 KB/s
- **Warning**: Average disk read/write rates above 10,000 KB/s

### Network Bottlenecks

- **Critical**: Network traffic above 100,000 KB/s
- **Warning**: Average network traffic above 50,000 KB/s

## Testing

A test script (`test_performance.sh`) is included to generate sample workloads for testing the performance metrics script:

```bash
./test_performance.sh
```

This will generate CPU, memory, and disk I/O load to demonstrate how the performance metrics script identifies bottlenecks.

## Requirements

- Bash shell
- Common Unix utilities: `ps`, `top`, `free`, `awk`, `grep`, `bc`

## License

This project is open source and available under the MIT License.