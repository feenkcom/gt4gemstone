#!/usr/bin/env bash
#
# Retrieve the GemStone archives and set up the environment for setup-remote-gemstone.sh
#
# Note that this file should be sourced, not just run, as it sets environment
# variables to be used in later (manually run) scripts
#
# Inputs:
#	CWD is the Gt image directory
#

function print_help() {
cat << EOF

This script configures GemStone for use in a GT development environment.

It must be run from the development image directory.

Options:
  --gs <gs_version>
  --rowan2
  --rowan3

EOF

echo "Default GemStone version: ${GT_GEMSTONE_VERSION}"
}

USE_ROWAN=no
HELP_ONLY=no

ARCH="$(uname -m)"
VM_ARCH="${ARCH}"
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     GT_OSNAME=Linux;;
    Darwin*)    GT_OSNAME=Darwin;;
    *)          GT_OSNAME="UNKNOWN:${unameOut}"
esac
export GT_OSNAME

if [ "$GT_OSNAME" = "Linux" ]; then
  GT_GEMSTONE_VERSION="3.7.1.4"
elif [ "$GT_OSNAME" = "Darwin" -a "$VM_ARCH" = "arm64" ]; then
  GT_GEMSTONE_VERSION="3.7.1.4"
elif [ "$GT_OSNAME" = "Darwin" ]; then
  GT_GEMSTONE_VERSION="3.7.1.4"
else
  echo "Unable to determine default gemstone version"
  exit 1
fi

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
      --gs)
          if [[ -n "$2" && "$2" != --* ]]; then
             GT_GEMSTONE_VERSION="$2"
             shift
          fi
          ;;
      --rowan2)
          USE_ROWAN=rowan2
          ;;
      --rowan3)
          USE_ROWAN=rowan3
          ;;
      --help)
          print_help
          HELP_ONLY=yes
          ;;
      *)
          ;;
    esac
    shift
done

if [ $HELP_ONLY = "no" ]
then
  ls *.image
  status_ls=$?
  if [ $status_ls -ne 0 ]
  then
    echo "No image file found.  CWD should be the image directory."
    exit 1
  fi
  imageDirectory=$(pwd)
  SCRIPT_DIR="./pharo-local/iceberg/feenkcom/gt4gemstone/scripts"

  echo "Starting Remote Examples Development Setup"

  export GT_GEMSTONE_VERSION
  export USE_ROWAN

  source $SCRIPT_DIR/remote-gemstone-env.sh

  #
  # Link the required repositories to the imageDirectory so they can be found by
  # later scripts
  #
  if [ ! -d gt4gemstone ]
  then
    ln -s pharo-local/iceberg/feenkcom/gt4gemstone
  fi
  if [ ! -d gtoolkit-remote ]
  then
    ln -s pharo-local/iceberg/feenkcom/gtoolkit-remote
  fi

  chmod +x gt4gemstone/scripts/*.sh
  chmod +x gt4gemstone/scripts/release/*.sh
  chmod +x gtoolkit-remote/scripts/*.sh

  export STONE=gs64stone
  export GT4GEMSTONE_VERSION=dev
  export RELEASED_PACKAGE_GEMSTONE_NAME="gt4gemstone-${GT_GEMSTONE_VERSION}-dev"

  echo "Configuration:"
  echo "GT_GEMSTONE_VERSION=$GT_GEMSTONE_VERSION"
  if [ $USE_ROWAN != "no" ]
  then
    echo "ROWAN version=$USE_ROWAN"
  fi
  echo "SCRIPT_DIR=$SCRIPT_DIR"
  echo "STONE=$STONE"
  echo "GT4GEMSTONE_VERSION=$GT4GEMSTONE_VERSION"
  echo "RELEASED_PACKAGE_GEMSTONE_NAME=$RELEASED_PACKAGE_GEMSTONE_NAME"
fi

