#!/bin/bash
set -u
set -e
cd $HOME
echo "[*] Cleaning up temporary data directories"
rm -rf qdata
mkdir -p qdata/logs

echo "[*] Configuring node"
mkdir -p qdata/{keystore,geth}
cp raft/static-nodes.json qdata
cp raft/keystore/$(ls raft/keystore) qdata/keystore/acckey
#cp keys/key1.json qdata/keystore/acckey
cp raft/geth/nodekey qdata/geth/nodekey
cp raft/genesis.json qdata/genesis.json
geth --datadir qdata init qdata/genesis.json
