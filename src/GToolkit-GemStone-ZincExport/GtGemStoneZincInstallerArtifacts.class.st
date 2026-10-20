"
Live GT source of installer and importer shell/Topaz artifacts for the frozen Zinc export. Generation is separate from installation. Fresh installations retain original GT loading into Globals; Zinc compiles with transient ZincGlobals precedence and remains last in the persistent symbol list. Staging generation precedes deployment and independent review.
"
Class {
	#name : #GtGemStoneZincInstallerArtifacts,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-ZincExport'
}

{ #category : #generation }
GtGemStoneZincInstallerArtifacts class >> artifacts [
	^ OrderedDictionary new
		at: 'setup-remote-gemstone.sh' put: self setupScript;
		at: 'zinc/preflight.sh' put: self preflightScript;
		at: 'zinc/inputZinc.sh' put: self inputShellScript;
		at: 'zinc/inputZinc.topaz' put: self inputTopazScript;
		at: 'zinc/installZinc.topaz' put: self obsoleteInstallScript;
		at: 'zinc/begin-import.topaz' put: self beginImportScript;
		at: 'zinc/finish-import.topaz' put: self finishImportScript;
		at: 'zinc/RUNTIME-CONTRACT.txt' put: self dictionaryContract;
		yourself
]

{ #category : #scripts }
GtGemStoneZincInstallerArtifacts class >> beginImportScript [
	^ GtGemStoneZincSoloHarness zincCompileContextScript
]

{ #category : #scripts }
GtGemStoneZincInstallerArtifacts class >> bindingsScript [
	^ GtGemStoneZincSoloHarness proxyBindingsScript
]

{ #category : #generating }
GtGemStoneZincInstallerArtifacts class >> deployReviewedZincArtifactsFrom: aSourceDirectory to: aDestinationDirectory [
	"Deploy only a complete checksummed reviewed artifact set, through its live GT owner."
	| source destination manifest checksums names |
	source := aSourceDirectory asFileReference.
	destination := aDestinationDirectory asFileReference.
	manifest := STONJSON fromString: (source / 'manifest.json') contents.
	self assert: (manifest at: 'selection') notEmpty.
	(manifest at: 'selection') do: [ :row |
		self assert: ((GtGemStoneZincNativeExporter basicNew historicalSportOwnedClassNames)
			includes: (row at: 3)) not ].
	checksums := Dictionary new.
	(source / 'manifest.sha256') contents lines do: [ :line |
		| fields bytes |
		fields := line substrings.
		self assert: fields size = 2.
		self assert: fields second asFileReference basename = fields second.
		self assert: (checksums includesKey: fields second) not.
		bytes := (source / fields second) binaryContents.
		self assert: (SHA256 hashMessage: bytes) hex = fields first.
		checksums at: fields second put: fields first ].
	names := source files collect: #basename.
	self assert: names asSet = (checksums keys asSet copyWith: 'manifest.sha256').
	#('native-structure-provenance.json' 'native-socket-api-provenance.json' 'native-socket-provenance.json' 'sport-removal-inventory.json')
		do: [ :name | self assert: (names includes: name) ].
	destination ensureCreateDirectory.
	names sorted do: [ :name |
		| bytes |
		bytes := (source / name) binaryContents.
		(destination / name) binaryWriteStreamDo: [ :stream | stream truncate; nextPutAll: bytes ].
		self assert: (destination / name) binaryContents = bytes ].
	(names includes: 'LICENSE-Sport.txt') ifFalse: [
		(destination / 'LICENSE-Sport.txt') ensureDelete ].
	^ { destination fullName. names size }
]

{ #category : #documentation }
GtGemStoneZincInstallerArtifacts class >> dictionaryContract [
	^ 'Frozen Zinc runtime dictionary and load contract

This importer is for a fresh non-Rowan default extent after the original GT release has loaded.
It creates ZincGlobals and compiles exported runtime definitions and methods with ZincGlobals first in a transient symbol list.
It then restores the original symbol list and appends the identical ZincGlobals dictionary last for SystemUser and DataCurator.
The original GT classes remain in Globals. Globals precedes ZincGlobals after import and after ordinary GT code reload.
When a name occurs in both dictionaries, ordinary name lookup therefore selects the GT class.
Native Zinc methods retain their explicitly compiled bindings to ZincGlobals classes.
Application code should select native classes explicitly, for example ZincGlobals at: #ZnResponse and ZincGlobals at: #ZnTransactionSafeManagingMultiThreadedServer.
Do not assume that an unqualified ZnServer or another overlapping name selects this frozen runtime.
Native copies of streams, announcements, encoders, and other overlapping classes remain independent of their Globals counterparts.

The normal installer consumes artifacts belonging to the selected release. It does not use compatibility patches from a different checkout.
LOAD_ZINC=no preserves the original plain-extent GT loading path. The existing Rowan path does not implement this Zinc importer.
This importer is fresh-install-only and makes no upgrade or arbitrary release-reimport guarantee.
Runtime listeners, default servers, networking defaults and managed-server registries are session-local state through reviewed compatibility methods.
No listener is automatically constructed or started during installation.
Pure constants and lookup tables are eagerly initialized by SystemUser before commit so ordinary DataCurator sessions do not need write access to installed classes. eager-initialization-provenance.json records the reviewed statements and source hashes. SocketStreamSocket wraps native GsSocket in TransientStackValue; accepted and outbound sockets remain session-local. Native connect and accept timeout arguments are milliseconds; stream timeouts are seconds. The runtime contains no Sport-owned classes or compiled Sport references.
The exported ObjectLogEntry diagnostic queue, drained log and lock behavior are session-local through reviewed overlays. Entries can be enqueued, drained and cleared in the current session and are discarded when it ends; they are not a durable cross-session GLASS diagnostic log. object-log-provenance.json records this deliberate boundary. Persistent ObjectLog class variables remain nil.

The source and protocol inventory records the isolated managed source environment before compatibility overlays. The upstream GLASS reference remains intact. Historical Sport package inventory is retained as provenance, without installing Sport. LICENSE-Sport.txt, introduced by the exporter for the removed dependency, is omitted from the active release with the Sport dependency. Rollback uses the complete frozen artifacts and checksums preserved before this migration. Class hierarchy changes require a fresh extent; persisted-instance upgrades are outside this contract.
compatibility-provenance.json records runtime method replacements; constructor-provenance.json records the explicit own new methods needed for native initialization.
shared-kernel-provenance.json records the twelve reviewed shared kernel methods whose native bodies and protocols are retained with a managed-extension marker during initial import. Standard GT reload may subsequently apply its original managed adapters through their normal guards.
full-gt-integration-provenance.json records the private ArrayedCollection class-side conversion bridge needed when the GT Object>>as: adapter is restored.
exception-identity-provenance.json records the source, protocol and hashes for the scoped server exception lookup bridge.
Private server exception sets resolve exported native exception classes before ordinary lookup, preserving termination handlers when the GT reload installs classes with overlapping names.
The current full GT export also contains two scoped String bridges: asZnUrl selects private ZincGlobals ZnUrl when installed, and addedToZnUrl: preserves native delimiter handling when its argument is a private ZnUrl. Other arguments retain the original GT behavior.
unicode-dictionary-provenance.json records the scoped key comparison and dictionary-internal source changes, with checks for String/Unicode hash agreement and distinct Symbol keys.
Private ZnMultiValueDictionary normalizes equality only for string keys through reviewed local dictionary internals. Ordinary keys retain their native comparison behavior. This does not enable or emulate GLASS string comparison globally.
Initial validation compares selected source layouts, protocols and compiled global bindings with the reference inventory while accounting for explicit managed overlays. After full GT reload it checks the private runtime layouts, protocols and bindings, original GT bindings, shared adapter behavior, URI conversion, query lookup and mutation, serialization, gzip, static files and session-local runtime state.
The supported reload workflow is the current generated full GT export used by llm/loadGsGt.sh. Reimporting arbitrary historical bootstrap files is outside this fresh-install contract.
'
]

{ #category : #generating }
GtGemStoneZincInstallerArtifacts class >> finalizeChecksumsIn: aDirectory [
	"Call only after all exporter, provenance and importer artifacts have been generated."
	| directory files source |
	directory := aDirectory asFileReference.
	files := (directory files reject: [ :file | file basename = 'manifest.sha256' ]) sorted: [ :a :b | a basename < b basename ].
	source := String streamContents: [ :stream |
		files do: [ :file | | bytes |
			bytes := file binaryReadStreamDo: [ :input | input contents ].
			stream nextPutAll: (SHA256 hashMessage: bytes) hex; nextPutAll: '  '; nextPutAll: file basename; lf ] ].
	(directory / 'manifest.sha256') binaryWriteStreamDo: [ :stream | stream position: 0; truncate. stream nextPutAll: (source) utf8Encoded ].
	^ directory fullName
]

{ #category : #scripts }
GtGemStoneZincInstallerArtifacts class >> finishImportScript [
	^ 'expectvalue true
run
| zinc curator symbols |
zinc := Globals at: #ZincGlobals.
GsSession currentSession transientSymbolList: nil.
(System myUserProfile symbolList last == zinc)
  ifFalse: [ self error: ''Zinc must remain last in the installer symbol list'' ].
curator := AllUsers userWithId: ''DataCurator''.
symbols := curator symbolList copy.
(symbols anySatisfy: [ :dictionary | dictionary name = #ZincGlobals ])
  ifTrue: [ self error: ''DataCurator already has a Zinc dictionary'' ].
symbols addLast: zinc.
curator symbolList: symbols.
#(WAComponent WAApplication Gofer Metacello MCWorkingCopy) do: [ :name |
  (GsSession currentSession symbolList anySatisfy: [ :dictionary | dictionary includesKey: name ])
    ifTrue: [ self error: ''Unexpected framework or package-loader global: '', name asString ] ].
true
%
'
]

{ #category : #scripts }
GtGemStoneZincInstallerArtifacts class >> inputShellScript [
	^ '#!/usr/bin/env bash
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
'
]

{ #category : #scripts }
GtGemStoneZincInstallerArtifacts class >> inputTopazScript [
	^ '! Generated from live GT: GtGemStoneZincInstallerArtifacts>>inputTopazScript
! Fresh installation only. GT has already loaded into its original Globals.
iferr 1 stk
iferr 2 stack
iferr 3 exit
input $GT4GEMSTONE_ZINC_HOME/begin-import.topaz
input $GT4GEMSTONE_ZINC_HOME/dependencies-definitions.topaz
input $GT4GEMSTONE_ZINC_HOME/zinc-definitions.topaz
input $GT4GEMSTONE_ZINC_HOME/global-bindings.topaz
input $GT4GEMSTONE_ZINC_HOME/dependencies-methods.topaz
input $GT4GEMSTONE_ZINC_HOME/zinc-methods.topaz
input $GT4GEMSTONE_ZINC_HOME/runtime-compatibility.topaz
input $GT4GEMSTONE_ZINC_HOME/initialization.topaz
input $GT4GEMSTONE_ZINC_HOME/finish-import.topaz
commit
errorCount
'
]

{ #category : #generating }
GtGemStoneZincInstallerArtifacts class >> installRetainedCurrentGtExportFrom: anEvidenceFile [
	"Temporarily install the exact retained current-image export for the normal reload script."
	| repository current reference bytes |
	repository := IceRepository registry detect: [ :each | each name = 'gt4gemstone' ].
	current := repository location / 'src-gs/GT.gs'.
	reference := repository workingCopy referenceCommit fileSystem / 'src-gs/GT.gs'.
	self assert: current binaryContents = reference binaryContents.
	bytes := anEvidenceFile asFileReference binaryContents.
	current binaryWriteStreamDo: [ :stream | stream truncate; nextPutAll: bytes ].
	self assert: current binaryContents = bytes.
	^ (SHA256 hashMessage: bytes) hex
]

{ #category : #generation }
GtGemStoneZincInstallerArtifacts class >> obsoleteInstallScript [
	^ '! Generated from live GT: GtGemStoneZincInstallerArtifacts>>obsoleteInstallScript
! The former network bootstrap is retired. Use the checksum-preflight shell importer.
iferr 1 stk
iferr 2 stack
iferr 3 exit
run
self error: ''Obsolete Zinc bootstrap. Run bash scripts/zinc/inputZinc.sh -s STONE after the original GT importer on a fresh default extent.''
%
'
]

{ #category : #scripts }
GtGemStoneZincInstallerArtifacts class >> preflightScript [
	^ '#!/usr/bin/env bash
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
    *[!A-Za-z0-9._-]*|'''') echo "Invalid frozen Zinc checksum path" >&2; exit 1 ;;
  esac
  if [[ ! "$digest" =~ ^[0-9a-f]{64}$ || -n "$trailing" ]]; then
    echo "Invalid frozen Zinc checksum record" >&2; exit 1
  fi
done < manifest.sha256
for artifact in dependencies-definitions.topaz dependencies-methods.topaz zinc-definitions.topaz \
  zinc-methods.topaz initialization.topaz global-bindings.topaz runtime-compatibility.topaz begin-import.topaz finish-import.topaz \
  inputZinc.topaz inputZinc.sh native-structure-provenance.json native-socket-api-provenance.json native-socket-provenance.json sport-removal-inventory.json manifest.json preflight.sh LICENSE-Zinc.txt LICENSE-GLASS.txt LICENSE-Grease.txt; do
  if [ "$(awk -v file="$artifact" ''$2 == file { n++ } END { print n+0 }'' manifest.sha256)" != 1 ]; then
    echo "Frozen Zinc checksum manifest lacks unique entry: $artifact" >&2; exit 1
  fi
done
if command -v sha256sum >/dev/null; then sha256sum -c manifest.sha256
elif command -v shasum >/dev/null; then shasum -a 256 -c manifest.sha256
else echo "A SHA-256 checker (sha256sum or shasum) is required" >&2; exit 1
fi
'
]

{ #category : #generating }
GtGemStoneZincInstallerArtifacts class >> preserveCurrentGtExportAndRestoreReferenceTo: anEvidenceFile [
	"Retain tested current-image export as evidence; keep the selected-release tracked export unchanged."
	| repository current reference bytes evidence |
	repository := IceRepository registry detect: [ :each | each name = 'gt4gemstone' ].
	current := repository location / 'src-gs/GT.gs'.
	evidence := anEvidenceFile asFileReference.
	evidence parent ensureCreateDirectory.
	evidence binaryWriteStreamDo: [ :stream | stream truncate; nextPutAll: current binaryContents ].
	reference := repository workingCopy referenceCommit fileSystem / 'src-gs/GT.gs'.
	bytes := reference binaryContents.
	current binaryWriteStreamDo: [ :stream | stream truncate; nextPutAll: bytes ].
	self assert: current binaryContents = bytes.
	^ { evidence fullName. (SHA256 hashMessage: bytes) hex }
]

{ #category : #generating }
GtGemStoneZincInstallerArtifacts class >> recordReleaseArchiveChecksumFor: anArchive [
	| file checksum |
	file := anArchive asFileReference.
	checksum := (SHA256 hashMessage: file binaryContents) hex.
	(file parent / (file basename , '.sha256')) writeStreamDo: [ :stream |
		stream truncate; nextPutAll: checksum; nextPutAll: '  '; nextPutAll: file basename; lf ].
	^ checksum
]

{ #category : #saving }
GtGemStoneZincInstallerArtifacts class >> saveLiveSourcesToWorkingCopy [
	"Persist only the reviewed live sources. Do not stage, commit or generate artifacts."
	| repository packages helperNames descriptorSelectors difference selected filtered |
	repository := IceRepository registry detect: [ :each | each name = 'gt4gemstone' ].
	packages := #('GToolkit-GemStone-ZincExport' 'GToolkit-GemStone-Pharo').
	helperNames := (PackageOrganizer default packageNamed: 'GToolkit-GemStone-ZincExport') definedClasses collect: [ :each | each name ].
	descriptorSelectors := #().
	(repository workingCopy modifiedPackages anySatisfy: [ :package | (packages includes: package name) not ])
		ifTrue: [ self error: 'Unrelated live package modifications; source save refused' ].
	difference := IceDiff new
		sourceVersion: repository workingCopy;
		targetVersion: repository workingCopy referenceCommit;
		buildForPackages: (packages collect: [ :name | repository workingCopy packageNamed: name ]);
		yourself.
	selected := OrderedCollection new.
	difference tree do: [ :node | | operation definition allowed |
		operation := node value.
		operation hasChanges ifTrue: [
			definition := operation definition.
			allowed := definition isMethodDefinition
				ifTrue: [ (helperNames includes: definition className asString) or: [
					(definition className asString = 'GtGemStoneGtCodeExporter' and: [ definition classIsMeta not and: [ #(#unsupportedGeoSpherePointMethods #unsupportedPersonalRagMethods) includes: definition selector ] ]) or: [
					definition className asString = 'GtGemStoneExtensionMethods'
						and: [ definition classIsMeta and: [ descriptorSelectors includes: definition selector ] ] ] ] ]
				ifFalse: [ definition isClassDefinition and: [ helperNames anySatisfy: [ :name |
					definition name asString = name or: [ definition name asString = (name, ' class') ] ] ] ].
			allowed ifFalse: [ self error: 'Unrelated source operation; source save refused: ', definition printString ].
			selected add: node ] ].
	selected ifEmpty: [ ^ #noChanges ].
	filtered := difference copyWithOnly: selected.
	repository index updateDiskWorkingCopy: filtered.
	^ { #savedWithoutCommit. selected size. repository name }
]

{ #category : #scripts }
GtGemStoneZincInstallerArtifacts class >> setupScript [
	^ '#!/usr/bin/env bash
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
  # Always use this selected release''s original GT importer and its own frozen Zinc.
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
'
]

{ #category : #validation }
GtGemStoneZincInstallerArtifacts class >> verifyPackagedZincIn: anArchive prefix: aPrefix against: aDirectory [
	| archive source records count |
	source := aDirectory asFileReference.
	archive := ZipArchive new readFrom: anArchive asFileReference.
	[
		records := (archive memberNamed: aPrefix , 'manifest.sha256') contents utf8Decoded lines.
		count := 0.
		records do: [ :line |
			| fields member bytes |
			fields := line substrings.
			self assert: fields size = 2.
			member := archive memberNamed: aPrefix , fields second.
			self assert: member notNil.
			bytes := member contents asByteArray.
			self assert: (SHA256 hashMessage: bytes) hex = fields first.
			self assert: bytes = (source / fields second) binaryContents.
			count := count + 1 ].
		self assert: (STONJSON fromString: (archive memberNamed: aPrefix , 'native-socket-provenance.json') contents utf8Decoded) size = GtGemStoneZincRuntimeCompatibility nativeSocketMethodSpecifications size.
		^ count
	] ensure: [ archive close ]
]

{ #category : #generating }
GtGemStoneZincInstallerArtifacts class >> writeTo: aDirectory [
	| directory |
	directory := aDirectory asFileReference.
	directory ensureCreateDirectory.
	self artifacts keysAndValuesDo: [ :relative :source | | file |
		file := directory / relative.
		file parent ensureCreateDirectory.
		file binaryWriteStreamDo: [ :stream | stream position: 0; truncate. stream nextPutAll: source withUnixLineEndings utf8Encoded ] ].
	^ directory fullName
]

{ #category : #generating }
GtGemStoneZincInstallerArtifacts class >> writeZincImportersTo: aDirectory [
	| directory |
	directory := aDirectory asFileReference.
	directory ensureCreateDirectory.
	self artifacts keysAndValuesDo: [ :relative :source |
		(relative beginsWith: 'zinc/') ifTrue: [
			(directory / (relative allButFirst: 5)) binaryWriteStreamDo: [ :stream | stream position: 0; truncate. stream nextPutAll: source withUnixLineEndings utf8Encoded ] ] ].
	^ directory fullName
]
