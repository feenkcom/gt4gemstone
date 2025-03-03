#!/usr/bin/env bash
set -e

# Function to extract image_version from YAML file
extract_image_version() {
    local yaml_file="$1"
    
    # Extract major, minor, and patch values using grep and awk
    local major=$(grep -A 3 "image_version:" "$yaml_file" | grep "major:" | awk '{print $2}')
    local minor=$(grep -A 3 "image_version:" "$yaml_file" | grep "minor:" | awk '{print $2}')
    local patch=$(grep -A 3 "image_version:" "$yaml_file" | grep "patch:" | awk '{print $2}')
    
    # Print the version number
    echo "v$major.$minor.$patch-dev"
}

ls *.image
status_ls=$?
if [ $status_ls -ne 0 ]
then
  echo "No image file found.  CWD should be the image directory."
  exit 1
fi
imageDirectory=$(pwd)

if [ -z "$ROWAN_PROJECTS_HOME" ]
then
	echo "ROWAN_PROJECTS_HOME must be defined"
	exit 1
fi

# Fixed parameters
yaml_file="gtoolkit.yaml"
topaz_file="/tmp/set_gt_version.topaz"

GT_VERSION=$(extract_image_version $yaml_file)
echo "Setting GtGsRelease versionString: $GT_VERSION"

cat >$topaz_file <<EOF
	iferr 1 stk
	iferr 2 stack
	iferr 3 exit

	expectvalue true
	run

	GtGsRelease versionString: '$GT_VERSION'.
  true.
%
	commit
	errorCount
EOF

gt4GemstoneHome=${ROWAN_PROJECTS_HOME}/gt4gemstone
topaz -l -I ${gt4GemstoneHome}/scripts/loginSystemUser.topaz  -S $topaz_file < /dev/null
if [ $? = 0 ]
    then
        echo "GtGsRelease versionString set"
    else
        echo !!!!!!!!!!!!!!
        echo ERROR: failed to set GtGsRelease versionString
        echo !!!!!!!!!!!!!!
        exit 1
    fi
