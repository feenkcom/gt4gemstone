#!/usr/bin/env bash
#
# Run the GT examples against each of the GS versions specified in
#
set -e

ls *.image
status_ls=$?
if [ $status_ls -ne 0 ]
then
  echo "No image file found.  CWD should be the image directory."
  exit 1
fi
image_directory=$(pwd)


DIR=`readlink "$0"` || DIR="$0";
export SCRIPT_DIR="$(cd "$(dirname "${DIR}")" && pwd)"

versionsFile=$SCRIPT_DIR/../gemstone_tested_versions.conf
if [ ! -e "$versionsFile" ]
then
  echo "Unable to find versions file: $versionsFile"
fi



stop_gemstone()
{
  # Shutdown the GemStone servers
  stopstone -i gs64stone DataCurator swordfish
  stopnetldi
}



# Function to extract version numbers from a file, ignoring comments
extract_versions() {
    local version_file="$1"
    
    # Read file, ignore lines starting with #, and output space-separated version list
    grep -v '^#' "$version_file" | tr '\n' ' '
}



clean_up() {
  #stop_gemstone
  if [ -d remote-gemstone ]
  then
    chmod -R +w remote-gemstone
    rm -rf remote-gemstone
  fi  
  if [ -e gt4gemstone-3.7.zip ]
  then
    rm gt4gemstone-3.7.zip
  fi
  if [ -e gt4gemstone-3.7 ]
  then
    rm -rf gt4gemstone-3.7
  fi
}



rename_result_xmls() {
  local gt_version="$1"

  for file in $(ls GToolkit-RemoteExamples-GemStone-*.xml)
  do
    mv $file $gt_version-$file
  done
}


# Function to run the tests on the given GT version
check_gt_version() {
  local gt_version="$1"

  echo "Running tests for: $gt_version"
  clean_up
  export LOAD_GT4GS_VERSION=$gt_version
  $SCRIPT_DIR/run-remote-gemstone-examples.sh
  rename_result_xmls $gt_version
}



# Rename the current junit xml files
rename_result_xmls vdev

versionsList=$(extract_versions $versionsFile)
echo "Checking GT versions: $versionsList"

for version in $versionsList
do
  check_gt_version $version
done
