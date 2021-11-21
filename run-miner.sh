#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/base.sh


name=$1
shift
if [ -z "$name" ]; then
    echo "missing node name. Should be one of $(ls /srv/ethereum/addr | sed 's/.hex//')"
    exit 1
fi
port=$1
shift
if [ -z "$port" ]; then
    echo "missing node port."
    exit 1
fi


keystore_path="${secret_path}/${name}.keystore"
node_path="${data_path}/${name}"
password_file="${secret_path}/${name}.password"
address_file="${address_path}/${name}.hex"
unlock_address="0x$(cat ${address_file})"

set -ex
geth --datadir "${node_path}" \
	--syncmode 'full' \
	--verbosity 6 \
	--keystore "${keystore_path}" \
	--port ${port} \
	--bootnodes "${node_url}" \
	--networkid "${network_id}" \
	--miner.gasprice '1' \
	--unlock "${unlock_address}" \
	--password "${password_file}" \
	--mine \
        --nat extip:159.203.124.106
