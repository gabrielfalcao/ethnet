#!/usr/bin/env python3
import os
import json
from pathlib import Path

here = Path(__file__).absolute_path.parent

BASE_PORT = 30301
BASE_RPC_PORT = 8101
ethereum_path = Path('/srv/ethereum')

def load_addresses():
    addrs = {}
    for path in ethereum_path.joinpath('addrs').glob('*'):
        name = os.path.splitext(path.name)[0]
        addrs[name] = path.open().read().strip()

    return addrs

def iter_names(matches=None):
    addrs = load_addresses()
    for index, key in enumerate(sorted(addrs.keys(), reverse=True)):
        value = addrs[key]
        rpc_port = BASE_RPC_PORT + index
        port = BASE_PORT + index
        info = dict(
            port=port,
            rpc_port=rpc_port,
            address=value,
            name=key
        )
        yield info

def tool(name):
    return here.joinpath(name)

def main():
    nodes = list(iter_names())
    print(json.dumps(nodes, indent=2))

    for info in nodes:
        name = info['name']
        port = info['port']
        rpc_port = info['rpc_port']

        if info['name'].startswith('rpc'):
            print(f'{tool("run-rpc.sh")} {name} {port} {rpc_port}')
        elif info['name'].startswith('miner'):
            print(f'{tool("run-miner.sh")} {name} {port}')


if __name__ == '__main__':
    main()
