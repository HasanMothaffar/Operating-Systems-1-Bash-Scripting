function encode_key() {
    key=$1
    echo "$key" | base64
}

function write_info_to_db_file() {
    echo "version 1 $USER" > "$1"
}

function create_database() {
    if [ -e "$1" ]
        then echo "⚠️  Database $1 already exists. The program will use this file"
    else 
        touch "$1"
        write_info_to_db_file "$1"
        echo "✅ Database file $1 created successfully"
    fi
}

function initialize_database() {
    GLOBAL_DATABASE_FILENAME=""
    
    # Usage: ./my_script.sh --create db-name
    if [ "$1" = "--create" ] 
    then 
        create_database "$2"
        
        GLOBAL_DATABASE_FILENAME="$2"

    # Usage: ./my_script.sh  existing-db-name
    elif [ -e "$1" ]
    then
        echo "✅ Database file recognized: $1"
        GLOBAL_DATABASE_FILENAME="$1"
    else 
        echo "ERROR ❌: Please provide a valid database file"
        exit 1
    fi

    export GLOBAL_DATABASE_FILENAME
}

function insert_key_value_record_to_file() {
    read -r -p "Enter key: " KEY
    
    if [[ "$KEY" = *:* ]]
        then 
        echo "Key contains the colon (:) character, which is disallowed. Please enter another key"
        return 1
    fi
    

    # Only add new record if key doesn't exist before
    SEARCH_RESULT=$(grep -w "$KEY :" "$GLOBAL_DATABASE_FILENAME")
    if [ -z "$SEARCH_RESULT" ] 
        then 

        read -r -p "Enter value: " VALUE
        ENCODED_VALUE=$(encode_key "$VALUE")
        echo "$KEY : $ENCODED_VALUE" >> "$GLOBAL_DATABASE_FILENAME"
        echo "Added key $KEY succesfully!"
    else
        echo "Key $KEY already exists in the database"
    fi
}

function delete_record_by_key() {
    read -r -p "Enter the key that you want to delete its record: " KEY

    KEY_LINE_NUMBER=$(grep -n -w "$KEY :" "$GLOBAL_DATABASE_FILENAME" | cut -d : -f 1)
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
    SEARCH_RESULT=$(grep -i "$KEY :" "$GLOBAL_DATABASE_FILENAME")
    if [ -z "$SEARCH_RESULT" ] 
        then 
        echo "No result was found for $KEY"
    else
        # Get everything before :*
        KEY=${SEARCH_RESULT% :*}

        # Get everything after *:
        ENCODED_VALUE=${SEARCH_RESULT#*: }

        DECODED_VALUE=$(echo "$ENCODED_VALUE" | base64 -d)
        echo "$KEY : $DECODED_VALUE"
    fi
}

function update_record() {
    read -r -p "Enter the key for the record you want to edit : " KEY

    KEY_LINE_NUMBER=$(grep -n -w "$KEY :" "$GLOBAL_DATABASE_FILENAME" | cut -d : -f 1)
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