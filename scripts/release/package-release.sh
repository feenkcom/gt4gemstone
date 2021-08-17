#!/bin/bash

set -e

if [ -z "$ROWAN_PROJECTS_HOME" ]
then
	echo "ROWAN_PROJECTS_HOME must be defined"
	exit 1
fi

if [ -z "$GEMSTONE_WORKSPACE" ]
then
	echo "GEMSTONE_WORKSPACE must be defined"
	exit 1
fi

if [ -z "$GT4GEMSTONE_VERSION" ]
then
	echo "GT4GEMSTONE_VERSION must be defined"
	exit 1
fi

if [ -z "$RELEASED_PACKAGE_GEMSTONE_NAME" ]
then
	echo "RELEASED_PACKAGE_GEMSTONE_NAME must be defined"
	exit 1
fi

GT4GEMSTONE_RELEASE_FOLDER="${GEMSTONE_WORKSPACE}/${RELEASED_PACKAGE_GEMSTONE_NAME}"
echo "GT4GEMSTONE_RELEASE_FOLDER=${GT4GEMSTONE_RELEASE_FOLDER}"
if [ -e $GT4GEMSTONE_RELEASE_FOLDER ]
then
    echo "ERROR: release directory subdirectory already exists"
    exit 1
fi

#Package the required files into an archive
echo "Package release"

SPARKLE_HOME=${ROWAN_PROJECTS_HOME}/Sparkle
GT4GEMSTONE_HOME=${ROWAN_PROJECTS_HOME}/gt4gemstone
GTOOLKIT_REMOTE_HOME=${ROWAN_PROJECTS_HOME}/gtoolkit-remote

mkdir $GT4GEMSTONE_RELEASE_FOLDER
mkdir -p ${GT4GEMSTONE_RELEASE_FOLDER}/Sparkle/src-gs
mkdir -p ${GT4GEMSTONE_RELEASE_FOLDER}/gt4gemstone/src-gs
mkdir -p ${GT4GEMSTONE_RELEASE_FOLDER}/gtoolkit-remote/src-gs

cp ${SPARKLE_HOME}/src-gs/bootstrapSparkle.gs ${GT4GEMSTONE_RELEASE_FOLDER}/Sparkle/src-gs/
cp ${GT4GEMSTONE_HOME}/src-gs/gt4gemstone.gs ${GT4GEMSTONE_RELEASE_FOLDER}/gt4gemstone/src-gs/
cp ${GTOOLKIT_REMOTE_HOME}/src-gs/gtoolkit-remote.gs ${GT4GEMSTONE_RELEASE_FOLDER}/gtoolkit-remote/src-gs/

cp ${GT4GEMSTONE_HOME}/scripts/release/inputRelease.sh ${GT4GEMSTONE_RELEASE_FOLDER}/
cp ${GT4GEMSTONE_HOME}/scripts/release/inputRelease.topaz ${GT4GEMSTONE_RELEASE_FOLDER}/
cp ${GT4GEMSTONE_HOME}/scripts/loginSystemUser.topaz ${GT4GEMSTONE_RELEASE_FOLDER}/

cd ${GEMSTONE_WORKSPACE}
zip -rp ${RELEASED_PACKAGE_GEMSTONE_NAME}.zip ${RELEASED_PACKAGE_GEMSTONE_NAME}

exit 0
