#!/bin/bash

#Remove any old transaction.yaml file if it exists
file=transaction.yaml
[ -f "$file" ] && rm $file

#Create a transactions.yaml inventory of existing Google DNS records
gcloud dns --project=example-project record-sets transaction start --zone=example-zone

#Add the DNS challenge to the existing inventory
gcloud dns --project=example-project record-sets transaction add "$CERTBOT_VALIDATION" --name=_acme-challenge."$CERTBOT_DOMAIN". --ttl=5 --type=TXT --zone=example-zone

#Apply the updated inventory
gcloud dns --project=example-project record-sets transaction execute --zone=example-zone

sleep 60
