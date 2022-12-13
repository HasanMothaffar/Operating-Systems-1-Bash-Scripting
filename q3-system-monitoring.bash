#!/bin/bash

MONITORING_RESULTS_FILE="/opt/monitoring.txt"

function write_current_date_monitoring_file() {
    DATE=$(date | grep -o "[A-Z][a-z][a-z].[0-9][0-9]")
    echo "$DATE" >> "$MONITORING_RESULTS_FILE"
}

function main() {
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

function register_cronjob() {
    # https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
    BASENAME=$( basename -- "$0" )
    WORKING_DIRECTORY=$( pwd )
    FULL_PATH="${WORKING_DIRECTORY}/${BASENAME}"

    crontab -l > CURRENT_CRONJOBS_FILE

    Q3_CRONJOB="0 0 * * * $FULL_PATH"
    echo "$Q3_CRONJOB" >> CURRENT_CRONJOBS_FILE

    crontab CURRENT_CRONJOBS_FILE

    # rm because the current cron jobs get written to a local file in the invoking directory
    rm CURRENT_CRONJOBS_FILE

}

# register_cronjob "$@"
main