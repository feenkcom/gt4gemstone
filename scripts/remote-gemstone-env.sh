#
# Set the expected environment variables for running the Gt GemStone automated
# tests.
#
# This script assumes that the working directory is the image directory and
# GemStone will be installed in to {imageDirectory}/remote-gemstone.
#

ARCH=`uname -m`
VM_ARCH=${ARCH}
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     GT_OSNAME=Linux;;
    Darwin*)    GT_OSNAME=Darwin;;
    *)          GT_OSNAME="UNKNOWN:${unameOut}"
esac
export GT_OSNAME

export GTIMAGE_DIRECTORY=`pwd`
export GEMSTONE_WORKSPACE=${GTIMAGE_DIRECTORY}/remote-gemstone

if [ "$GT_OSNAME" == "Linux" ]; then
    GEMSTONE="${GEMSTONE_WORKSPACE}/GemStone64Bit3.7.0-x86_64.Linux"
elif [ "$GT_OSNAME" == "Darwin" ]; then
    GEMSTONE="${GEMSTONE_WORKSPACE}/GemStone64Bit3.7.0-i386.Darwin"
fi

export GEMSTONE
export GEMSTONE_GLOBAL_DIR=$GEMSTONE_WORKSPACE/opt
export MANPATH=$GEMSTONE/doc
export PATH=$GEMSTONE/bin:$PATH
export ROWAN_PROJECTS_HOME="${GEMSTONE_WORKSPACE}/rowan-projects"
