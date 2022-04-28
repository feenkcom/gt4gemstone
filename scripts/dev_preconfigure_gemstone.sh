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

imageDirectory=`pwd`
echo "imageDirectory=${imageDirectory}"

DIR=`readlink "$0"` || DIR="$0";
SCRIPT_DIR="$(cd "$(dirname "${DIR}")" && pwd)"
source $SCRIPT_DIR/remote-gemstone-env.sh

#
# Link the required repositories to the imageDirectory so they can be found by
# later scripts
#
ln -s pharo-local/iceberg/feenkcom/gt4gemstone
ln -s pharo-local/iceberg/feenkcom/gtoolkit-remote
git clone --depth=1 https://github.com/feenkcom/Sparkle.git

chmod +x gt4gemstone/scripts/*.sh
chmod +x gt4gemstone/scripts/release/*.sh
chmod +x gtoolkit-remote/scripts/*.sh

export GT4GEMSTONE_VERSION=dev
export RELEASED_PACKAGE_GEMSTONE_NAME="gt4gemstone-3.7.0-dev"
