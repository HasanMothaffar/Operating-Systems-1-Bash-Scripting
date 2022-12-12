#!/bin/bash

# should add "0 0 * * * /home/os1/q3-system-monitoring.bash" to crontab

DATE=$(date | grep -o [A-Z][a-z][a-z].[0-9][0-9])
echo $DATE >>/opt/monitoring.txt

for ((i = 0; i < 720; i++)); do
    #there's 720 5sec in an hour cron will execute the command and sleep with for-loop will rexecute
    echo "RAM, Disk, CPU" >>/opt/monitoring.txt
    DSK=$(df . | grep -o [^s].%)
    RAM=$(free | grep Mem | awk '{print $3/$2 * 100}')
    RAM=$(printf "%.0f" "$RAM")
    RAM="$RAM%"
    CPU=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) ; }' \
        <(grep 'cpu ' /proc/stat) <(
            sleep 1
            grep 'cpu ' /proc/stat
        ))
    CPU=$(printf "%.0f" "$CPU")
    CPU="$CPU%"
    echo "$RAM, $DSK, $CPU" >>/opt/monitoring.txt
    sleep 4
done
