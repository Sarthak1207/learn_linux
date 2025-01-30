#!/bin/bash

PS3='Enter your choice: '
options=("Set Log Directory" "Set Days to Keep Logs" "Set Days to Keep Backups" "Run Archiving" "Exit")

select opt in "${options[@]}"
do
    case $opt in
        "Set Log Directory")
            read -r -p "Enter the log directory [/var/log]: " log_dir
            log_dir="${log_dir:-/var/log}"
            echo "Log directory set to: $log_dir"
            ;;
        "Set Days to Keep Logs")
            read -r -p "Enter days to keep logs [7]: " days_to_keep_logs
            days_to_keep_logs="${days_to_keep_logs:-7}"
            echo "Logs older than $days_to_keep_logs days will be archived."
            ;;
        "Set Days to Keep Backups")
            read -r -p "Enter days to keep backups [30]: " days_to_keep_backups
            days_to_keep_backups="${days_to_keep_backups:-30}"
            echo "Backups older than $days_to_keep_backups days will be deleted."
            ;;
        "Run Archiving")
            echo "Archiving process not implemented in this example."
            ;;
        "Exit")
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done


setup_cron() {
    read -r -p "Do you want to add this script to cron for daily execution? (y/n) " choice
    case "$choice" in
        [yY][eE][sS]|[yY])
            cron_line="0 21 * * * /usr/local/bin/log-archive.sh"
            # Ensure the job isn't already scheduled
            (crontab -l 2>/dev/null | grep -v -F "$cron_line" ; echo "$cron_line") | crontab -
            echo "Cron job added: $cron_line"
            ;;
        *)
            echo "Cron job not added."
            ;;
    esac
}

# Call the cron setup function
setup_cron
