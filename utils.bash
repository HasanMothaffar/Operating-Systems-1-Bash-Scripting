# Reference: https://stackoverflow.com/questions/878600/how-to-create-a-cron-job-using-bash-automatically-without-the-interactive-editor
function __register_cronjob() {
    CRONJOB="$1"

    crontab -l > current_cronjobs.txt
    echo "$CRONJOB" >> current_cronjobs.txt

    crontab current_cronjobs.txt
    echo "Added cronjob: $CRONJOB successfully!"

    # rm because the current cron jobs get written to a local file in the invoking directory
    rm current_cronjobs.txt
}

# Sorry for duplication, but I'm afraid I might break the project :(
# Tomorrow's the deadline!
function __get_file_fullpath() {
    BASENAME=$( basename -- "$1" )
    WORKING_DIRECTORY=$( pwd )
    FULL_PATH="${WORKING_DIRECTORY}/${BASENAME}"

    echo "$FULL_PATH"
}

function __get_script_fullpath() {
    BASENAME=$( basename -- "$0" )
    WORKING_DIRECTORY=$( pwd )
    FULL_PATH="${WORKING_DIRECTORY}/${BASENAME}"

    echo "$FULL_PATH"
}
