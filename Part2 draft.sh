#!/bin/bash

GLOBAL_DATABASE_FILENAME=""
SCRIPT_PROMPT="
Q1 (first.os1db):
1) Backup the database
2) Restore a database
3) Enable automatic backups

Please enter a number from the list above, or (q) to quit:"

backup_database() {
    read -p "Enter the backup name (with file extension .zip or .gz): " KEY
    if [[ "$KEY" =~ .*\.zip ]]; then
        echo "Using zip for backup (file has .zip extension)..."
        sudo zip /home/os1/${KEY%".zip"} GLOBAL_DATABASE_FILENAME
        echo "Backup done (/home/os1/$KEY)"
    elif [[ "$KEY" =~ .*\.gz ]]; then
    echo "Using gz for backup (file has .gz extension)..."
        tar -czvf ${KEY%".tgz"} GLOBAL_DATABASE_FILENAME
        echo "Backup done (/home/os1/$KEY)"
    fi
}

Restore_database() {
    read -p "Enter the absolute path of the backup file: " KEY
    if [[ "$KEY" =~ .*\.zip ]]; then
        unzip $KEY -d GLOBAL_DATABASE_FILENAME
    elif [[ "$KEY" =~ .*\.gz ]]; then
        tar -zxvf $KEY -C GLOBAL_DATABASE_FILENAME
    fi
}
