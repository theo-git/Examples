#!/bin/bash

#This Tableau script is utilized by mutliple Tableau servers to update their SSL certificates.

#Ensure the file below is sourced so that the Tableau bin directory is added to the $PATH, in case it's not in ~/.bashrc (which it should be).
source /etc/profile.d/tableau_server.sh

#Permissions change below is needed to allow the tableau service group `tsmadmin` access the letsencrypt cert.
cd /etc || exit #In case cd fails
chown -R root:tsmadmin letsencrypt
chmod -R 750 letsencrypt

#Copy the cert to the directory where Tableau expects a copy of the cert to be, change the file extension to the correct formats as show below, and ensure the file permissions are set correctly.  According to Tableau Support, Tableau Linux does not support using a symlink to the Letsencypt cert at this time.
mkdir -p "$TABLEAU_CERT_DIR"
cd "$TABLEAU_CERT_DIR" || exit #In case cd fails
cp $LETSENCRYPT_CERT_DIR/cert.pem ./cert.crt
cp $LETSENCRYPT_CERT_DIR/fullchain.pem ./fullchain.crt
cp $LETSENCRYPT_CERT_DIR/privkey.pem ./privkey.key
chown -R root:tsmadmin "$TABLEAU_CERT_DIR"
chmod -R 750 "$TABLEAU_CERT_DIR"

#Load the new into the Tableau TSM configuration manager by re-enabling external-SSL.
tsm security external-ssl disable --username "$TSM_USERNAME"
tsm security external-ssl enable --cert-file "$TABLEAU_CERT_DIR/cert.crt" --key-file "$TABLEAU_CERT_DIR/privkey.key" --chain-file "$TABLEAU_CERT_DIR/fullchain.crt"
tsm pending-changes apply --ignore-prompt
