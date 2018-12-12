#!/bin/bash

LB_CERT_NAME="grafana-ssl-certificate-$(date +%F)"

#Ensure dependencies are installed 
apt install python-pip -q
pip install ansible

#Run Ansible ad-hoc to connect to prov-prometheus to restart the alertmanager service to get grafana to recognize the new cert
ansible all -i 'grafana,' -m service -a "name=alertmanager state=restarted" --become --extra-vars "ansible_ssh_private_key_file=~/.ssh/google_compute_engine"

#Create a gcloud cert from the certbot cert files
gcloud beta compute --project "example-project" ssl-certificates create "$LB_CERT_NAME" --certificate=/etc/letsencrypt/live/grafana.example.com/fullchain.pem --private-key=/etc/letsencrypt/live/grafana.example.com/privkey.pem

#Apply the gcloud cert to the applicable load-balancer
gcloud compute --project "example-project" target-https-proxies update grafana-lb-target-proxy --ssl-certificates "$LB_CERT_NAME"
