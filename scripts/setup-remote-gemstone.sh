#!/bin/bash
#
# Set up the remote GemStone environment for running the examples in 
# GtRemoteGemStoneDeclarativeExamples
#
# Assumes that the environment should be located in `remote-gemstone` below the 
# working directory, which is typically the image directory.
#
set -e
set -x
trap stop_servers EXIT

function stop_servers()
{
        # Shutdown the GemStone servers
        stopstone -i gs64stone DataCurator swordfish
        stopnetldi
}

export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -e remote-gemstone ]
then
	echo "ERROR: remote-gemstone subdirectory already exists"
	exit 1
fi

# Download all the required archives, git clones, etc. and upack
if [ ! -f GemStone64Bit3.7.0-x86_64.Linux.zip ]
then
	wget http://downloads.gemtalksystems.com/pub/GemStone64/3.7.0-Alpha2/GemStone64Bit3.7.0-x86_64.Linux.zip
fi

if [ ! -f GemStoneClientLibs3.7.0-x86_64.Linux.zip ]
then
	wget http://downloads.gemtalksystems.com/pub/GemStone64/3.7.0-Alpha2/GemStoneClientLibs3.7.0-x86_64.Linux.zip
fi

mkdir remote-gemstone
mkdir remote-gemstone/opt
cd remote-gemstone
unzip ../GemStone64Bit3.7.0-x86_64.Linux.zip
unzip ../GemStoneClientLibs3.7.0-x86_64.Linux.zip
mkdir rowan-projects
cd rowan-projects
ln -s ../../pharo-local/iceberg/feenkcom/gt4gemstone
ln -s ../../pharo-local/iceberg/feenkcom/gtoolkit-remote
git clone git@github.com:GemTalk/Sparkle.git
cd ..
cd ..

# Set up environment variables
source $SCRIPT_DIR/remote-gemstone-env.sh

# Configure GemStone
cd $GEMSTONE/install
$SCRIPT_DIR/gtinstallgs

# Load RSR and Gt packages
startnetldi -g
startstone
sleep 1

$ROWAN_PROJECTS_HOME/Sparkle/src-gs/bootstrapSparkle.sh
$ROWAN_PROJECTS_HOME/gt4gemstone/rowan/scripts/inputGt4gemstone.sh
$ROWAN_PROJECTS_HOME/gtoolkit-remote/scripts/inputGtRemote.sh

exit 0
