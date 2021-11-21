#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/base.sh


usage(){
    echo "Usage: $0 [node-count]"
    echo -e "\nExample:"
    echo -e "\t$0 /srv/ethereum 10"
    echo -e "\t# creates 10 node configs"
}

node_count=${1}

if [ -z "$node_count" ]; then
    node_count=3
fi

if [ "$node_count" -lt 3 ]; then
    node_count=1
fi
set -e
secret_path="${path}/secret"
data_path="${path}/data"
address_path="${path}/addrs"

if [ -e "${path}" ]; then
    warning "${path} already exists"
    rm -rf $path
fi
info "creating basic tree structure for ${node_count} nodes"
run_command mkdir -p ${path}/{log,data,secret,addrs}

setup_node() {
    name=$1
    shift
    node_path="${data_path}/${name}"
    password_file="${secret_path}/${name}.password"
    pub_file="${secret_path}/${name}.pub"
    keystore_path="${secret_path}/${name}.keystore"
    address_file="${address_path}/${name}.hex"
    info "\nSetting up node ${name}"
    info "\tgenerating password for ${name}"
    run_command openssl rand -base64 12 > "${password_file}"
    info "\tcreating tree for node ${name}"
    run_command mkdir -p "${node_path}"
    info "\tcreating account for ${name}"
    run_command geth --datadir "${node_path}" account new --keystore="${keystore_path}" --password="${password_file}" > "${pub_file}"
    success "\tpublic key info stored in ${pub_file}"
    address=$(find "${keystore_path}" -type f | sed 's/.*-//')
    success "\tstoring address of ${name} in ${address_file}: \033[1;37m${address}\n"
    echo -n "${address}" > "${address_file}"
}
for index in $(seq 1 "${node_count}"); do
    setup_node "rpc${index}"
    setup_node "miner${index}"
done
