#! /bin/bash
### Load a gt4gemstone from .gs files into a given stone
### Exits with 0 if success, 1 if failed

set -e

error() {
  echo ERROR: $* 1>&2
}

while getopts "s:p:" opt; do
  case $opt in
    s) STONE=$OPTARG ;;
    T) TEMPOBJ=$OPTARG ;;
    p) GSPWD=$OPTARG ;;
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

if [ "a$GSPWD" = "a" ]; then
   GSPWD=swordfish
fi

if [ "a$TEMPOBJ" = "a" ]; then
   TEMPOBJ=200000
fi

export STONE
export GSPWD
export GT4GEMSTONE_RELEASE_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source=$(cat ${GT4GEMSTONE_RELEASE_HOME}/inputRelease.topaz)

topaz -l -T $TEMPOBJ << EOF
set gemstone ${STONE}
set username SystemUser
set password ${GSPWD}
login
${source}
%
commit
logout
quit
EOF

if [ $? = 0 ]
    then
        exit 0
    else
        echo !!!!!!!!!!!
        echo LOAD FAILED for gt4gemstone
        echo !!!!!!!!!!!
        exit 1
fi
