function __register_cronjob() {
    CRONJOB="$1"

    crontab -l > CURRENT_CRONJOBS_FILE
    echo "$CRONJOB" >> CURRENT_CRONJOBS_FILE

    crontab CURRENT_CRONJOBS_FILE
    echo "Added cronjob: $CRONJOB successfully!"

    # rm because the current cron jobs get written to a local file in the invoking directory
    rm CURRENT_CRONJOBS_FILE
}