find -name "*.txt" -o -name "*.js"

function search_for_dirs_or_files_pseudocode() {
    arguments_array=$@
    
    directory_to_start_searching_from = arguments_array[0]

    arguments_array.remove(firstItem)

    find_expression = "";

    foreach (arg in arguments_array) {
        find_expression += "-name $arg"

        if (find_expression is not last) find_expression += " -o "
    }

    find $directory_to_start_searching_from $find_expression
}
