#!/bin/bash

### LOGGING SECTION START ####
scriptoutput_pipe=/tmp/$$.tmp
trap 'rm -f $scriptoutput_pipe' EXIT
mknod $scriptoutput_pipe p
logger <$scriptoutput_pipe -t "$0" &
#Ensure passwords are not logged.
PWD_CMD="grep -vE 'password' | while IFS= read -r line; do echo $line; done > $scriptoutput_pipe"
exec >  >("$PWD_CMD")
exec 2>  >("$PWD_CMD")
echo STDOUT captured
echo STDERR captured >&2
### LOGGING SECTION END ####

#Ensure Ansible is installed and the system PATH is sourced to ensure 'ansible-playbook' can be located consistently.
pip install ansible
source /etc/environment
source ./domains.sh
source ./gather_vars.sh
source ./backup_certs.sh
source ./verify_dirs.sh
source ./verify_certs.sh

verify_certs
