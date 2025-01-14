#
# Set the expected environment variables for running the Gt GemStone automated
# tests.
#
# This script assumes that the working directory is the image directory and
# GemStone will be installed in to {imageDirectory}/remote-gemstone.
#
# Input environment variables:
#
# - GT_GEMSTONE_VERSION specifies the GemStone version
#

if [ -z $GT_GEMSTONE_VERSION ]
then
  echo "GT_GEMSTONE_VERSION not specified"
  exit 1
fi

ARCH="$(uname -m)"
VM_ARCH="${ARCH}"
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     GT_OSNAME=Linux;;
    Darwin*)    GT_OSNAME=Darwin;;
    *)          GT_OSNAME="UNKNOWN:${unameOut}"
esac
export GT_OSNAME

export GTIMAGE_DIRECTORY=`pwd`
export GEMSTONE_WORKSPACE=${GTIMAGE_DIRECTORY}/remote-gemstone

if [ "$GT_OSNAME" = "Linux" ]; then
    GEMSTONE="${GEMSTONE_WORKSPACE}/GemStone64Bit${GT_GEMSTONE_VERSION}-x86_64.Linux"
elif [ "$GT_OSNAME" = "Darwin" -a "$VM_ARCH" = "arm64" ]; then
    GEMSTONE="${GEMSTONE_WORKSPACE}/GemStone64Bit${GT_GEMSTONE_VERSION}-arm64.Darwin"
elif [ "$GT_OSNAME" = "Darwin" ]; then
    GEMSTONE="${GEMSTONE_WORKSPACE}/GemStone64Bit${GT_GEMSTONE_VERSION}-i386.Darwin"
fi

export GEMSTONE
export GEMSTONE_GLOBAL_DIR=$GEMSTONE_WORKSPACE/opt
export MANPATH=$GEMSTONE/doc
export PATH=$GEMSTONE/bin:$PATH
export ROWAN_PROJECTS_HOME="${GEMSTONE_WORKSPACE}/rowan-projects"

echo "GEMSTONE=$GEMSTONE"
echo "GEMSTONE_GLOBAL_DIR=$GEMSTONE_GLOBAL_DIR"
echo "ROWAN_PROJECTS_HOME=$ROWAN_PROJECTS_HOME"
