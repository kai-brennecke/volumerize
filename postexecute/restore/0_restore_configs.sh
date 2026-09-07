#!/bin/bash

source /utils/check-env.sh
check_env "dump_configs" "CONFIGS_SOURCE"

for f in ${CONFIGS_SOURCE}/*
do
# Greedily remove everything before the last /.
# See: https://wiki.bash-hackers.org/syntax/pe#substring_removal
file_name=${f##*/}
# Remove file extension by offset and length.
# See: https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
config_name=${file_name:0:-5}
jq '.[0].Spec.Data' $f | base64 -d - | docker config create ${config_name} -
done

exit 0
