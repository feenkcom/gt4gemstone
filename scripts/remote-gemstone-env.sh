#
# Set the expected environment variables for running the Gt GemStone automated
# tests.
#
# This script assumes that the working directory is the image directory and
# GemStone will be installed in to {imageDirectory}/remote-gemstone.
#

export GTIMAGE_DIRECTORY=`pwd`
export GEMSTONE_WORKSPACE=${GTIMAGE_DIRECTORY}/remote-gemstone
export GEMSTONE="${GEMSTONE_WORKSPACE}/GemStone64Bit3.7.0-x86_64.Linux"
export GEMSTONE_GLOBAL_DIR=$GEMSTONE_WORKSPACE/opt
export MANPATH=$GEMSTONE/doc
export PATH=$GEMSTONE/bin:$PATH
export ROWAN_PROJECTS_HOME="${GEMSTONE_WORKSPACE}/rowan-projects"
