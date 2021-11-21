#!/usr/bin/env bash

path=$1
now=$(date +"%s")

stderr=${0}.${now}.stderr.log
stdout=${0}.${now}.stdout.log


usage(){
    echo "Usage: $0 <target-path> [node-count]"
    echo -e "\nExample:"
    echo -e "\t$0 /srv/ethereum 10"
    echo -e "\t# creates 10 node configs"
}

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
if [ "$path" == "help" ]; then
    usage
    exit 0
fi
if [ -z "$path" ]; then
    error "required argument: path to the ethereum net tree"
    usage
    exit 1
fi
shift

node_count=${1}

if [ -z "$node_count" ]; then
    node_count=3
fi

if [ "$node_count" -lt 3 ]; then
    error "required argument: path to the ethereum net tree"
    usage
fi
set -e
secret_path="${path}/secret"
log_path="${path}/log"
data_path="${path}/data"

if [ -e "${path}" ]; then
    warning "${path} already exists"
fi
info "creating basic tree structure for ${node_count} nodes"
run_command mkdir -p ${path}/{log,data,secret}

for index in $(seq 1 "${node_count}"); do
    node_path="${data_path}/node${index}"
    password_file="${secret_path}/node${index}.password"
    pub_file="${secret_path}/node${index}.pub"
    keystore_path="${secret_path}/node${index}.${now}.keystore"
    info "generating password for node${index}"
    run_command openssl rand -base64 12 > "${password_file}"
    info "creating tree for node${index}"
    run_command mkdir -p "${node_path}"
    info "creating account for node${index}"
    run_command geth --datadir "${node_path}" account new --keystore="${keystore_path}" --password="${password_file}" > "${pub_file}"
    success "public key info stored in ${pub_file}\n"
done
