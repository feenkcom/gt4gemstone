#!/usr/bin/env bash
set -e

if [ -z "$LOAD_GT4GS_VERSION" ]
then
	echo "LOAD_GT4GS_VERSION must be defined"
	exit 1
fi

# Download all the required archives, git clones, etc. and upack
if [ ! -f gt4gemstone-3.7.zip ]
then
	echo "Downloading gt4gemstone-3.7.zip to `pwd`"
	wget https://github.com/feenkcom/gtoolkit/releases/download/${LOAD_GT4GS_VERSION}/gt4gemstone-3.7.zip
fi

if [ ! -f gt4gemstone-3.7 ]
then
	echo "Unzipping gt4gemstone-3.7.zip in `pwd`"
	unzip gt4gemstone-3.7.zip
fi
