#!/bin/bash

# This script simply executes and logs all output of the stop.py script to /var/log/syslog.
# The logging is needed for Stackdriver alert if there are any issues watching critical Gmail inboxes for new email.

WATCH_INBOX="{{ gmail_watch_source_email_address }}"
source ./logging.sh

python stop.py

#If the execution of the script fails, write a line to syslog for Stackdriver to watch for and alert upon.
exit_code=$?
if [ $exit_code -ne 0 ]
then
    echo "FAILURE: Attempting to stop the watch on $WATCH_INBOX failed.  Please investigate!"
fi

