#!/bin/bash

# This script simply executes and logs all output of the watch.py script to /var/log/syslog.
# The logging is needed for Stackdriver alert if there are any issues watching critical GMail inboxes for new email.

WATCH_INBOX="{{ gmail_inbox_watch_alert_source_email_address }}"
source ./logging.sh

python watch.py

#If the execution of the script fails, write a line to syslog for Stackdriver to watch for and alert upon.
exit_code=$?
if [ $exit_code -ne 0 ]
then
    echo "FAILURE: Setting up the watch method on $WATCH_INBOX failed.  Please investigate!"
fi
