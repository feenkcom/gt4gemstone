#!/bin/bash
#
# Retrieve the GemStone archives and set up the environment for setup-remote-gemstone.sh
#
# Note that this file should be sourced, not just run, as it sets environment
# variables to be used in later (manually run) scripts
#
# Inputs:
#	CWD is the Gt image directory
#

echo "Starting Remote Examples Development Setup"

ls *.image
status=$?
if [ $status -ne 0 ]
then
	echo "No image file found.  CWD should be the image directory."
	exit 1
fi

imageDirectory=`pwd`
SCRIPT_DIR="./pharo-local/iceberg/feenkcom/gt4gemstone/scripts"
source $SCRIPT_DIR/remote-gemstone-env.sh

#
# Link the required repositories to the imageDirectory so they can be found by
# later scripts
#
if [ ! -d gt4gemstone ]
then
	ln -s pharo-local/iceberg/feenkcom/gt4gemstone
fi
if [ ! -d gtoolkit-remote ]
then
	ln -s pharo-local/iceberg/feenkcom/gtoolkit-remote
fi
if [ ! -d Sparkle ]
then
	git clone https://github.com/feenkcom/Sparkle.git
fi

chmod +x gt4gemstone/scripts/*.sh
chmod +x gt4gemstone/scripts/release/*.sh
chmod +x gtoolkit-remote/scripts/*.sh

export GT4GEMSTONE_VERSION=dev
export RELEASED_PACKAGE_GEMSTONE_NAME="gt4gemstone-3.7.0-dev"
