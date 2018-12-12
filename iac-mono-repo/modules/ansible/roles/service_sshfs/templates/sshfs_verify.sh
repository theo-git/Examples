#!/bin/bash

export mount="$1"
PATH="$PATH"

verify () {
if [ $? -eq 0 ]; then
    echo "The $task succeeded!"
else
    echo "The $task of $mount failed! Please investigate!"
    exit 1
fi
}

mount () {
    task="mount"
    sshfs {{ sshfs_command_arguments }} {{ sshfs_remote_host }}:{{ sshfs_remote_path }} "$mount"
    verify
}

unmount () {
    task="unmount"
    fusermount -u "$mount"
    verify
}

if grep -qs "$mount" /proc/mounts; then
    echo "The $mount SSHFS directory exists in /proc/mounts. Checking to see if journal files are present in $mount."
    if [ "$(ls -A $mount)" ]; then
        echo "ALL GOOD! The $mount directory is not empty!"
    else
        echo "The $mount SSHFS directory is empty!  Attempting to unmount & mount..."
        unmount
        mount
    fi
else
    echo "The $mount SSHFS directory does not appear to be mounted.  Attempting to mount..."
    mount
fi
