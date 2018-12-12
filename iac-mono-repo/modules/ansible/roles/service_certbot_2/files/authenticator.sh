#!/bin/bash

PROJECT="example-project"
ZONE="example-zone"

gcloud dns --project="$PROJECT" record-sets transaction start --zone="$ZONE"
gcloud dns --project="$PROJECT" record-sets transaction add "$CERTBOT_VALIDATION" --name=_acme-challenge."$CERTBOT_DOMAIN". --ttl=5 --type=TXT --zone="$ZONE"
gcloud dns --project="$PROJECT" record-sets transaction execute --zone="$ZONE"

sleep 60 
