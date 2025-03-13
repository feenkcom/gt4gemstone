#!/bin/bash
#
# Run the remote Pharo examples in GtRemotePharoDeclarativeExamples
#
# Assumes that the environment should be located in `remote-pharo` below the 
# working directory, which is the image directory.
#
set -e
trap stop_servers EXIT

function stop_servers()
{
	# Shutdown the GemStone servers
	stopstone -i gs64stone DataCurator swordfish
	stopnetldi
}

DIR=`readlink "$0"` || DIR="$0";
export SCRIPT_DIR="$(cd "$(dirname "${DIR}")" && pwd)"

# Flag that the GemStone DB should be loaded from git
export USE_ROWAN=rowan2

# Run the examples
$SCRIPT_DIR/run-remote-gemstone-examples.sh

exit 0
