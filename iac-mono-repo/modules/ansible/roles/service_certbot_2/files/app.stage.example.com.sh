#!/bin/bash

export DOMAIN="app.stage.example.com"
export PROJECT="stage-example-project"
export CLUSTER="stage-app-cluster"
export ZONE="us-central1-b"
export NAMESPACE="app-stage"
export CERTSECRETNAME="stage-ssl-cert"
export SHARED_SCRIPT="shared/k8s.sh"

chmod +x "$SHARED_SCRIPT"
"$SHARED_SCRIPT"
