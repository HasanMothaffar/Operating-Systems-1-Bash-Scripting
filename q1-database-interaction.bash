#!/bin/bash

source db_core.bash

USAGE="
Usage: ./q1-database-interaction.bash [--create] <dbname>

Examples:
- ./q1-database-interaction.bash --create os1.db (Creates os1.db if it doesn't exist or uses it)
- ./q1-database-interaction.bash  os1.db (Uses the existing db os1.db)
"

if [ $# = 0 ] 
    then
    echo "$USAGE"
    exit
fi

function main_loop() {
    OPTION=""

    while [ "$OPTION" != "5" ]
    do
        read -r -p "$QUESTION_PROMPT" OPTION
        
        case $OPTION in
            1) insert_key_value_record_to_file;;
            2) delete_record_by_key;;
            3) search_for_record_by_key;;
            4) update_record;;
            5)
            echo "Exit"
            exit 0
            ;;
            *)
            echo "🤔 Unknown key.";;
        esac
    done
}

initialize_database "$1" "$2"

QUESTION_PROMPT="
Q1 ($GLOBAL_DATABASE_FILENAME):
1) Add a new record
2) Delete a record
3) Search for a record
4) Update a record
5) Back to main program

Please enter a number from the list above: "

main_loop