#! /bin/bash
### Install gtoolkit-gemstone from Tonel files into a Rowan-enabled stone
### Exits with 0 if success, 1 if failed

gt4GemstoneHome=${ROWAN_PROJECTS_HOME}/gtoolkit-gemstone
## Topaz refuses to exit from script if input is stdin, so redirect from /dev/zero
topaz -l -I ${gt4GemstoneHome}/rowan/scripts/loginSystemUser.topaz  -S ${gt4GemstoneHome}/rowan/scripts/installGtoolkit-gemstone.topaz < /dev/zero
if [ $? = 0 ]
    then
        exit 0
    else
        echo !!!!!!!!!!!!!!
        echo INSTALL FAILED
        echo !!!!!!!!!!!!!!
        exit 1
    fi
