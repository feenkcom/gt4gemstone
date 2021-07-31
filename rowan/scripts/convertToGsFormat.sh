#! /bin/bash
### Export gtoolkit-gemstone to a .gs file.
### Requires loginSystemUser.topaz be configured with the correct credentials.
### Exits with 0 if success, topaz status if failed.

gt4GemstoneHome=${ROWAN_PROJECTS_HOME}/gtoolkit-gemstone
## Topaz refuses to exit from script if input is stdin, so redirect from /dev/zero
topaz -l -I ${gt4GemstoneHome}/rowan/scripts/loginSystemUser.topaz  -S ${gt4GemstoneHome}/rowan/scripts/convertToGsFormat.topaz < /dev/zero
status=$?
if [ $status != 0 ]
then
        echo !!!!!!!!!!!!!!!!
        echo Failed to export gtoolkit-gemstone
        echo !!!!!!!!!!!!!!!!
        exit $status
fi

exit 0
