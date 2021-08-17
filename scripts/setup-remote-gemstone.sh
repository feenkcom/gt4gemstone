#!/bin/bash
#
# Set up the remote GemStone environment for running the examples in 
# GtRemoteGemStoneDeclarativeExamples
#
# Assumes that the environment should be located in `remote-gemstone` below the 
# working directory, which is the image directory.
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

if [ -z "$GEMSTONE_WORKSPACE" ]
then
	echo "GEMSTONE_WORKSPACE must be defined"
	exit 1
fi

if [ -e ${GEMSTONE_WORKSPACE} ]
then
	echo "ERROR: ${GEMSTONE_WORKSPACE} subdirectory already exists"
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

# Set up environment variables
source $SCRIPT_DIR/remote-gemstone-env.sh

mkdir ${GEMSTONE_WORKSPACE}
mkdir ${GEMSTONE_WORKSPACE}/opt
cd ${GEMSTONE_WORKSPACE}
unzip ../GemStone64Bit3.7.0-x86_64.Linux.zip
unzip ../GemStoneClientLibs3.7.0-x86_64.Linux.zip

mkdir ${ROWAN_PROJECTS_HOME}
cd ${ROWAN_PROJECTS_HOME}
ln -s ../../pharo-local/iceberg/feenkcom/gt4gemstone
ln -s ../../pharo-local/iceberg/feenkcom/gtoolkit-remote
git clone https://github.com/feenkcom/Sparkle.git
cd ..
cd ..

# Configure GemStone
cd $GEMSTONE/install
$SCRIPT_DIR/gtinstallgs

# Load RSR and Gt packages
startnetldi -g
startstone
sleep 1

echo "ROWAN_PROJECTS_HOME=$ROWAN_PROJECTS_HOME :"
ls -l $ROWAN_PROJECTS_HOME
echo "gtoolkit-remote/scripts:"
ls -l $ROWAN_PROJECTS_HOME/gtoolkit-remote/scripts

#$ROWAN_PROJECTS_HOME/Sparkle/src-gs/bootstrapSparkle.sh
#ROWAN_PROJECTS_HOME/gt4gemstone/scripts/inputGt4gemstone.sh
#ROWAN_PROJECTS_HOME/gtoolkit-remote/scripts/inputGtRemote.sh

${ROWAN_PROJECTS_HOME}/gt4gemstone/scripts/release/package-release.sh

chmod +x ${GEMSTONE_WORKSPACE}/${RELEASED_PACKAGE_GEMSTONE_NAME}/inputRelease.sh
${GEMSTONE_WORKSPACE}/${RELEASED_PACKAGE_GEMSTONE_NAME}/inputRelease.sh

exit 0
