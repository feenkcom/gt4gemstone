#!/bin/bash
#
# Run the remote Pharo examples in GtRemotePharoDeclarativeExamples
#
# Assumes that the environment should be located in `remote-pharo` below the 
# working directory, which is the image directory.
#
set -e
trap on_exit EXIT

function stop_servers()
{
	# Shutdown the GemStone servers
	stopstone -i gs64stone DataCurator swordfish
	stopnetldi
}

function on_exit()
{
	local exit_status=$?
	if [ "$exit_status" -ne 0 ]; then
		printf 'ERROR: %s is exiting with status %s\n' "$0" "$exit_status" >&2
	fi
	# Attempt both shutdown commands and preserve the original exit status.
	set +e
	stop_servers
	exit "$exit_status"
}

DIR=`readlink "$0"` || DIR="$0";
export SCRIPT_DIR="$(cd "$(dirname "${DIR}")" && pwd)"

# Install the remote environment, if required
if [ ! -d remote-gemstone ]
then
  echo "Install remote-gemstone..."
	$SCRIPT_DIR/setup-remote-gemstone.sh
fi

echo "Source remote-gemstone-env..."
source $SCRIPT_DIR/remote-gemstone-env.sh

# Start the remote server
echo "Start GemStone..."
if [ ! -z "$GEMSTONE_NETLDI_PORT" ]
then
	GEMSTONE_NETLDI_OPTION="-P $GEMSTONE_NETLDI_PORT"
fi
startnetldi -g $GEMSTONE_NETLDI_OPTION
startstone gs64stone
sleep 1
# Run the remote examples
imageDirectory=`pwd`
cd ..
echo "Run tests..."
./gt-installer --verbose --workspace ${imageDirectory} test --disable-deprecation-rewrites --packages "GToolkit-RemoteExamples-GemStone"

exit 0
