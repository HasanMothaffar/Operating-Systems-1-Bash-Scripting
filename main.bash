#!/bin/bash

source init.bash

PROJECT_PROMPT="
Select the question that you want to execute:
1) Interaction With Database
2) Database Backups
3) System Monitoring
4) FTP Server
5) ???
6) Exit Script
"

function project_main_loop() {
    initialize_database "$1" "$2"

    while [ "$OPTION" != "6" ]
    do
        read -r -p "$PROJECT_PROMPT" OPTION
        clear
        
        case $OPTION in
            1)
            ./q1-database-interaction.bash
            ;;
            2)
            ./q2-database-backup.bash
            ;;
            3)
            ./q3-system-monitoring.bash
            ;;
            4)
            ./q4-ftp-server.bash
            ;;
            5)
            echo "😢 hmmm."
            ;;
            6)
            echo "😢 Exiting Script"
            ;;
            *)
            echo "🤔 Unknown key"
            ;;
        esac
    done
}

project_main_loop "$@"