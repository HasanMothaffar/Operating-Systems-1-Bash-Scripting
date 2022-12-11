source core.bash

function encode_key() {
    key=$1
    echo "$key" | base64
}

function insert_key_value_record_to_file() {
    read -r -p "Enter key: " KEY
    read -r -p "Enter value: " VALUE
  
    # if key already exists return

    ENCODED_VALUE=$(encode_key "$VALUE")
    echo "$KEY: $ENCODED_VALUE" >> "$GLOBAL_DATABASE_FILENAME"
}

function delete_record_by_key() {
  read -r -p "Enter the key that you want to delete its record: " KEY
  # if key doesn't exist return BRO I NEED VALID KEYS
  # else delete record peacefully
}

function search_for_record_by_key() {
  read -r -p "Enter the key that you want to serach for: " KEY
  # return grep magic
}

function main_loop() {
    OPTION=""

    while [ "$OPTION" != "5" ]
    do
        read -r -p "$SCRIPT_PROMPT" OPTION
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
            echo "😢 Exiting program."
            exit 0
            ;;
            *)
            echo "🤔 Uknown key."
            ;;
        esac

   
    done
}

initialize_database "$1" "$2"

SCRIPT_PROMPT="
Q1 ($GLOBAL_DATABASE_FILENAME):
1) Add a new record
2) Delete a record
3) Search for a record
4) Update a record
5) Exit

Please enter a number from the list above: "

main_loop