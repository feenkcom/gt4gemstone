#!/usr/bin/env bash
# Generated from live GT: GtGemStoneZincInstallerArtifacts>>preflightScript
set -e
zinc_home="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$zinc_home"
for artifact in dependencies-definitions.topaz dependencies-methods.topaz \
  zinc-definitions.topaz zinc-methods.topaz initialization.topaz \
  begin-import.topaz finish-import.topaz global-bindings.topaz runtime-compatibility.topaz inputZinc.topaz inputZinc.sh \
  native-structure-provenance.json native-socket-api-provenance.json native-socket-provenance.json sport-removal-inventory.json manifest.json manifest.sha256 LICENSE-Zinc.txt LICENSE-GLASS.txt LICENSE-Grease.txt; do
  if [ ! -f "$artifact" ]; then echo "Frozen Zinc export missing: $artifact" >&2; exit 1; fi
done
# The checksum manifest is generated from the same live selection as manifest.json.
# Reject paths outside this directory; require one record for each required file.
while read -r digest artifact trailing; do
  case "$artifact" in
    *[!A-Za-z0-9._-]*|'') echo "Invalid frozen Zinc checksum path" >&2; exit 1 ;;
  esac
  if [[ ! "$digest" =~ ^[0-9a-f]{64}$ || -n "$trailing" ]]; then
    echo "Invalid frozen Zinc checksum record" >&2; exit 1
  fi
done < manifest.sha256
for artifact in dependencies-definitions.topaz dependencies-methods.topaz zinc-definitions.topaz \
  zinc-methods.topaz initialization.topaz global-bindings.topaz runtime-compatibility.topaz begin-import.topaz finish-import.topaz \
  inputZinc.topaz inputZinc.sh native-structure-provenance.json native-socket-api-provenance.json native-socket-provenance.json sport-removal-inventory.json manifest.json preflight.sh LICENSE-Zinc.txt LICENSE-GLASS.txt LICENSE-Grease.txt; do
  if [ "$(awk -v file="$artifact" '$2 == file { n++ } END { print n+0 }' manifest.sha256)" != 1 ]; then
    echo "Frozen Zinc checksum manifest lacks unique entry: $artifact" >&2; exit 1
  fi
done
if command -v sha256sum >/dev/null; then sha256sum -c manifest.sha256
elif command -v shasum >/dev/null; then shasum -a 256 -c manifest.sha256
else echo "A SHA-256 checker (sha256sum or shasum) is required" >&2; exit 1
fi
