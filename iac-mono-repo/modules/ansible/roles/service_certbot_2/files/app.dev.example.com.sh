#!/bin/bash

export DOMAIN="app.dev.example.com"
export PROJECT="dev-example-project"
export CLUSTER="dev-cluster"
export ZONE="us-central1-a"
export NAMESPACE="dev-app"
export CERTSECRETNAME="ssl-cert"
export SHARED_SCRIPT="shared/k8s.sh"

chmod +x "$SHARED_SCRIPT"
"$SHARED_SCRIPT"
