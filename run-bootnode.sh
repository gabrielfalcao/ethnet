#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/base.sh


if [ ! -e "${boot_key_path}" ]; then
    bootnode -genkey ${boot_key_path}
fi

echo "Running bootnode. Logs available in: ${boot_log_path}"
2>&1 geth --datadir ${data_path} --networkid "${network_id}" --nat "extip:${external_ip}" > "${boot_log_path}"
