#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/nodeurl.sh


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
http_port=$1
shift
if [ -z "$http_port" ]; then
    echo "missing node http_port."
    exit 1
fi

keystore_path="${secret_path}/${name}.keystore"
node_path="${data_path}/${name}"
password_file="${secret_path}/${name}.password"
address_file="${address_path}/${name}.hex"
unlock_address="0x$(cat ${address_file})"

set -ex
geth --datadir "${node_path}" \
        --syncmode 'snap' \
        --ipcdisable \
	--verbosity 6 \
	--keystore "${keystore_path}" \
	--port ${port} \
        --http --http.addr 0.0.0.0 --http.port ${http_port} \
        --http.corsdomain "*" \
        --http.api admin,debug,eth,miner,net,personal,shh,txpool,web3 \
	--bootnodes "${node_url}" \
	--networkid "${network_id}" \
        --nat extip:159.203.124.106
