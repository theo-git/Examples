#!/bin/bash

export DOMAIN="app.prod.example.com"
export PROJECT="prod-project"
export CLUSTER="prod-app-cluster"
export ZONE="us-central1-f"
export NAMESPACE="prod"
export CERTSECRETNAME="ssl-certificate"
export SHARED_SCRIPT="shared/k8s.sh"

chmod +x "$SHARED_SCRIPT"
"$SHARED_SCRIPT"
