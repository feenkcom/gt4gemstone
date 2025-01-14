#! /bin/bash
## Generate .gs format file for distribution
## Must be run in a Rowan extent into which RemoteServiceReplication and Announcements have been loaded

## Figure out what directory this script is in
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

## Topaz refuses to exit from script if input is stdin, so redirect from /dev/zero
topaz -l -I ${script_dir}/loginSystemUser.topaz  -S ${script_dir}/convertRsrToGsFormat.topaz < /dev/zero
status=$?
if [ $status != 0 ]
then
        echo !!!!!!!!!!!!!!!!
        echo Failed to export Rsr
        echo !!!!!!!!!!!!!!!!
        exit $status
fi

exit 0
