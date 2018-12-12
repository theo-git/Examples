#!/bin/bash

export DOMAIN="tableau.example.com"
export LETSENCRYPT_CERT_DIR="/etc/letsencrypt/live/$DOMAIN"
export TABLEAU_CERT_DIR="/var/opt/tableau/tableau_server/data/ssl"
export TSM_USERNAME="prod"
export SHARED_SCRIPT="shared/tableau.sh"

chmod +x "$SHARED_SCRIPT"
"$SHARED_SCRIPT"
