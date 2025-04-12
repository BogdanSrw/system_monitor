#!/bin/bash


# Define the threshold values for CPU, memory, and disk usage (in percentage)

CPU_LIMIT=90
MEMORY_LIMIT=90
DISK_LIMIT=90


# Function to send an alert

send_alert() {
    echo "$(tput setaf 1)ALERT: $1 usage exceeded Limit! Current value: $2%$(tput sgr0)"
    echo "$(date "+%Y-%m-%d %H:%M:%S") ALERT: $1 usage exceeded Limit! Current value: $2%" >> metrics.log
}


while true; do
    
    clear
    #display current stats

    echo "Resource Usage:"
    echo "CPU: $cpu_usage%"
    echo "Memory: $memory_usage%"
    echo "Disk: $disk_usage%"
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") CPU: $cpu_usage% \t Memory: $memory_usage% \t Disk: $disk_usage%" >> metrics.log
    # Monitor CPU usage

    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    cpu_usage=${cpu_usage%.*} # Convert to integer
    
    if ((cpu_usage >= CPU_LIMIT)); then
        send_alert "CPU" "$cpu_usage"
    fi

    # Monitor memory usage

    memory_usage=$(free | awk '/Mem/ {printf("%3.1f", ($3/$2) * 100)}')
    memory_usage=${memory_usage%.*}
    
    if ((memory_usage >= MEMORY_LIMIT)); then
        send_alert "Memory" "$memory_usage"
    fi

    # Monitor disk usage

    disk_usage=$(df -h / | awk '/\// {print $(NF-1)}')
    disk_usage=${disk_usage%?} # Remove the % sign
    
    if ((disk_usage >= DISK_LIMIT)); then
        send_alert "Disk" "$disk_usage"
    fi

    sleep 2
    
done
