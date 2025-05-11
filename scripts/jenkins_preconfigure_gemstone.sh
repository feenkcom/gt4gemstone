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
echo "GEMSTONE_WORKSPACE=${GEMSTONE_WORKSPACE}"
echo "GT4GEMSTONE_VERSION=${GT4GEMSTONE_VERSION}"
echo "RELEASED_PACKAGE_GEMSTONE_NAME=${RELEASED_PACKAGE_GEMSTONE_NAME}"

cd $WORKSPACE/..
echo "Download GemStone archives if required in $(pwd)"
if [ ! -e GemStone64Bit3.7.2.1-x86_64.Linux.zip ]
then
	echo "Preconfigure: Downloading GS to `pwd`"
	wget http://downloads.gemtalksystems.com/pub/GemStone64/3.7.2.1/GemStone64Bit3.7.2.1-x86_64.Linux.zip
fi

if [ ! -e GemStoneClientLibs3.7.2.1-x86_64.Linux.zip ]
then
	echo "Preconfigure: Downloading GS Libs to `pwd`"
	wget http://downloads.gemtalksystems.com/pub/GemStone64/3.7.2.1/GemStoneClientLibs3.7.2.1-x86_64.Linux.zip
fi

cd ${imageDirectory}
echo "Link to GemStone archives in $(pwd)"
ln -s $WORKSPACE/../GemStone64Bit3.7.2.1-x86_64.Linux.zip
ln -s $WORKSPACE/../GemStoneClientLibs3.7.2.1-x86_64.Linux.zip
