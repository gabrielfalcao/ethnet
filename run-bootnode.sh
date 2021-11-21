#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/base.sh


if [ ! -e "${boot_key_path}" ]; then
    bootnode -genkey ${boot_key_path}
fi
geth --datadir /srv/ethereum/data/ --networkid 331713 --nat extip:${external_ip} > "${boot_log_path}"
