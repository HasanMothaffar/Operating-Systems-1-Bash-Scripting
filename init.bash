function write_project_version_to_database() {
    echo "VERSION 1 (OS 1)" > "$1"
}

function create_database() {
    if [ -e "$1" ]
        then echo "⚠️  Database $1 already exists. The program will use this file"
    else 
        touch "$1"
        write_project_version_to_database "$1"
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