#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/base.sh


if [ ! -e "${boot_key_path}" ]; then
    bootnode -genkey ${boot_key_path}
fi

set -e
rm -f ${stdout}
rm -f ${stderr}
run_command bootnode -nodekey ${boot_key_path} -verbosity 9 -addr :30303
