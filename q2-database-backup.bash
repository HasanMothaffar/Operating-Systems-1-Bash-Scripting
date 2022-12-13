#!/bin/bash

source utils.bash

USAGE="
./q2-database-backup.bash [--backup] | [--max MAX_NUMBER_OF_BACKUPS]
"

if [ $# = 0 ] 
    then
    echo "$USAGE"
    exit
fi

# ARGS
AUTOMATIC_BACKUP=false
BACKUP_DIR=""
MAX_NUMBER_OF_BACKUPS=0

# VARS LOCAL TO THIS SCRIPT
DATABASE_FILENAME=""

function manually_backup_database() {
    read -r -p "Enter the backup name (with file extension .zip or .tar.gz): " BACKUP_FILENAME

    if [[ "$BACKUP_FILENAME" =~ .*\.zip ]]; then
        echo "Using zip for backup (file has .zip extension)..."
        zip "$BACKUP_FILENAME" "$DATABASE_FILENAME"

    elif [[ "$BACKUP_FILENAME" =~ .*\.tar.gz ]]; then
        echo "Using gz for backup (file has .gz extension)..."
        tar -czf "$BACKUP_FILENAME" "$DATABASE_FILENAME"
    fi

    echo "Backup done ($BACKUP_FILENAME)"
}

function automatically_backup_database() {
    BACKUPS_COUNT=$(ls /opt/backups | wc -l)
    
    if [ "$BACKUPS_COUNT" -ge "$MAX_NUMBER_OF_BACKUPS" ]
        then
        # Remove file with oldest modified date
        rm /opt/backups/"$(ls /opt/backups -t | tail -1)"
    fi

    # https://stackoverflow.com/questions/1401482/yyyy-mm-dd-format-date-in-shell-script
    DATE=$(date '+%Y-%m-%d_%H:%M:%S')
    sudo zip "$BACKUP_DIR/${DATE}_${DATABASE_FILENAME}.zip" "$DATABASE_FILENAME"
}

function restore_database_from_path() {
    read -r -p "Enter the backup name (with file extension .zip or .tar.gz): " FILEPATH
    
    # The target directory after uncompressing the file will be the current working directory (i.e. '.')
    # Therefore, the `unzip` or `tar` commands will prompt you if you want to replace the db file after uncompressing
    if [[ "$FILEPATH" =~ .*\.zip ]]; then
        unzip "$FILEPATH"
    elif [[ "$FILEPATH" =~ .*\.tar\.gz ]]; then
        tar -zxf "$FILEPATH"
    fi
}

function enable_automatic_backups() {
    read -r -p "Please enter your backup schedule (daily, weekly or monthly): " BACKUP_SCHEDULE
    read -r -p "Max number of backup files to keep: " MAX_NUMBER_OF_BACKUPS

    CRONJOB_SCHEDULE=""

    if [[ "$BACKUP_SCHEDULE" == "daily" ]]; then CRONJOB_SCHEDULE="0 0 * * *"
    elif [[ "$BACKUP_SCHEDULE" == "weekly" ]]; then CRONJOB_SCHEDULE="0 0 * * 0"
    elif [[ "$BACKUP_SCHEDULE" == "monthly" ]]; then CRONJOB_SCHEDULE="0 0 1 * *"
    fi

    SCRIPT_PATH=$(__get_script_fullpath)

    # Sorry for hardcoding :(
    HARDCODED_DB_PATH="/mnt/d/my-projects/operating-systems-y4t1/$DATABASE_FILENAME"
    CRONJOB="$CRONJOB_SCHEDULE $SCRIPT_PATH $HARDCODED_DB_PATH --backup /opt/backups --max $MAX_NUMBER_OF_BACKUPS"
    
    __register_cronjob "$CRONJOB"
}

function parse_commandline_arguments() {
    while [ $# -gt 0 ]; do
        case "$1" in
        *db)
            DATABASE_FILENAME=$1
            shift
            ;;
        --backup)
            AUTOMATIC_BACKUP=true
            BACKUP_DIR="$2"
            shift 2
            ;;
        --max)
            MAX_NUMBER_OF_BACKUPS=$2
            shift 2 # Because we will read '--max' and the argument directly after it, which is the actual number ($2)
            ;;
        *)
            echo "Invalid argument: $1"
            exit
            ;;
        esac
    done
}

function main() {
    SCRIPT_PROMPT="
Q2 backup / restore ($DATABASE_FILENAME):
1) Backup the database
2) Restore a database
3) Enable automatic backups
4) Exit
Please select one of the options above: "

    if [ $AUTOMATIC_BACKUP = true ]; then automatically_backup_database
    else
        while true; do
            read -r -p "$SCRIPT_PROMPT" OPTION
            case $OPTION in
            1) manually_backup_database ;;
            2) restore_database_from_path ;;
            3) enable_automatic_backups ;;
            4)
                echo "Exiting program."
                exit 0
                ;;
            *) echo "Unknown key." ;;
            esac
        done
    fi
}

parse_commandline_arguments "$@"
main "$@"