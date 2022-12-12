#!/bin/bash

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

source db_init.bash

function encode_key() {
    key=$1
    echo "$key" | base64
}

function insert_key_value_record_to_file() {
    read -r -p "Enter key: " KEY
  
    # Only add new record if key doesn't exist before
    SEARCH_RESULT=$(grep -w  "$KEY" "$GLOBAL_DATABASE_FILENAME")
    if [ -z "$SEARCH_RESULT" ] 
        then 

        read -r -p "Enter value: " VALUE
        ENCODED_VALUE=$(encode_key "$VALUE")
        echo "$KEY: $ENCODED_VALUE" >> "$GLOBAL_DATABASE_FILENAME"
        echo "Added key $KEY succesfully!"
    else
        echo "Key $KEY already exists in the database"
    fi
}

function delete_record_by_key() {
    read -r -p "Enter the key that you want to delete its record: " KEY

    KEY_LINE_NUMBER=$(grep -n -w "$KEY" "$GLOBAL_DATABASE_FILENAME" | cut -d : -f 1)
        if [ -z "$KEY_LINE_NUMBER" ] 
            then 
            echo "Key $KEY does not exist in the database"
        else
            # Delete line containing key
            sed -i "${KEY_LINE_NUMBER}d" "$GLOBAL_DATABASE_FILENAME"
            echo "Key $KEY deleted successfully!"
        fi

}

function search_for_record_by_key() {
    read -r -p "Enter the key that you want to search for: " KEY

    # Search for words matching KEY, ignore casing
    SEARCH_RESULT=$(grep -i -w  "$KEY" "$GLOBAL_DATABASE_FILENAME")
    if [ -z "$SEARCH_RESULT" ] 
        then 
        echo "No result was found for $KEY"
    else
        echo "$SEARCH_RESULT"
    fi
}

function update_record() {
    read -r -p "Enter the key for the record you want to edit : " KEY

    KEY_LINE_NUMBER=$(grep -n -w "$KEY" "$GLOBAL_DATABASE_FILENAME" | cut -d : -f 1)
        if [ -z "$KEY_LINE_NUMBER" ] 
            then 
            echo "Key $KEY does not exist in the database"
        else
            # Replace line containing key
            read -r -p "Enter the new value: " VALUE
            NEW_ENCODED_VALUE=$(encode_key "$VALUE")
            sed -i "${KEY_LINE_NUMBER}s/.*/${KEY}: ${NEW_ENCODED_VALUE}/" "$GLOBAL_DATABASE_FILENAME"
            echo "Key $KEY modified successfully!"
        fi
}

function main_loop() {
    OPTION=""

    while [ "$OPTION" != "5" ]
    do
        read -r -p "$QUESTION_PROMPT" OPTION
        clear
        
        case $OPTION in
            1)
            insert_key_value_record_to_file
            ;;
            2)
            delete_record_by_key
            ;;
            3)
            search_for_record_by_key
            ;;
            4)
            update_record
            ;;
            5)
            echo "Exit"
            exit 0
            ;;
            *)
            echo "🤔 Unknown key."
            ;;
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