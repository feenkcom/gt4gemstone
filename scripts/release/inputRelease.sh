#! /bin/bash
### Load a gt4gemstone from .gs files into a standard stone
### Exits with 0 if success, 1 if failed

set -e

export GT4GEMSTONE_RELEASE_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

## Topaz refuses to exit from script if input is stdin, so redirect from /dev/zero
topaz -l -I ${GT4GEMSTONE_RELEASE_HOME}/loginSystemUser.topaz  -S ${GT4GEMSTONE_RELEASE_HOME}/inputRelease.topaz < /dev/zero
if [ $? = 0 ]
    then
        exit 0
    else
        echo !!!!!!!!!!!
        echo LOAD FAILED for gt4gemstone
        echo !!!!!!!!!!!
        exit 1
    fi
