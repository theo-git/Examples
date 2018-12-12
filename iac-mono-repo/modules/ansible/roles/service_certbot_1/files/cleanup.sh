#!/bin/bash

#This script will be executed only if the certbot DNS challenge is successful.

#Create a transactions.yaml inventory of existing Google DNS records
gcloud dns --project=example-project record-sets transaction start --zone=example-zone

#Remove the DNS challenge from the existing inventory
gcloud dns --project=example-project record-sets transaction remove "$CERTBOT_VALIDATION" --name=_acme-challenge."$CERTBOT_DOMAIN". --ttl=5 --type=TXT --zone=example-zone

#Apply the updated inventory
gcloud dns --project=example-project record-sets transaction execute --zone=example-zone
