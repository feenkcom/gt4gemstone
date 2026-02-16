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
  --gt4gs <GT version>
  --gs <gs_version>
  --rowan2
  --rowan3

  If --gt4gs is supplied, gt4gemstone is installed from the specified
  GT version (retrieved from github), otherwise gt4gemstone is installed
  from the local image.  E.g. "--gt4gs v1.0.1501"

  If --gs is supplied, the specified version of GemStone is installed,
  default = 3.7.2.1.

  If --rowan2 or --rowan3 is specified the appropriate Rowan extent is
  loaded instead of the default.

EOF

echo "Default GemStone version: ${GT_GEMSTONE_VERSION}"
}

USE_ROWAN=no
HELP_ONLY=no
LOAD_GT4GS_VERSION=no

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
  GT_GEMSTONE_VERSION="3.7.2.1"
elif [ "$GT_OSNAME" = "Darwin" -a "$VM_ARCH" = "arm64" ]; then
  GT_GEMSTONE_VERSION="3.7.2.1"
elif [ "$GT_OSNAME" = "Darwin" ]; then
  GT_GEMSTONE_VERSION="3.7.2.1"
else
  echo "Unable to determine default gemstone version"
  exit 1
fi

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
      --gt4gs)
          if [[ -n "$2" && "$2" != --* ]]; then
            LOAD_GT4GS_VERSION="$2"
            shift
          fi
          ;;
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

if [[ $USE_ROWAN != "no" && $LOAD_GT4GS_VERSION != "no" ]]
then
  echo "Only one of --rowan and --gt4gs may be used at a time"
  exit
fi

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
  export LOAD_GT4GS_VERSION

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
  if [ ! -d gtoolkit-wireencoding ]
  then
    ln -s pharo-local/iceberg/feenkcom/gtoolkit-wireencoding
  fi
  if [ ! -d gt4llm ]
  then
    ln -s pharo-local/iceberg/feenkcom/gt4llm
  fi


  chmod +x gt4gemstone/scripts/*.sh
  chmod +x gt4gemstone/scripts/release/*.sh
  chmod +x gtoolkit-remote/scripts/*.sh
  chmod +x gt4llm/scripts/*.sh

  export STONE=gs64stone
  export GT4GEMSTONE_VERSION=dev
  export RELEASED_PACKAGE_GEMSTONE_NAME="gt4gemstone-${GT_GEMSTONE_VERSION}-dev"

  echo "Configuration:"
  echo "GT_GEMSTONE_VERSION=$GT_GEMSTONE_VERSION"
  if [ $USE_ROWAN != "no" ]
  then
    echo "ROWAN version=$USE_ROWAN"
  fi
  if [ $LOAD_GT4GS_VERSION != "no" ]
  then
    echo "Loading gt4gs=$LOAD_GT4GS_VERSION"
    export RELEASED_PACKAGE_GEMSTONE_NAME="gt4gemstone-3.7"
  fi
  echo "SCRIPT_DIR=$SCRIPT_DIR"
  echo "STONE=$STONE"
  echo "GT4GEMSTONE_VERSION=$GT4GEMSTONE_VERSION"
  echo "RELEASED_PACKAGE_GEMSTONE_NAME=$RELEASED_PACKAGE_GEMSTONE_NAME"
fi
