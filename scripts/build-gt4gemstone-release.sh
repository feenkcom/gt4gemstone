#!/bin/bash

set -e

if [ -z "$ROWAN_PROJECTS_HOME" ]
then
	echo "ROWAN_PROJECTS_HOME must be defined"
	exit 1
fi

if [ -z "$GTOOLKIT_EXPECTED_VERSION" ]
then
	echo "GTOOLKIT_EXPECTED_VERSION must be defined"
	exit 1
fi

GT4GEMSTONE_RELESE_FOLDER=${ROWAN_PROJECTS_HOME}/gt4gemstone-${GTOOLKIT_EXPECTED_VERSION}
echo "GT4GEMSTONE_RELESE_FOLDER=${GT4GEMSTONE_RELESE_FOLDER}"
if [ -e $GT4GEMSTONE_RELESE_FOLDER ]
then
    echo "ERROR: release directory subdirectory already exists"
    exit 1
fi

echo "Convert Tonel files to gs files."

#Convert Tonel files to gs.
SPARKLE_HOME=${ROWAN_PROJECTS_HOME}/Sparkle
GT4GEMSTONE_HOME=${ROWAN_PROJECTS_HOME}/gt4gemstone
GTOOLKIT_REMOTE_HOME=${ROWAN_PROJECTS_HOME}/gtoolkit-remote

$GT4GEMSTONE_HOME/scripts/convertToGsFormat.sh
$GTOOLKIT_REMOTE_HOME/scripts/convertToGsFormat.sh

#Package the required files into an archive
echo "Package release"
mkdir $GT4GEMSTONE_RELESE_FOLDER
mkdir -p ${GT4GEMSTONE_RELESE_FOLDER}/Sparkle/src-gs
mkdir -p ${GT4GEMSTONE_RELESE_FOLDER}/gt4gemstone/src-gs
mkdir -p ${GT4GEMSTONE_RELESE_FOLDER}/gtoolkit-remote/src-gs

cp ${SPARKLE_HOME}/src-gs/bootstrapSparkle.gs ${GT4GEMSTONE_RELESE_FOLDER}/Sparkle/src-gs/
cp ${GT4GEMSTONE_HOME}/src-gs/gt4gemstone.gs ${GT4GEMSTONE_RELESE_FOLDER}/gt4gemstone/src-gs/
cp ${GTOOLKIT_REMOTE_HOME}/src-gs/gtoolkit-remote.gs ${GT4GEMSTONE_RELESE_FOLDER}/gtoolkit-remote/src-gs/

cp ${GT4GEMSTONE_HOME}/scripts/release/inputRelease.sh ${GT4GEMSTONE_RELESE_FOLDER}/
cp ${GT4GEMSTONE_HOME}/scripts/release/inputRelease.topaz ${GT4GEMSTONE_RELESE_FOLDER}/
cp ${GT4GEMSTONE_HOME}/scripts/loginSystemUser.topaz ${GT4GEMSTONE_RELESE_FOLDER}/

zip ${GT4GEMSTONE_RELESE_FOLDER}.zip $GT4GEMSTONE_RELESE_FOLDER

exit 0
