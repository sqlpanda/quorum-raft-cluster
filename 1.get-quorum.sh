#!/bin/bash

set -eu -o pipefail
cd $HOME
# install build deps
add-apt-repository ppa:ethereum/ethereum -y
apt-get update
apt-get install -y build-essential unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner

if [ -e /usr/local/bin/wrk ]
then
    	echo "* wrk is installed."
else
	git clone https://github.com/wg/wrk.git
	pushd wrk >/dev/null
	make all
	cp wrk /usr/local/bin
	popd >/dev/null
fi
# install constellation
if [ -e /usr/local/bin/constellation-node ]
then
    	echo "* Constellation is installed."
else 
	wget -q https://github.com/jpmorganchase/constellation/releases/download/v0.3.2/constellation-0.3.2-ubuntu1604.tar.xz
	tar xfJ constellation-0.3.2-ubuntu1604.tar.xz
	cp constellation-0.3.2-ubuntu1604/constellation-node   /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node
	rm -rf constellation-0.3.2-ubuntu1604*
fi
# install golang
if [ -e /usr/bin/go ] 
then
	echo "* go is installed."
else
	wget https://dl.google.com/go/go1.10.linux-amd64.tar.gz
	tar -xvf go1.10.linux-amd64.tar.gz
	mv go /usr/local
	ln -s /usr/local/go/bin/go /usr/bin/go
	go version
fi
# make/install quorum
if [ -e /usr/local/bin/geth ]
then
	echo "* Quorum is installed."
else
	git clone https://github.com/jpmorganchase/quorum.git
	pushd quorum >/dev/null
	git checkout tags/v2.0.2
	make all
	cp build/bin/geth /usr/local/bin
	cp build/bin/bootnode /usr/local/bin
	popd >/dev/null
fi
# Rlink libsodium becuase constellation need it

if [ -e /usr/lib/x86_64-linux-gnu/libsodium.so.18 ]
then
    echo "* libsodium.so.18 is good."
else
	pushd /usr/lib/x86_64-linux-gnu >/dev/null
	ln -s  libsodium.so.23.1.0 libsodium.so.18
	popd >/dev/null
fi


# install Porosity
if [ -e /usr/local/bin/porosity ]
then
    echo "* porosity is installed."
else
	wget -q https://github.com/jpmorganchase/quorum/releases/download/v1.2.0/porosity
	mv porosity /usr/local/bin && chmod 0755 /usr/local/bin/porosity
fi

# done!
banner "Quorum"
