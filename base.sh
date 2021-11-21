#!/usr/bin/env bash

path=/srv/ethereum

script_name="$(basename ${0})"
secret_path="${path}/secret"
log_path="${path}/log"
data_path="${path}/data"
address_path="${path}/addrs"
boot_key_path="${path}/boot.key"
boot_log_path="${log_path}/boot.log"
stderr="/tmp/${script_name}.err.log"
stdout="/tmp/${script_name}.out.log"
network_id=4444
mkdir -p "${log_path}"
log() {
    echo "$@" >> ${stdout}
}

info() {
    log "# ${@}"
    echo -e "\033[1;34m${@}\033[0m"
}
success() {
    log "# ${@}"
    echo -e "\033[1;32m${@}\033[0m"
}
warning() {
    log "# WARNING: ${@}"
    echo -e "\033[0;33mWarning: \033[1;33m${@}\033[0m"
}
error() {
    log "# ERROR: ${@}"
    echo -e "\033[0;31mError: \033[1;31m${@}\033[0m"
}

run_command() {
    log "${@}"
    2>>${stderr} $@
}

get_node_url(){
    grep enode "${boot_log_path}"
}
if [ -z "${EXTERNAL_IP}" ]; then
    external_ip=$(ifconfig eth0 | grep 'inet\s' | awk '{ print $2}')
    warning "The environment variable EXTERNAL_IP was not provided"
    warning "Using ifconfig to get ip: ${external_ip}"
else
    external_ip="${EXTERNAL_IP}";
fi

if [ -z "${NODE_URL}" ]; then
    node_url="enode://db1175edd511f6c2631f7b0f8c8af9a677483951c1b20bebc869a0b2ac38b0b7cdcf9e3a99a7a2cfa527325bdc9c430e80caa0a7f69ce22c5da02dc50c0aef94@159.203.124.106:30303"
else
   node_url=${NODE_URL}
fi
