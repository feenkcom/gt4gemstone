#! /bin/bash
### Load a gt4gemstone from .gs files into a given stone
### Exits with 0 if success, 1 if failed

set -e

error() {
  echo ERROR: $* 1>&2
}

while getopts "s:" opt; do
  case $opt in
    s) STONE=$OPTARG ;;
    :)
      error "Option -$OPTARG requires an argument."
      exit 1
     ;;
  esac
done

if [ "a$STONE" = "a" ]; then
  error "Missing stone name parameter."
  exit 1
fi

export STONE

export GT4GEMSTONE_RELEASE_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

## Topaz refuses to exit from script if input is stdin, so redirect from /dev/zero
echo "Installing GT with DataCurator."
topaz -l -I ${GT4GEMSTONE_RELEASE_HOME}/loginDataCurator.topaz  -S ${GT4GEMSTONE_RELEASE_HOME}/inputRelease.topaz < /dev/zero
if [ $? = 0 ]
    then
        exit 0
    else
        echo !!!!!!!!!!!
        echo LOAD FAILED for gt4gemstone
        echo !!!!!!!!!!!
        exit 1
    fi
