#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/base.sh


name=$1
shift
if [ -z "${name}" ]; then
    error "Missing positional argument: net-json-file"
    exit 1
fi

if [ ! -e "${name}" ]; then
    error "File does not exist: ${name}"
    exit 1
fi

geth --datadir=${data_path} init ${name}
