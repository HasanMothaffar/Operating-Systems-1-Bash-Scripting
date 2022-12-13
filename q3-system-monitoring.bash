#!/bin/bash

source utils.bash

MONITORING_RESULTS_FILE="/opt/monitoring.txt"

function write_current_date_monitoring_file() {
    DATE=$(date | grep -o "[A-Z][a-z][a-z].[0-9][0-9]")
    echo "$DATE" >> "$MONITORING_RESULTS_FILE"
}

function main() {
    echo "Starting monitoring job..."
    write_current_date_monitoring_file

    ONE_HOUR_IN_SECONDS=3600
    SCRIPT_RUNNING_INTERVAL_IN_SECONDS=5
    ITERATIONS_COUNT=$((ONE_HOUR_IN_SECONDS / SCRIPT_RUNNING_INTERVAL_IN_SECONDS))

    for ((i = 0; i < ITERATIONS_COUNT; i++)); do
        #there's 720 5sec in an hour cron will execute the command and sleep with for-loop will rexecute
        
        DISK_USAGE=$(df . | grep -o "[^s].%")

        RAM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100}')
        RAM_USAGE=$(printf "%.0f" "$RAM_USAGE")
        RAM_USAGE="$RAM_USAGE%"

        CPU_USAGE=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) ; }' \
            <(grep 'cpu ' /proc/stat) <(
                sleep 1
                grep 'cpu ' /proc/stat
            ))
        CPU_USAGE=$(printf "%.0f" "$CPU_USAGE")
        CPU_USAGE="$CPU_USAGE%"

        echo "RAM, DISK, CPU" >> "$MONITORING_RESULTS_FILE"
        echo "$RAM_USAGE, $DISK_USAGE, $CPU_USAGE" >> "$MONITORING_RESULTS_FILE"

        sleep $SCRIPT_RUNNING_INTERVAL_IN_SECONDS
    done
}

function register_monitoring_cronjob() {
    # https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
    SCRIPT_PATH=$(__get_script_fullpath)

    Q3_CRONJOB="0 0 * * * $SCRIPT_PATH"
    __register_cronjob "$Q3_CRONJOB"
}

register_monitoring_cronjob
# main