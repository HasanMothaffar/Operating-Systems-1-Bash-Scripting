#!/bin/bash

#executing this will automatically activate SCRIPT_PROMPT cli and then it's pretty straight forward just as the homework says

MODE=0                                 #--backup will set to 1 --restore will set 2
OUTPUTDIR=""                           #--outputdir to set auto backup output path
MAX=0                                  #--max to set max files to auto backup


function backup_database() {
    if [[ MAX -gt 0 ]]; then
        temp=$(cat /home/os1/backup.log)
        temp2=${temp#*-}
        sudo zip "$OUTPUTDIR/$(($temp2 % $MAX))" "$GLOBAL_DATABASE_FILENAME"
        echo "$MAX-"$(($temp2 + 1))"" | tee /home/os1/backup.log
    else
        read -p "Enter the backup name (with file extension .zip or .tar.gz): " KEY
        if [[ "$KEY" =~ .*\.zip ]]; then
            echo "Using zip for backup (file has .zip extension)..."
            ip /home/os1/"${KEY%".zip"}" "$GLOBAL_DATABASE_FILENAME"
            echo "Backup done (/home/os1/$KEY)"
        elif [[ "$KEY" =~ .*\.tar.gz ]]; then
            echo "Using gz for backup (file has .gz extension)..."
            tar -czf "/home/os1/$KEY" "$GLOBAL_DATABASE_FILENAME"
            echo "Backup done (/home/os1/$KEY)"
        fi
    fi
}

function restore_database() {
    read -r -p "Enter the absolute path of the backup file: " PATH

    if [[ "$PATH" =~ .*\.zip ]]; then
        unzip "$PATH"
    elif [[ "$PATH" =~ .*\.tar\.gz ]]; then
        tar -zxf "$PATH"
    fi
}

function enable_automatic_backups() {
    >/home/os1/backup.log
    read -p "Please enter your backup schedule (daily, weekly or monthly): " KEY1
    read -p "Max number of backup files to keep: " KEY2
    echo "$KEY2-0" | tee /home/os1/backup.log
    crontab -l >POPCRON
    if [[ "$KEY1" == "daily" ]]; then
        echo "0 0 * * * /home/os1/q2.sh /home/os1/first.os1db --backup --outputdir /opt/backups --max $KEY2" >>POPCRON
        echo "Adding(0 0 * * * /home/os1/q2.sh /home/os1/first.os1db --backup --outputdir /opt/backups --max $KEY2)"
    elif [[ "$KEY1" == "weekly" ]]; then
        echo "0 0 * * 0 /home/os1/q2.sh /home/os1/first.os1db --backup --outputdir /opt/backups --max $KEY2" >>POPCRON
        echo "Adding(0 0 * * 0 /home/os1/q2.sh /home/os1/first.os1db --backup --outputdir /opt/backups --max $KEY2)"
    elif [[ "$KEY1" == "monthly" ]]; then
        echo "0 0 1 * * /home/os1/q2.sh /home/os1/first.os1db --backup --outputdir /opt/backups --max $KEY2" >>POPCRON
        echo "Adding(0 0 1 * * /home/os1/q2.sh /home/os1/first.os1db --backup --outputdir /opt/backups --max $KEY2)"
    fi
    echo "done"
}

while [ $# -gt 0 ]; do
    case "$1" in
    *db)
        GLOBAL_DATABASE_FILENAME=$1
        shift
        ;;
    --backup)
        MODE=1
        shift
        ;;
    --restore)
        MODE=2
        shift
        ;;
    --outputdir)
        OUTPUTDIR="/opt/backups"
        shift 2
        ;;
    --max)
        MAX=$2
        shift 2
        ;;
    esac
done

if [[ MAX -eq 0 ]]; then
    while true; do
        read -r -p "$SCRIPT_PROMPT" PREF
        case $PREF in
        1) backup_database ;;
        2) restore_database ;;
        3) enable_automatic_backups ;;
        4)
            echo "Exiting program."
            exit 0
            ;;
        *) echo "Unknown key." ;;
        esac
    done
else
    case $MODE in
    1) backup_database ;;
    2) restore_database ;;
    esac
fi
