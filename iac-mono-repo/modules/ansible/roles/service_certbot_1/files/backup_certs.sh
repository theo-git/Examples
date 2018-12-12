#!/bin/bash

#Backing up the 'renewal' directories below is necessary to ensure Certbot's built-in auto-renew process doesn't conflict with this script.  Certbot's renewal process is incompatible with our Infrastructure as it requires that we whitelist Letencrypt's server IPs, which we cannot do since Letencrypt cannot sign a BAA with us.

function backup_certs {
    mkdir -p "$BACKUPDIR"
    mv "$LETSENCRYPTDIR"/renewal* "$BACKUPDIR"/
    echo "CERT BACKUP PROCESS: Backing up existing $domain cert archive & live folders and storing them in GCS in case there are issues renewing certs."
    cp -r $LETSENCRYPTDIR/archive "$BACKUPDIR"/
    cp -r "$LETSENCRYPTDIR"/live "$BACKUPDIR"/
    echo "CERT BACKUP PROCESS: Verifying the $domain cert backup was successful or not..."
    gsutil -m cp -e -c -r "$BACKUPDIR" gs://certbot-ssl-certificate-backups
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 0 ]; then
        echo "CERT BACKUP PROCESS: The cert backup was successful! Ensure secure-delete is installed so that we can remove the $BACKUPDIR now that it is no longer needed." 
        apt install secure-delete
        srm -rf "$BACKUPDIR"
    else
        echo "CERT BACKUP PROCESS: FAILED TO BACKUP EXISTING CERTS TO GCS."
        echo "CERT BACKUP PROCESS: Not removing $BACKUPDIR or $liveDir."
    fi
}
