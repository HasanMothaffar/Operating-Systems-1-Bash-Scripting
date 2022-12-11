#!/bin/bash

GLOBAL_DATABASE_FILENAME=""

function write_project_version_to_database() {
    echo "VERSION 1 (OS 1)" > "$GLOBAL_DATABASE_FILENAME"
}

function create_database() {
    GLOBAL_DATABASE_FILENAME="$1"

    if [ -e "$GLOBAL_DATABASE_FILENAME" ]
        then echo "⚠️  Database $GLOBAL_DATABASE_FILENAME already exists. The program will use this file"
    else 
        touch "$GLOBAL_DATABASE_FILENAME"
        write_project_version_to_database
        echo "✅ Database file $GLOBAL_DATABASE_FILENAME created successfully"
    fi
}

function initialize_database() {
    # Usage: ./my_script.sh --create db-name
    if [ "$1" = "--create" ] 
    then 
        create_database "$2"

    # Usage: ./my_script.sh  existing-db-name
    elif [ -e "$1" ]
    then
        GLOBAL_DATABASE_FILENAME="$1"
        echo "✅ Database file recognized: $GLOBAL_DATABASE_FILENAME"
    else 
        echo "ERROR ❌: Please provide a valid database file"
        exit 1
    fi
}