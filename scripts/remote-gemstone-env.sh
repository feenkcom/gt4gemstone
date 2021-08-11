#
# Set the expected environment variables for running the Gt GemStone automated
# tests.
#
# This script assumes that the working directory is the image directory and
# GemStone will be installed in to {imageDirectory}/remote-gemstone.
#
GtGEMSTONE_PARENT=`pwd`/remote-gemstone
export GEMSTONE=$GtGEMSTONE_PARENT/GemStone64Bit3.7.0-x86_64.Linux
if [ ! -d $GEMSTONE ]
then
	echo "ERROR: $GEMSTONE doesn't exist"
	exit 1
fi
export GEMSTONE_GLOBAL_DIR=$GtGEMSTONE_PARENT/opt
export MANPATH=$GEMSTONE/doc
export PATH=$GEMSTONE/bin:$PATH
export ROWAN_PROJECTS_HOME=$GtGEMSTONE_PARENT/rowan-projects

