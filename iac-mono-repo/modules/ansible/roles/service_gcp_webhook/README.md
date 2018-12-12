Google Cloud HTTP/S Webhook Setup (For Custom Webhooks & Git Webhooks)
=========

The Ansible playbook `service_gcp_webhook.yml` sets up all the necessary Python scripts, packages, directories, IAM permissions, keys, etc needed to automate the setup of a HTTP/S webhook on a target GCP host.

Requirements
------------

- Google Cloud Platform
- Gcloud SDK setup & authenticated with a user has the Project Editor IAM role in the target Project. 
- [IAC-REPO](https://gitlab.example.com/devops/iac) pull access.
- [Ansible 2.4.0.0 or greater installed](http://docs.ansible.com/ansible/latest/intro_installation.html)
  - Using pip: `pip install ansible`
  - _pip is the best practice way of installing Ansible_

Setup Instructions
--------------

1. Clone the IAC-REPO to your local machine.
2. Run the command below to edit the variables file. Populate the variables with the values you wish to set: 
```
vim modules/ansible/roles/service_gcp_webhook/defaults/main.yml 
```
3. Finally run the command below that will setup the infrastructure and run the scripts needed to complete the setup:
```
ansible-playbook -i 'TARGET_HOST_IP,' service_gcp_webhook.yml -vvv
```

Dependencies
------------

- None

Author Information
------------------

Automation and documentation written by Theo.

