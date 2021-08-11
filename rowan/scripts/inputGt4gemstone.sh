#! /bin/bash
### Load gt4gemstone from .gs files into a standard stone
### Exits with 0 if success, 1 if failed

gt4GemstoneHome=${ROWAN_PROJECTS_HOME}/gt4gemstone
## Topaz refuses to exit from script if input is stdin, so redirect from /dev/zero
topaz -l -I ${gt4GemstoneHome}/rowan/scripts/loginSystemUser.topaz  -S ${gt4GemstoneHome}/rowan/scripts/inputGtoolkit-gemstone.topaz < /dev/zero
if [ $? = 0 ]
    then
        exit 0
    else
        echo !!!!!!!!!!!
        echo LOAD FAILED for gt4gemstone
        echo !!!!!!!!!!!
        exit 1
    fi
