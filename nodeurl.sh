SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/base.sh


if [ -z "${NODE_URL}" ]; then
    node_url=$(grep enode "${boot_log_path}" | awk '{ print $NF }' | sed 's/self=//')
    warning "The environment variable NODE_URL was not provided"
    if [ -z "${node_url}" ]; then
        error "Could not find enode url in ${boot_log_path}"
        exit 1
    fi
    warning "Using grep to find node_url in the bootnode server logs: ${node_url}"
else
   node_url=${NODE_URL}
fi
