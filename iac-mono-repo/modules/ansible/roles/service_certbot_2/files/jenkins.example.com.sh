#!/bin/bash

export DOMAIN="jenkins.example.com"
export PROJECT="jenkins-internal-project"
export CLUSTER="jenkins"
export ZONE="us-central1-c"
export NAMESPACE="jenkins-internal"
export CERTSECRETNAME="ssl-certificate"
export SHARED_SCRIPT="shared/k8s.sh"

chmod +x "$SHARED_SCRIPT"
"$SHARED_SCRIPT"
