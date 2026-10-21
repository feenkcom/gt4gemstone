#!/usr/bin/env bash
# Generated from live GT: GtGemStoneZincInstallerArtifacts>>setupScript
# The non-Rowan installer starts from the original default extent.
# Zinc is opt-in with LOAD_ZINC=yes. Rowan Zinc loading remains unimplemented.
set -e
set -x

started_stone=no
started_netldi=no
stop_servers() {
  if [ "$started_stone" = yes ]; then
    stopstone -i "$STONE" DataCurator swordfish
    started_stone=no
  fi
  if [ "$started_netldi" = yes ]; then
    stopnetldi
    started_netldi=no
  fi
}
on_exit() {
  local status=$?
  set +e
  stop_servers
  exit "$status"
}
start_servers() {
  startnetldi -g
  started_netldi=yes
  startstone "$STONE"
  started_stone=yes
  sleep 1
}

LOAD_ZINC="${LOAD_ZINC:-no}"
case "$LOAD_ZINC" in yes|no) ;; *) echo "LOAD_ZINC must be yes or no" >&2; exit 1 ;; esac
if [[ "$LOAD_ZINC" = yes && -n "${USE_ROWAN:-}" && "$USE_ROWAN" != no ]]; then
  echo "This installer has no tested Rowan Zinc loading path" >&2
  exit 1
fi
export LOAD_ZINC
export STONE=gs64stone
DIR=$(readlink "$0") || DIR="$0"
export SCRIPT_DIR="$(cd "$(dirname "$DIR")" && pwd)"
source "$SCRIPT_DIR/remote-gemstone-env.sh"

if [[ -z "$GEMSTONE_WORKSPACE" || -e "$GEMSTONE_WORKSPACE" ]]; then
  echo "GEMSTONE_WORKSPACE must name a new workspace" >&2
  exit 1
fi
mkdir "$GEMSTONE_WORKSPACE"
mkdir "$GEMSTONE_WORKSPACE/opt"
if [ "$GT_OSNAME" = Linux ]; then
  "$SCRIPT_DIR/download-gemstone-linux.sh"
elif [ "$GT_OSNAME" = Darwin ]; then
  "$SCRIPT_DIR/download-gemstone-macos.sh"
else
  echo "Unsupported platform: $GT_OSNAME" >&2
  exit 1
fi
mkdir "$ROWAN_PROJECTS_HOME"
pushd "$ROWAN_PROJECTS_HOME"
ln -s ../../gt4gemstone
ln -s ../../gtoolkit-remote
ln -s ../../gtoolkit-wireencoding
ln -s ../../gt4llm
popd
chmod +x ./gt4gemstone/scripts/*.sh
chmod +x ./gt4gemstone/scripts/release/*.sh

# Select and completely preflight the release before any service action.
if [[ -z "${USE_ROWAN:-}" || "$USE_ROWAN" = no ]]; then
  if [[ -z "${LOAD_GT4GS_VERSION:-}" || "$LOAD_GT4GS_VERSION" = no ]]; then
    "$ROWAN_PROJECTS_HOME/gt4gemstone/scripts/release/package-release.sh"
    release_home="$GEMSTONE_WORKSPACE/$RELEASED_PACKAGE_GEMSTONE_NAME"
  else
    "$SCRIPT_DIR/download-gt4gemstone.sh" "$LOAD_GT4GS_VERSION"
    mv gt4gemstone-3.7 "$GEMSTONE_WORKSPACE/"
    # Historical archives use this fixed directory, independent of the local package name.
    release_home="$GEMSTONE_WORKSPACE/gt4gemstone-3.7"
  fi
  for artifact in inputRelease.sh inputRelease.topaz loginSystemUser.topaz \
    gt4gemstone/src-gs/Announcements.gs gt4gemstone/src-gs/RemoteServiceReplication.gs \
    gt4gemstone/src-gs/STON.gs gt4gemstone/src-gs/patch-gemstone.gs \
    gt4gemstone/src-gs/gt4gemstone.gs gtoolkit-wireencoding/src-gs/gtoolkit-wireencoding.gs \
    gtoolkit-remote/src-gs/gtoolkit-remote.gs inputVersion.topaz; do
    if [ ! -f "$release_home/$artifact" ]; then
      echo "Selected release lacks required artifact: $artifact" >&2
      exit 1
    fi
  done
  if [ "$LOAD_ZINC" = yes ]; then
    if [ ! -f "$release_home/zinc/preflight.sh" ]; then
      echo "Selected release has no frozen Zinc export; use LOAD_ZINC=no or a release with exports" >&2
      exit 1
    fi
    bash "$release_home/zinc/preflight.sh"
  fi
fi

# gtinstallgs copies the original bin/extent0.dbf; never substitute the GLASS extent.
pushd "$GEMSTONE/install"
"$SCRIPT_DIR/gtinstallgs"
popd
trap on_exit EXIT
start_servers

if [[ -z "${USE_ROWAN:-}" || "$USE_ROWAN" = no ]]; then
  # Always use this selected release's original GT importer and its own frozen Zinc.
  bash "$release_home/inputRelease.sh" -s "$STONE"
  if [ "$LOAD_ZINC" = yes ]; then
    bash "$release_home/zinc/inputZinc.sh" -s "$STONE"
  fi
else
  # Preserve the existing Rowan installation path.
  stop_servers
  pushd "$GEMSTONE/data"
  rm *.log tranlog1.dbf
  mv extent0.dbf extent0.dbf.bak
  if [ "$USE_ROWAN" = rowan2 ]; then
    cp "$GEMSTONE/bin/extent0.rowan.dbf" ./extent0.dbf
  else
    cp "$GEMSTONE/bin/extent0.$USE_ROWAN.dbf" ./extent0.dbf
  fi
  chmod 644 extent0.dbf
  popd
  start_servers
  ./gtoolkit-wireencoding/scripts/installGToolkitWireEncoding_${USE_ROWAN}.sh
  ./gt4gemstone/scripts/installGt4gemstone_${USE_ROWAN}.sh
  ./gtoolkit-remote/scripts/installGtoolkitRemote_${USE_ROWAN}.sh
fi
exit 0
