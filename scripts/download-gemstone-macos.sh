#!/bin/bash

set -e

if [ -z "$GEMSTONE_WORKSPACE" ]
then
	echo "GEMSTONE_WORKSPACE must be defined"
	exit 1
fi

if [ -z "$GT_GEMSTONE_VERSION" ]
then
	echo "GT_GEMSTONE_VERSION must be defined"
	exit 1
fi

ARCH="$(uname -m)"
case "${ARCH}" in
    arm64 ) 
		GS_SERV_FILE=GemStone64Bit${GT_GEMSTONE_VERSION}-arm64.Darwin
		GS_CLIENT_FILE=GemStoneClientLibs${GT_GEMSTONE_VERSION}-arm64.Darwin
		;;
    * ) 
		GS_SERV_FILE="GemStone64Bit${GT_GEMSTONE_VERSION}-i386.Darwin"
		GS_CLIENT_FILE=GemStoneClientLibs${GT_GEMSTONE_VERSION}-i386.Darwin
		;;
esac

# Download all the required archives, git clones, etc. and upack
if [ ! -f "${GS_SERV_FILE}".dmg ]
then
	wget http://downloads.gemtalksystems.com/pub/GemStone64/${GT_GEMSTONE_VERSION}/"$GS_SERV_FILE".dmg
fi

if [ ! -f "${GS_CLIENT_FILE}".dmg ]
then
	wget http://downloads.gemtalksystems.com/pub/GemStone64/${GT_GEMSTONE_VERSION}/"${GS_CLIENT_FILE}".dmg
fi

hdiutil attach "${GS_SERV_FILE}".dmg
cp -R /Volumes/installGemStone/"${GS_SERV_FILE}" "${GEMSTONE_WORKSPACE}/"
hdiutil detach /Volumes/installGemStone

hdiutil attach "${GS_CLIENT_FILE}".dmg
cp -R /Volumes/"${GS_CLIENT_FILE}"/3.7.1 "${GEMSTONE_WORKSPACE}/"
hdiutil detach /Volumes/"${GS_CLIENT_FILE}"
