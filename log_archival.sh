#!/bin/bash

: <<'END Comment'
#The PS3 varibale is a built in variable in bash that is used to set the prompt for the select loop.
#The options array provides the list of options to present to the user.
END Comment

PS3='Enter your choice: ' 
options=("Set Log Directory" "Set Days to Keep Logs" "Set Days to Keep Backups" "Run Archiving" "Exit") 

: <<'END Comment'
#The select command displays a numbered list of options and prompts the user to choose one.
#Here "${options[@]}" means "All elements of the array named options".
#read command is used to take input from the user
#-r option is used to prevent backslashes from being interpreted as escape characters.
#-p option is used to display a prompt message.
#log_dir is set to /var/log if the user doesn't provide any input.
END Comment

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

: <<'END Comment'
#This function prompts user to add the script to cron for daily execution.
#The case statement checks if the value of the choice provided by the user.
#Here cron_line="0 21 * * * /usr/local/bin/log-archive.sh" means the mentioned script will run at 9 PM everyday.
#In the cron_line="minute hour day month day_of_week command" format, the script will run at 9 PM everyday.
#crontab -l 2>/dev/null: Lists the current cron jobs. The 2>/dev/null part suppresses any error messages if there are no existing cron jobs.
END Comment

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