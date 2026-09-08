#!/bin/bash

if [[ ! -v CONFIGS_SOURCE ]]; then
    exit 0
fi

source /opt/volumerize/env.sh
check_env "dump_configs" "CONFIGS_SOURCE"

echo "Creating $CONFIGS_SOURCE folder if it does not exist"
mkdir -p $CONFIGS_SOURCE

config_list=( `docker config ls --format "{{ .Name }}"` )

for config in "${config_list[@]}"
do
  docker config inspect $config > ${CONFIGS_SOURCE}/${config}.json
done
