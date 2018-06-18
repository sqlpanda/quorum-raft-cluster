#!/bin/bash
set -u
set -e
CONSTELLATION_KEY_PASSWORD=""

echo "[*] Cleaning up temporary data directories"
rm -rf raft
mkdir raft

echo "[*] Generating geth node config"
nohup geth --datadir raft 2>> raft/setup.log &
sleep 10
echo "[\"$(cat raft/setup.log | grep -oEi '(enode.*@)')127.0.0.1:21000?discport=0&raftport=23000\"]" >> raft/static-nodes.json

# echo "[*] Creating default ethereum account"
# geth --datadir raft --password passwords.txt account new

echo "[*] Stopping geth"
killall geth

echo "[*] Generating constellation key pair"
cd raft
echo $CONSTELLATION_KEY_PASSWORD | constellation-node --generatekeys=constellation

echo "[*] Done"
