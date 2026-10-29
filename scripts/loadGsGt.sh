#!/usr/bin/env bash
#
# Instructions are in lepiter: `Updating GT.gs and load in to GemStone`.
# 
set -e

if [[ -z ${GT_CURRENT_DIR:-} ]]; then
    echo "Error: GT_CURRENT_DIR is not set or is empty" >&2
    exit 1
fi

if [[ ! -d "$GT_CURRENT_DIR" ]]; then
    echo "Error: GT_CURRENT_DIR is not an existing directory: $GT_CURRENT_DIR" >&2
    exit 1
fi

cd "$GT_CURRENT_DIR"
source pharo-local/iceberg/feenkcom/gt4gemstone/scripts/dev_preconfigure_gemstone.sh
export GEMSTONE_NETLDI_PORT=50377
./gt4gemstone/scripts/inputGT.sh > loadGsGt.log 2>&1
# Output the last 10 lines of the log.  If it shows the commit and
# errorCount is 0, everything worked
tail -n 10 loadGsGt.log
