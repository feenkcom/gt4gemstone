#!/usr/bin/env bash
# Generated from live GT: GtGemStoneZincInstallerArtifacts>>inputShellScript
set -e
while getopts "s:" opt; do
  case "$opt" in s) STONE=$OPTARG ;; *) exit 1 ;; esac
done
if [ -z "${STONE:-}" ]; then echo "Missing stone name (-s)" >&2; exit 1; fi
export STONE
export GT4GEMSTONE_ZINC_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$GT4GEMSTONE_ZINC_HOME/preflight.sh"
topaz -l -T 200000 -I "$GT4GEMSTONE_ZINC_HOME/../loginSystemUser.topaz" \
  -S "$GT4GEMSTONE_ZINC_HOME/inputZinc.topaz" < /dev/zero
