#! /bin/bash
### Install gt4gemstone from Tonel files into a Rowan-enabled stone
### Exits with 0 if success, 1 if failed

set -e

if [ -z "$ROWAN_PROJECTS_HOME" ]
then
	echo "ROWAN_PROJECTS_HOME must be defined"
	exit 1
fi

if [ -z "$STONE" ]
then
	echo "STONE must be defined"
	exit 1
fi

gt4GemstoneHome=${ROWAN_PROJECTS_HOME}/gt4gemstone
## Topaz refuses to exit from script if input is stdin, so redirect from /dev/zero
topaz -l -I ${gt4GemstoneHome}/scripts/loginSystemUser.topaz  -S ${gt4GemstoneHome}/scripts/installGtoolkit-gemstone.topaz < /dev/zero
if [ $? = 0 ]
    then
        echo gt4gemstone loaded, now updating Rowan3 extent for use with JfP
    else
        echo !!!!!!!!!!!!!!
        echo INSTALL FAILED for gt4gemstone
        echo !!!!!!!!!!!!!!
        exit 1
    fi

## Update for 3.7.1 and 3.7.1.4 Rowan 3 image and JadeiteForPharo
#
## Topaz refuses to exit from script if input is stdin, so redirect from /dev/zero
topaz -l -I ${gt4GemstoneHome}/scripts/loginSystemUser.topaz  -S ${gt4GemstoneHome}/scripts/updateForRowan3_JfP-gemstone.topaz < /dev/zero
if [ $? = 0 ]
    then
        exit 0
    else
        echo !!!!!!!!!!!!!!
        echo INSTALL FAILED for Rowan 3 JfP update
        echo !!!!!!!!!!!!!!
        exit 1
    fi

