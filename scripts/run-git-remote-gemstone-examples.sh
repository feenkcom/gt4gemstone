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

# Flag that the GemStone DB should be loaded from git
export USE_ROWAN=rowan2

# Run the examples
$SCRIPT_DIR/run-remote-gemstone-examples.sh

exit 0
