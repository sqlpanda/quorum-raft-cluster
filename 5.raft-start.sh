#!/bin/bash
set -u
set -e
cd $HOME
GLOBAL_ARGS="--raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

# echo "[*] Starting Constellation node"
# nohup constellation-node tm.conf 2>> qdata/logs/constellation.log &

# sleep 1


echo "[*] Starting geth node"
PRIVATE_CONFIG=raft/tm.conf nohup geth --datadir qdata $GLOBAL_ARGS --rpccorsdomain "*" --rpcport 21001 --port 21002 --raftport 21003 --unlock 0 --password raft/passwords.txt 2>>qdata/logs/geth.log &
