#!/bin/bash

# This script simply executes and logs all output of the send.py script to /var/log/syslog.
# The logging is needed for Stackdriver alert if there are any issues watching critical Gmail inboxes for new email.

SOURCE_EMAIL_ADDRESS="{{ gmail_watch_source_email_address }}"
DESTINATION_EMAIL_ADDRESS="{{ gmail_watch_destination_email_address }}"
source ./logging.sh

python send.py

#If the execution of the script fails, write a line to syslog for Stackdriver to watch for and alert upon.
exit_code=$?
if [ $exit_code -ne 0 ]
then
    echo "FAILURE: Sending the email from $SOURCE_EMAIL_ADDRESS to $DESTINATION_EMAIL_ADDRESS failed.  Please investigate!"
fi

