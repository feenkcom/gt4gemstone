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

# Install the remote environment, if required
if [ ! -d remote-gemstone ]
then
	$SCRIPT_DIR/setup-remote-gemstone.sh
fi

source $SCRIPT_DIR/remote-gemstone-env.sh

# Start the remote server
startnetldi -g
startstone
sleep 1
# Run the remote examples
imageDirectory=`pwd`
cd ..
./gt-installer --verbose --workspace ${imageDirectory} test --disable-deprecation-rewrites --packages "GToolkit-RemoteExamples-GemStone"

exit 0
