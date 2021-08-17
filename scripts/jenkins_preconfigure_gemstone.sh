#!/bin/bash
#
# Retrieve the GemStone archives
#
# This script caches the GemStone archives to prevent unnecessary large 
# downloads on the Jenkins CI machines
#
# Inputs:
#	CWD is the Gt image directory
#	WORKSPACE is a directory where the archives can be cached.
#

echo "Starting Remote Examples Jenkins Setup"

imageDirectory=`pwd`
echo "EXAMPLES_FOLDER / imageDirectory=${imageDirectory}"

cd ..
ROOT_DIR=`pwd`
echo "ROOT_DIR=${ROOT_DIR}"
echo "WORKSPACE=${WORKSPACE}"

cd ${imageDirectory}

# Install GtGemstoneClient in the image
./bin/GlamorousToolkit-cli GlamorousToolkit.image eval "Metacello new \
	repository: 'github://feenkcom/gt4gemstone:main/src'; \
	baseline: 'GtGemstoneClient'; \
	load."
echo "GtGemstoneClient loaded"

# Ensure the scripts have executable permission
chmod +x pharo-local/iceberg/feenkcom/gt4gemstone/scripts/*.sh
chmod +x pharo-local/iceberg/feenkcom/gt4gemstone/scripts/release/*.sh

# Make the gtoolkit-remote repository accessible
cd pharo-local/iceberg/feenkcom
git clone https://github.com/feenkcom/gtoolkit-remote.git
echo "gtoolkit-remote..."
ls -lh gtoolkit-remote/
chmod +x gtoolkit-remote/scripts/*.sh

cd $WORKSPACE/..
echo "Download GemStone archives if required"
if [ ! -e GemStone64Bit3.7.0-x86_64.Linux.zip ]
then
	wget http://downloads.gemtalksystems.com/pub/GemStone64/3.7.0-Alpha2/GemStone64Bit3.7.0-x86_64.Linux.zip
fi

if [ ! -e GemStoneClientLibs3.7.0-x86_64.Linux.zip ]
then
	wget http://downloads.gemtalksystems.com/pub/GemStone64/3.7.0-Alpha2/GemStoneClientLibs3.7.0-x86_64.Linux.zip
fi

cd ${imageDirectory}
echo "Link to GemStone archives"
ln -s $WORKSPACE/../GemStone64Bit3.7.0-x86_64.Linux.zip
ln -s $WORKSPACE/../GemStoneClientLibs3.7.0-x86_64.Linux.zip

