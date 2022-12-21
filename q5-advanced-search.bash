#!/bin/bash

USAGE="
Usage: ./my_script <place-to-search-from> [arg1 arg2 arg3 ...]

Examples:
- ./my_script / opt users_management.js b.txt

Searches for all files called users_mangement.js or b.txt 
starting from root (/) and displays the results."

if [ $# = 0 ] 
    then
    echo "$USAGE"
    exit
fi

function search_for_dirs_or_files() {
    args=("$@")
    ALL_ARGS_EXCEPT_FOR_FIRST_ONE=("${args[@]:1}")

    DIRECTORY_TO_START_SEARCHING_FORM="${args[0]}"
    FIND_EXPRESSION="find $DIRECTORY_TO_START_SEARCHING_FORM "

    # https://stackoverflow.com/questions/68881897/bash-get-last-index-of-array
    LAST_INDEX=$((${#ALL_ARGS_EXCEPT_FOR_FIRST_ONE[@]} - 1))

    # Why use parentheses? https://superuser.com/questions/387182/find-command-giving-different-outputs-with-without-print
    FIND_EXPRESSION+="\( "
    for i in "${!ALL_ARGS_EXCEPT_FOR_FIRST_ONE[@]}"; do
        FIND_EXPRESSION+="-name '${ALL_ARGS_EXCEPT_FOR_FIRST_ONE[$i]}'"
        if [ "$i" -ne "$LAST_INDEX" ] 
            then
            FIND_EXPRESSION+=" -o "
        fi
    done
    FIND_EXPRESSION+=" \)"


    # What is this weird -printf? https://unix.stackexchange.com/questions/353460/list-permissions-with-find-command
    SPACE="\\\t"
    SPECIAL_PRINT_FORMAT=" -printf %M$SPACE%m$SPACE%u$SPACE%g$SPACE%p\\\n"
    REDIRECT_ERROR_TO_NULL=" 2>/dev/null"
    
    FIND_EXPRESSION+="$SPECIAL_PRINT_FORMAT"
    FIND_EXPRESSION+="$REDIRECT_ERROR_TO_NULL"

    echo "Searching from: $DIRECTORY_TO_START_SEARCHING_FORM"
    echo ""
    RESULT=$(eval cacheme "$FIND_EXPRESSION")
    if [ -z "$RESULT" ]
        then
        echo "No results were found."
    else
        printf "Permissions\\tNumber\\tUser\\tGroup\\tName\\n"
        echo "--------------------------------------------"
        echo "$RESULT"
    fi
}

search_for_dirs_or_files "$@"
