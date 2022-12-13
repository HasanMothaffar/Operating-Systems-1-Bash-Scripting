function __register_cronjob() {
    CRONJOB="$1"

    crontab -l > current_cronjobs.txt
    echo "$CRONJOB" >> current_cronjobs.txt

    crontab current_cronjobs.txt
    echo "Added cronjob: $CRONJOB successfully!"

    # rm because the current cron jobs get written to a local file in the invoking directory
    rm current_cronjobs.txt
}