#! /bin/bash
### Export gt4gemstone to a .gs file.
### Requires loginSystemUser.topaz be configured with the correct credentials,
### and the environmental variable STONE to indicate the target stone name.
### Exits with 0 if success, topaz status if failed.

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
topaz -l -I ${gt4GemstoneHome}/scripts/loginSystemUser.topaz  -S ${gt4GemstoneHome}/scripts/convertToGsFormat_rowan3.topaz < /dev/zero
status=$?
if [ $status != 0 ]
then
        echo !!!!!!!!!!!!!!!!
        echo Failed to export gt4gemstone
        echo !!!!!!!!!!!!!!!!
        exit $status
fi

exit 0
