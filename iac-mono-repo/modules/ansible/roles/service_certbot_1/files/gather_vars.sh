#!/bin/bash

function gather_vars {
    export LETSENCRYPTDIR="/etc/letsencrypt"
    export BACKUPDIR="$LETSENCRYPTDIR/backups/$(date +%Y-%m-%d_%H:%M:%S)"
    export liveDir="$LETSENCRYPTDIR"/live/"$domain"
    export archiveDir="$LETSENCRYPTDIR"/archive/"$domain"
    export certFileExpirationDate=$(cat "$archiveDir"/cert* | openssl x509 -noout -enddate | cut -d = -f 2 | xargs -0 date +"%Y%m%d" -d)
    export certFileRemainingDays=$(( ($(date '+%s' -d "$certFileExpirationDate") - $(date '+%s')) / 86400 ))
    export ANSIBLE_HOST_KEY_CHECKING=False
    export CERTBOT_EMAIL="operations@multiscalehn.com"
}
