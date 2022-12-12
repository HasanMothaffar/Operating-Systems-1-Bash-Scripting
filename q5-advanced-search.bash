
function search_for_dirs_or_files_without_multithreading() {
    # Usage: ./my_script place-to-search-from arg1 arg2 arg3
    # E.g. ./my_script / opt users_management.js another-file
    
    args=("$@")
    ALL_ARGS_EXCEPT_FOR_FIRST_ONE=("${args[@]:1}")

    DIRECTORY_TO_START_SEARCHING_FORM="${args[0]}"
    FIND_EXPRESSION="find $DIRECTORY_TO_START_SEARCHING_FORM "

    # I hate bash: https://stackoverflow.com/questions/68881897/bash-get-last-index-of-array
    LAST_INDEX=$((${#ALL_ARGS_EXCEPT_FOR_FIRST_ONE[@]} - 1))

    for i in "${!ALL_ARGS_EXCEPT_FOR_FIRST_ONE[@]}"; do
        FIND_EXPRESSION+="-name ${ALL_ARGS_EXCEPT_FOR_FIRST_ONE[$i]}"
        if [ "$i" -ne "$LAST_INDEX" ] 
            then
            FIND_EXPRESSION+=" -o "
        fi
    done

    SPECIAL_PRINT_FORMAT=" -printf %M\" \"%m\" User: \"%u/\" Group:\"%g/\" Name:\"%p\\\n"
    REDIRECT_ERROR_TO_NULL=" 2>/dev/null"
    
    FIND_EXPRESSION+="$SPECIAL_PRINT_FORMAT"
    FIND_EXPRESSION+="$REDIRECT_ERROR_TO_NULL"

    echo "Searching from: $DIRECTORY_TO_START_SEARCHING_FORM"
    echo "Final expression: $FIND_EXPRESSION"
    echo ""
    eval "$FIND_EXPRESSION"

    
    # # https://unix.stackexchange.com/questions/353460/list-permissions-with-find-command
    # cacheme find -name "opt" -printf "Permissions="%M\\t"User="%u" Group="%g\\t"Path="%p\\n 2>/dev/null
}

search_for_dirs_or_files_pseudocode "$@"