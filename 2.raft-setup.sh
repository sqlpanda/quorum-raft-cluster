#!/bin/bash
set -u
set -e
cd $HOME
CONSTELLATION_KEY_PASSWORD=""

echo "[*] Cleaning up temporary data directories"
rm -rf raft
mkdir raft

echo "[*] Generating geth node config"
nohup geth --datadir raft 2>> raft/setup.log &
sleep 10
echo "[\"$(cat raft/setup.log | grep -m 1 -oEi '(enode.*@)')127.0.0.1:21000?discport=0&raftport=23000\"]" >> raft/static-nodes.json

# echo "[*] Creating default ethereum account"
# geth --datadir raft --password passwords.txt account new

echo "[*] Stopping geth"
killall  geth

sleep 5
echo "[*] Greating new account"
geth --datadir raft account new

echo "[*] Generating constellation key pair"
pushd raft >/dev/null
echo $CONSTELLATION_KEY_PASSWORD | constellation-node --generatekeys=constellation
popd >/dev/null

echo "[*] Done"
echo "[*] Copy sample genesis file."
cp $PWD/quorum-raft-cluster/genesis.example.json raft/genesis.json 
echo "[*] Copy constellation config file."
cp $PWD/quorum-raft-cluster/tm.conf raft/tm.conf
echo "[*] Copy geth default password file."
cp $PWD/quorum-raft-cluster/passwords.txt raft/passwords.txt
echo "[*] You need to manually update passwords.txt,genesis.json,static-nodes.json and tm.conf under raft/."
echo "[*] Done"
