#!/bin/bash

export DOMAIN="dev.tableau.example.com"
export LETSENCRYPT_CERT_DIR="/etc/letsencrypt/live/$DOMAIN"
export TABLEAU_CERT_DIR="/var/opt/tableau/tableau_server/data/ssl"
export TSM_USERNAME="stage"
export SHARED_SCRIPT="shared/tableau.sh"

chmod +x "$SHARED_SCRIPT"
"$SHARED_SCRIPT"
