#! /bin/bash
## Generate .gs format file for distribution
## Must be run in a Rowan extent into which RemoteServiceReplication and Announcements have been loaded

echo "convertRsrToGsFormat currently doesn't export Announcements since it is part of a base rowan3 extent, so the resulting .gs files aren't usable in a default base extent."
echo "i.e. don't use this for now."
exit 1

if [ -z "$ROWAN_PROJECTS_HOME" ]
then
	echo "ROWAN_PROJECTS_HOME must be defined"
	exit 1
fi

if [ -z "$STONE" ]
then
	STONE=gs64stone
fi

## Figure out what directory this script is in
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

## Topaz refuses to exit from script if input is stdin, so redirect from /dev/zero
topaz -l -I ${script_dir}/loginSystemUser.topaz  -S ${script_dir}/convertRsrToGsFormat_rowan3.topaz < /dev/zero
status=$?
if [ $status != 0 ]
then
        echo !!!!!!!!!!!!!!!!
        echo Failed to export Rsr
        echo !!!!!!!!!!!!!!!!
        exit $status
fi

exit 0
