#!/bin/bash

if [[ ! -v SECRETS_SOURCE ]]; then
    exit 0
fi

source /opt/volumerize/env.sh
check_env "restore_secrets_1" "SECRETS_SOURCE"
check_env "restore_secrets_2" "PASSPHRASE"

for f in ${SECRETS_SOURCE}/*
do
# Greedily remove everything before the last /.
# See: https://wiki.bash-hackers.org/syntax/pe#substring_removal
file_name=${f##*/}
# Remove file extension by offset and length.
# See: https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
secret_name=${file_name:0:-7}
openssl enc -pbkdf2 -md sha256 -aes-256-cbc -pass pass:$PASSPHRASE -d -in $f | docker secret create ${secret_name} -
done

exit 0
