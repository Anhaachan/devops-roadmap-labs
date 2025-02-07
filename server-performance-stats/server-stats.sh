#!/bin/bash

# Function to display the server performance stats
display_stats() {
    echo "========================================="
    echo "      Server Performance Stats           "
    echo "========================================="

    # 1. Total CPU usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
    echo "Total CPU Usage: $cpu_usage"

    # 2. Total memory usage (Free vs Used including percentage)
    memory_usage=$(free -m | awk 'NR==2{printf "Used: %sMB (%.2f%%), Free: %sMB\n", $3, $3*100/$2, $4}')
    echo "Memory Usage: $memory_usage"

    # 3. Total disk usage (Free vs Used including percentage)
    disk_usage=$(df -h / | awk 'NR==2{printf "Used: %s (%.2f%%), Free: %s\n", $3, $3*100/$2, $4}')
    echo "Disk Usage: $disk_usage"

    # 4. Top 5 processes by CPU usage
    echo "Top 5 Processes by CPU Usage:"
    ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head -n 6

    # 5. Top 5 processes by memory usage
    echo "Top 5 Processes by Memory Usage:"
    ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%mem | head -n 6

    # Stretch goal: Additional stats
    echo "-----------------------------------------"
    echo "Additional Stats:"
    # OS Version
    os_version=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d '"' -f 2)
    echo "OS Version: $os_version"

    # Uptime
    uptime_stats=$(uptime -p)
    echo "Uptime: $uptime_stats"

    # Load Average
    load_avg=$(uptime | awk -F 'load average:' '{print $2}')
    echo "Load Average: $load_avg"

    # Logged in users
    logged_in_users=$(who | wc -l)
    echo "Logged in Users: $logged_in_users"

    # Failed login attempts
    failed_logins=$(lastb | wc -l)
    echo "Failed Login Attempts: $failed_logins"

    echo "========================================="
}

# Execute the function
display_stats
