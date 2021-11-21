# Setup your own ethereum network

> NOTE: I have not yet managed to connect to metamask, it seems that it takes time for the node to sync

This repo has scripts to semi-automate the steps from [this blog post](https://medium.com/@pradeep_thomas/how-to-setup-your-own-private-ethereum-network-f80bc6aea088)


Installs ethereum under /srv/ethereum

## Requirements

- SSH Access to a fresh server with ubuntu 20.04.
- [MetaMask](https://metamask.io/) extension installed.



## Step 1: Install apt requirements


SSH into your server and run

```bash
add-apt-repository --yes --update --enable-source ppa:ethereum/ethereum
apt update
apt install -y bash python3-dev openssl-dev ca-certificates curl wget sed nodejs git jq ack-grep
apt install -y ethereum puppeth
```

## Step 2: Install the tools



```bash
mkdir -p /srv/
git clone git@github.com:gabrielfalcao/ethnet.git /srv/tools
```
> Clone this repo under /srv/tools


```bash
chmod +x /srv/tools/*.{sh,py}
```
> Make sure files are executable

## Step 3: Create accounts


- Creates the folder structure for N miner and N rpc nodes
- Generates a random password for each node
- Generates an account for each node

Where `N` is passed as argument to create-tree.sh

```bash
chmod +x /srv/tools/create-tree.sh 2
```

> Creates accounts for 2 miners and 2 rpc nodes


## Step 4: Create genesis config


Run puppeth to create your network, make sure to give it a name and an
explicit network id


```bash
puppeth --network=mynetwork
```

See this asciinema for an example:

[![asciicast](https://asciinema.org/a/M6lNH4QL1H0CwnQICvs5O1PKQ.svg)](https://asciinema.org/a/M6lNH4QL1H0CwnQICvs5O1PKQ)


> NOTE: make sure to fund the address of each node, you can find their addresses under `/srv/ethereum/addrs/*.hex`

> IMPORTANT: export the genesis config to a json file


## Step 5: Edit base.sh with your network id

Edit the file `/srv/tools/base.sh` and change the variable assignment
`network_id` to reflect your custom network id.

```diff
-network_id=9876
+network_id=4444
```

## Step 5: Initialize the genesis block


```bash
/srv/tools/init.sh /srv/tools/mynet.json
```

> Example assuming that exported genesis config is at /srv/tools/mynet.json


## Step 6: Run servers

To ensure unique port numbers, use the utility script that generates
the correct commands:


```bash
/srv/tools/generate-commands.py
```


will output something like:

```bash
/srv/tools/run-bootnode.sh
/srv/tools/run-miner.sh miner1 30400
/srv/tools/run-miner.sh miner2 30401
/srv/tools/run-miner.sh miner3 30402
/srv/tools/run-rpc.sh rpc1 30403 8113
/srv/tools/run-rpc.sh rpc2 30404 8114
/srv/tools/run-rpc.sh rpc3 30405 8115
```


## Step 7: Run the bootnode

```bash
/srv/tools/run-bootnode.sh
```

## Step 8: Edit `base.sh` again

Edit the file `/srv/tools/base.sh` and change the variable assignment
`node_url` to the `enode://` url printed in the output of the bootnode (i.e.: from step 7)

```diff
-node_url="enode://db1175edd511f6c2631f7b0f8c8af9a677483951c1b20bebc869a0b2ac38b0b7cdcf9e3a99a7a2cfa527325bdc9c430e80caa0a7f69ce22c5da02dc50c0aef94@159.203.124.106:30303"
+node_url="enode://YOUR-NODE-URL"
```

## Step 9: Run the first miner

```bash
/srv/tools/run-miner.sh miner1 30400
```

> NOTE: make sure to use the command generated in step 6, the example above is a mere illustration.

## Step 10: Run the first rpc

```bash
/srv/tools/run-rpc.sh rpc1 30403 8113
```

> NOTE: make sure to use the command generated in step 6, the example above is a mere illustration.


## Final Step: Connect your metamask


Open your [MetaMask](https://metamask.io/) extension and add a new network

Use the port of your RPC, following the example from step 8 would be `8113` but make sure to use the port passed as last argument of the `run-rpc.sh` command generated in step 6.
