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

STONE=gs64stone
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
pushd "${ROWAN_PROJECTS_HOME}"
ln -s ../../gt4gemstone
ln -s ../../gtoolkit-remote
popd

chmod +x ./gt4gemstone/scripts/*.sh
chmod +x ./gt4gemstone/scripts/release/*.sh

# Configure GemStone
pushd "$GEMSTONE/install"
"$SCRIPT_DIR/gtinstallgs"
popd

# Load RSR and Gt packages
startnetldi -g
startstone "${STONE}"
sleep 1

if [[ -z "${USE_ROWAN}" || "${USE_ROWAN}" = "no" ]]
then
  "${ROWAN_PROJECTS_HOME}/gt4gemstone/scripts/release/package-release.sh"
  "${GEMSTONE_WORKSPACE}/${RELEASED_PACKAGE_GEMSTONE_NAME}/inputRelease.sh" -s "${STONE}"
else
  stop_servers
  pushd $GEMSTONE/data
  rm *.log tranlog1.dbf 
  mv extent0.dbf extent0.dbf.bak
  if [ "$USE_ROWAN" = "rowan2" ]
  then
    cp $GEMSTONE/bin/extent0.rowan.dbf ./extent0.dbf
  else
    cp $GEMSTONE/bin/extent0.${USE_ROWAN}.dbf ./extent0.dbf
  fi
  chmod 644 extent0.dbf
  popd
  startnetldi -g
  startstone gs64stone
  ./gt4gemstone/scripts/installGt4gemstone_${USE_ROWAN}.sh 
  ./gtoolkit-remote/scripts/installGtoolkitRemote_${USE_ROWAN}.sh 
fi

exit 0
