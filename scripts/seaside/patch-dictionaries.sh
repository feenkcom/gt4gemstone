#!/usr/bin/env bash
#
# Patch the GT sources to be loaded in the GlamorousToolkitGlobals symbol list.
#
set -e

function update_dictionary ()
{
for file in *.gs; do
  sed -i.bak 's/^[[:space:]]*inDictionary:[[:space:]]*Globals[[:space:]]*$/	inDictionary: GlamorousToolkitGlobals/' "$file"
done
}

pushd "${GEMSTONE_WORKSPACE}/${RELEASED_PACKAGE_GEMSTONE_NAME}"
pushd gt4gemstone/src-gs
update_dictionary
popd
pushd gt4llm/src-gs
update_dictionary
popd
pushd gtoolkit-remote/src-gs
update_dictionary
popd
pushd gtoolkit-wireencoding/src-gs
update_dictionary
popd
popd
