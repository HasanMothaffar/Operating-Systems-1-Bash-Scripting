#!/bin/bash

GLOBAL_DATABASE_FILENAME="" #maybe we should make a variable for the file name and another variable for the path
SCRIPT_PROMPT="
Q1 (first.os1db):
1) Backup the database
2) Restore a database
3) Enable automatic backups

Please enter a number from the list above, or (q) to quit:"
MODE=0
OUTPUTDIR=""
MAX=0

do
  case "$1" in
    --backup)       MODE=1       ; shift   ;;
    --restore)      MODE=2       ; shift   ;;
    --outputdir) OUTPUTDIR="/opt/backups" ; shift 2 ;;
    --max)          MAX=$2       ; shift 2 ;;
    -d | --delta)   DELTA="$2"   ; shift 2 ;;
    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;
    # If invalid options were passed, then getopt should have reported an error,
    # which we checked as VALID_ARGUMENTS when getopt was called...
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done

backup_database() {
    if [[ max != 0]]; then
        temp=""
        temp2=""
        cat /home/os1/backup.log >> temp
        echo ${temp#*-} >> temp2
        sudo zip $OUTPUTDIR/"$(($temp2%$MAX))" GLOBAL_DATABASE_FILENAME
        echo "$MAX-"$(($temp2+1))"" > /home/os1/backup.log 
    else
        read -p "Enter the backup name (with file extension .zip or .gz): " KEY
        if [[ "$KEY" =~ .*\.zip ]]; then
            echo "Using zip for backup (file has .zip extension)..."
            sudo zip /home/os1/${KEY%".zip"} GLOBAL_DATABASE_FILENAME #maybe put $2 here?
            echo "Backup done (/home/os1/$KEY)"
        elif [[ "$KEY" =~ .*\.gz ]]; then
        echo "Using gz for backup (file has .gz extension)..."
            tar -czvf ${KEY%".tgz"} GLOBAL_DATABASE_FILENAME
            echo "Backup done (/home/os1/$KEY)"
        fi
    fi
}

restore_database() {
    read -p "Enter the absolute path of the backup file: " KEY
    if [[ "$KEY" =~ .*\.zip ]]; then
        unzip $KEY -d GLOBAL_DATABASE_FILENAME
    elif [[ "$KEY" =~ .*\.gz ]]; then
        tar -zxvf $KEY -C GLOBAL_DATABASE_FILENAME
    fi
}
enable_automatic_backups(){
    read -p "Please enter your backup schedule (daily, weekly or monthly): " KEY1
    read -p "Max number of backup files to keep: " KEY2
    echo "$KEY-0" >> /home/os1/backup.log
    if [[ "$KEY" == "daily" ]]; then
        0 0 * * * /home/os1/q2.sh /home/os1/first.os1db --backup --outputdir /opt/backups --max $KEY2
    if [[ "$KEY" == "weekly" ]]; then
        0 0 * * 0 /home/os1/q2.sh /home/os1/first.os1db --backup --outputdir /opt/backups --max $KEY2
    if [[ "$KEY" == "monthly" ]]; then
        0 0 1 * * /home/os1/q2.sh /home/os1/first.os1db --backup --outputdir /opt/backups --max $KEY2
    fi
    echo "done"
}
