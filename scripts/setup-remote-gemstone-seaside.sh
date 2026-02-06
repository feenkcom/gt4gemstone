#!/usr/bin/env bash
#
# Configure and load a GemStone DB with GT and Seaside.
#
# Once loaded, executing the following as the DataCurator user should
# server the welcome page:
# 
#     WAGemStoneRunSeasideGems startGemServerOn: 9001.
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

export STONE=gs64stone
echo "STONE=$STONE"
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
ln -s ../../gtoolkit-wireencoding
ln -s ../../gt4llm
popd

chmod +x ./gt4gemstone/scripts/*.sh
chmod +x ./gt4gemstone/scripts/release/*.sh

# Configure GemStone
pushd "$GEMSTONE/install"
"$SCRIPT_DIR/gtinstallgs"
popd

# Use the seaside extent
echo "Using seaside extent."
pushd $GEMSTONE/data
rm -f *.log tranlog1.dbf 
mv extent0.dbf extent0.dbf.bak
cp $GEMSTONE/bin/extent0.seaside.dbf ./extent0.dbf
chmod 644 extent0.dbf
popd

# Increase the resources available to GemStone
echo "Increase system resources (system.conf)."
cp $SCRIPT_DIR/seaside/seaside.system.conf $GEMSTONE/data/system.conf

startnetldi -g
startstone "${STONE}"
sleep 1

# Update permissions to allow GT and Seaside to coexist
echo "Expand permissions."
topaz -l -I ${SCRIPT_DIR}/loginSystemUser.topaz  -S ${SCRIPT_DIR}/seaside/seaside-permissions.topaz < /dev/zero

# Install Seaside
echo "Install seaside."
topaz -l -I ${SCRIPT_DIR}/loginDataCurator.topaz  -S ${SCRIPT_DIR}/seaside/installSeaside.topaz < /dev/zero

if [[ -z "${USE_ROWAN}" || "${USE_ROWAN}" = "no" ]]
then
  if [[ -z "${LOAD_GT4GS_VERSION}" || "${LOAD_GT4GS_VERSION}" = "no" ]]
  then
    echo "Packaging gt4gemstone."
    "${ROWAN_PROJECTS_HOME}/gt4gemstone/scripts/release/package-release.sh"
    "${GEMSTONE_WORKSPACE}/${RELEASED_PACKAGE_GEMSTONE_NAME}/inputRelease.sh" -s "${STONE}"
  else
    echo "Downloading gt4gemstone $LOAD_GT4GS_VERSION."
    echo "Aborting for now..."
    exit 1
    $SCRIPT_DIR/download-gt4gemstone.sh $LOAD_GT4GS_VERSION
    ./gt4gemstone-3.7/inputRelease.sh -s "${STONE}"
  fi
else
  echo "Seaside and Rowan are currently not supported together."
  exit 1
fi

echo "Early stop..."
exit 0

# Patch seaside code for GT compatibility
echo "Apply Gt/Seaside patches."
topaz -l -I ${SCRIPT_DIR}/loginDataCurator.topaz  -S ${SCRIPT_DIR}/seaside/seaside-gt-patches.topaz < /dev/zero

exit 0
