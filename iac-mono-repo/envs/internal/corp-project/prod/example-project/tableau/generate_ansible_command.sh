#!/bin/bash

IP="$(cat target_ip)"
ANSIBLE_PLAYBOOK_PATH="$(export BASE=$(echo $(pwd) | sed -n "s/^\([^ ]*\)example-mono-repo.*/\1/p");echo "$BASE"example-mono-repo/modules/ansible/tableau_server_ubuntu.yml)"
COMMAND="export ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook -i '"$IP",' "$ANSIBLE_PLAYBOOK_PATH" --vault-id ~/.ssh/tableau_ansible_vault_password -vv --extra-vars "ansible_ssh_private_key_file=~/.ssh/google_compute_engine""

/bin/bash -c "$COMMAND"
