#!/bin/bash
set -u
set -e
cd $HOME
echo "[*] Starting Constellation node"
touch qdata/logs/constellation.log
nohup constellation-node raft/tm.conf 2>> qdata/logs/constellation.log &
