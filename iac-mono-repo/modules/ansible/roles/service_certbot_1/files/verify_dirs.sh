#!/bin/bash

function verify_dirs {
    echo "VERIFY EXISTING CERT DIRS: Checking to see if any existing $domain cert directories exist."
    if [ -d "$liveDir" ] || [ -d "$archiveDir" ]; then
        echo "VERIFY EXISTING CERT DIRS: Existing directories found!  Now checking to see if the $domain cert in $archiveDir is less than 30 days old..."
        if [ "$certFileRemainingDays" -lt 30 ]; then
            echo "VERIFY EXISTING CERT DIRS: Securely deleting $domain live & archive directories now that their backed up to GCS to avoid conflicts with the upcoming certificate renewal."
            srm -rf "$liveDir"
            if [ $EXIT_CODE -eq 0 ]; then
                echo "CERT DIR CLEANUP: SUCCESS! - The $liveDir was securely deleted."
            else
                echo "CERT DIR CLEANUP: FAILED! - The $liveDir was NOT deleted. Please investigate!"
            fi
            srm -rf "$archiveDir"
        fi
    else
        echo "VERIFY EXISTING CERT DIRS: No existing $domain cert live or archive cert directories found.  No action necessary!"
    fi
}
