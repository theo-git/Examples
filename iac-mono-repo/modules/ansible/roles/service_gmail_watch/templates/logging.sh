#!/bin/bash

scriptoutput_pipe=/tmp/$$.tmp
trap "rm -f $scriptoutput_pipe" EXIT

# Create scriptoutput pipe:
mknod $scriptoutput_pipe p

# Start syslog 'logger' process in the background with STDIN coming from the scriptoutput pipe.
# Also tell logger to add the script name to the syslog entries so we know where they came from.
logger <$scriptoutput_pipe -t $0 &

# Write STDOUT and STDERR to scriptoutput_pipe while stripping lines that could have passwords.
exec >  >(grep -vE 'password' | while IFS= read -r line; do echo "$line"; done > $scriptoutput_pipe)
exec 2> >(grep -vE 'password' | while IFS= read -r line; do echo "$line"; done > $scriptoutput_pipe)

echo STDOUT captured
echo STDERR captured >&2
