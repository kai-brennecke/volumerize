#!/bin/bash
# Adaptet from: https://gist.github.com/kwonghung-YIP/a72e358c0c0a1c89cba0eb9ce4018046
#
# Create a service with all secrets added to the default location (/run/secrets)
# Mount the volume specified by SHARED_SECRETS_VOLUME.
# This volume is shared with the main backup service.
# Write all encrypted secrets to SHARED_SECRETS_VOLUME.

source /utils/check-env.sh
check_env "dump_secrets_1" "SHARED_SECRETS_VOLUME"
check_env "dump_secrets_2" "PASSPHRASE"

service_name="tmp_secret_copier"
secret_list=( `docker secret ls --format "{{ .Name }}"` )

cmd="docker service create \
  --name $service_name \
  --env PASSPHRASE \
  --mode global \
  --constraint node.role==manager"

for secret in "${secret_list[@]}"
do
  cmd=$cmd" --secret ${secret}"
done

cmd=$cmd" --mount type=volume,source=$SHARED_SECRETS_VOLUME,destination=/encrypted_secrets"

cmd=$cmd" nginx"

echo $cmd
$cmd

container_id=`docker ps -f "label=com.docker.swarm.service.name=$service_name" -q`

docker exec -w /run/secrets $container_id bash -c 'for file in *
do
openssl enc -pbkdf2 -md sha256 -aes-256-cbc -pass pass:$PASSPHRASE -e -in $file -out /encrypted_secrets/${file}.aes256
done'

docker service rm $service_name
