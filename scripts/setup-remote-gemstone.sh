#!/usr/bin/env bash
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

DIR=`readlink "$0"` || DIR="$0";
export SCRIPT_DIR="$(cd "$(dirname "${DIR}")" && pwd)"
# Set up environment variables
source "$SCRIPT_DIR/remote-gemstone-env.sh"

if [ -z "$GEMSTONE_WORKSPACE" ]
then
	echo "GEMSTONE_WORKSPACE must be defined"
	exit 1
fi

if [ -e "${GEMSTONE_WORKSPACE}" ]
then
	echo "ERROR: ${GEMSTONE_WORKSPACE} subdirectory already exists"
	exit 1
fi

mkdir "${GEMSTONE_WORKSPACE}"
mkdir "${GEMSTONE_WORKSPACE}/opt"

if [ "$GT_OSNAME" = "Linux" ]; then
    "$SCRIPT_DIR/download-gemstone-linux.sh"
elif [ "$GT_OSNAME" = "Darwin" ]; then
    "$SCRIPT_DIR/download-gemstone-macos.sh"
fi

mkdir "${ROWAN_PROJECTS_HOME}"
cd "${ROWAN_PROJECTS_HOME}"
ln -s ../../gt4gemstone
ln -s ../../gtoolkit-remote
ln -s ../../Sparkle
cd ..
cd ..

# Configure GemStone
cd "$GEMSTONE/install"
"$SCRIPT_DIR/gtinstallgs"

# Configure Stone
export STONE="gs64stone"

# Load RSR and Gt packages
startnetldi -g
startstone "${STONE}"
sleep 1

echo "ROWAN_PROJECTS_HOME=$ROWAN_PROJECTS_HOME :"
ls -l "$ROWAN_PROJECTS_HOME"
echo "gtoolkit-remote/scripts:"
ls -l "$ROWAN_PROJECTS_HOME/gtoolkit-remote/scripts"

#$ROWAN_PROJECTS_HOME/Sparkle/src-gs/bootstrapSparkle.sh
#ROWAN_PROJECTS_HOME/gt4gemstone/scripts/inputGt4gemstone.sh
#ROWAN_PROJECTS_HOME/gtoolkit-remote/scripts/inputGtRemote.sh

"${ROWAN_PROJECTS_HOME}/gt4gemstone/scripts/release/package-release.sh"
"${GEMSTONE_WORKSPACE}/${RELEASED_PACKAGE_GEMSTONE_NAME}/inputRelease.sh" -s "${STONE}"

exit 0
