#!/bin/bash

IP="$(cat private_ip)"

ANSIBLE_PLAYBOOK_PATH="$(export BASE=$(echo $(pwd) | sed -n "s/^\([^ ]*\)fullauto.*/\1/p");echo "$BASE"fullauto/modules/ansible/tableau_server_ubuntu_dev.yml)"

#Disabling ANSIBLE_HOST_KEY_CHECKING below is needed to ensure Ansible doesn't get hung up on the ssh prompt below that will occur on the creation of a new host with an IP the controlling machine hasn't connected to before.
#The authenticity of host 'xxx.xxx.xxx.xxx (xxx.xxx.xxx.xxx)' can't be established.
#RSA key fingerprint is xx:yy:zz:....
#Are you sure you want to continue connecting (yes/no)?
COMMAND="export ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook -i '"$IP",' "$ANSIBLE_PLAYBOOK_PATH" --vault-id ~/.ssh/tableau_ansible_vault_password_dev -vv --extra-vars "ansible_ssh_private_key_file=~/.ssh/google_compute_engine""

/bin/bash -c "$COMMAND"
