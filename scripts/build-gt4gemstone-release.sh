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

#Convert Tonel files to gs.
SPARKLE_HOME=${ROWAN_PROJECTS_HOME}/Sparkle
GT4GEMSTONE_HOME=${ROWAN_PROJECTS_HOME}/gt4gemstone
GTOOLKIT_REMOTE_HOME=${ROWAN_PROJECTS_HOME}/gtoolkit-remote

$GT4GEMSTONE_HOME/scripts/convertToGsFormat.sh
$GTOOLKIT_REMOTE_HOME/scripts/convertToGsFormat.sh

#Package the required files into an archive
$GT4GEMSTONE_RELESE_FOLDER=${ROWAN_PROJECTS_HOME}/gt4gemstone-${GTOOLKIT_EXPECTED_VERSION}
if [ -e $GT4GEMSTONE_RELESE_FOLDER ]
then
	echo "ERROR: release directory subdirectory already exists"
	exit 1
fi

mkdir $GT4GEMSTONE_RELESE_FOLDER
mkdir ${GT4GEMSTONE_RELESE_FOLDER}/Sparkle/src-gs
mkdir ${GT4GEMSTONE_RELESE_FOLDER}/gt4gemstone/src-gs
mkdir ${GT4GEMSTONE_RELESE_FOLDER}/gtoolkit-remote/src-gs 

cp ${SPARKLE_HOME}/src-gs/bootstrapSparkle.gs ${GT4GEMSTONE_RELESE_FOLDER}/Sparkle/src-gs/
cp ${GT4GEMSTONE_HOME}/src-gs/gt4gemstone.gs ${GT4GEMSTONE_RELESE_FOLDER}/gt4gemstone/src-gs/
cp ${GTOOLKIT_REMOTE_HOME}/src-gs/gtoolkit-remote.gs ${GT4GEMSTONE_RELESE_FOLDER}/gtoolkit-remote/src-gs/

cp ${GT4GEMSTONE_HOME}/src-gs/inputRelease.sh ${GT4GEMSTONE_RELESE_FOLDER}/
cp ${GT4GEMSTONE_HOME}/src-gs/inputRelease.topaz ${GT4GEMSTONE_RELESE_FOLDER}/
cp ${GT4GEMSTONE_HOME}/src-gs/loginSystemUser.topaz ${GT4GEMSTONE_RELESE_FOLDER}/

exit 0