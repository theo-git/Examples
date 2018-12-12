Gmail Inbox Watch/Monitor & Alert On New Messages Automation
=========

The Ansible playbooks `service_gmail_watch_*.yml` setups/stops up all the necessary Bash & Python scripts, packages, directories, IAM permissions, keys, etc needed to automate the watching and alerting on new mail in GMail inboxes.

Requirements
------------

- Google Cloud Platform
- HTTPS Git Webhook setup (see Dependencies below)
- Gcloud SDK setup & authenticated with a user has the Project Editor IAM role in the target Project. 
- [IAC-REPO](https://gitlab.example.com/devops/iac) pull access.
- [Ansible 2.4.0.0 or greater installed](http://docs.ansible.com/ansible/latest/intro_installation.html)
  - Using pip: `pip install ansible`
  - _pip is the best practice way of installing Ansible_

Setup Instructions
--------------

1. Clone the IAC-REPO repository to your controlling machine and `cd` into the ansible directory below:
```
git clone git@gitlab.example.com:devops/iac.git
cd iac/modules/ansible
```
2. Run the command below to edit the variables file. Populate the variables with the values you wish to set: 
```
vim modules/ansible/roles/service_gmail_watch/defaults/main.yml
```
3. Setup the Ansible Vault encryption password found in the KMS, titled: `gmail_watch_ansible_vault_password`
  - Then run the command below and paste the password into the file and save it. 
```
vim ~/.ssh/gmail_watch_ansible_vault_password
```
4. Finally run the command below that will setup the infrastructure and run the scripts needed to complete the setup:
```
ansible-playbook service_gmail_watch.yml -vvv --vault-password-file=~/.ssh/gmail_watch_ansible_vault_password
```

Stop Watching An Inbox
--------------
To stop watching & alerting on an inbox, run the command below:
```
ansible-playbook service_gmail_watch_stop.yml -vvv --vault-password-file=~/.ssh/gmail_watch_ansible_vault_password --extra-vars "@roles/gmail_inbox_watch/defaults/main.yml"
```

Dependencies
------------

roles/service_gcp_webhook - See the README in that folder for more information.

Author Information
------------------

Automation and documentation written by Theo.
