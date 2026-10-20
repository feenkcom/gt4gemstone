"
Exports an explicit dictionary-qualified manifest from a live GemStone source session using native Topaz fileout APIs. No remote state is committed. The six manifest fields are group, source dictionary, class name, define flag, instance selectors and class selectors. Shared classes export selected methods only. Native source, protocols, class layout and comments are preserved. Initialization must be reviewed separately; this class never snapshots live class variable values.
"
Class {
	#name : #GtGemStoneZincNativeExporter,
	#superclass : #Object,
	#instVars : [
		'session',
		'selection',
		'targetDictionary',
		'additionalArtifacts'
	],
	#category : #'GToolkit-GemStone-ZincExport'
}

{ #category : #accessing }
GtGemStoneZincNativeExporter >> additionalArtifacts [
	^ additionalArtifacts ifNil: [ Dictionary new ]
]

{ #category : #accessing }
GtGemStoneZincNativeExporter >> additionalArtifacts: aDictionary [
	"Reviewed initialization and verbatim license notices may accompany native source."
	aDictionary keysAndValuesDo: [ :name :source |
		self assert: (name notEmpty and: [ name allSatisfy: [ :each |
			each isAlphaNumeric or: [ '._-' includes: each ] ] ]).
		self assert: name ~= 'manifest.json'.
		self assert: source isString ].
	additionalArtifacts := aDictionary
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> applyNativeSocketAdaptationToIsolatedSource [
	"Caller must provide an isolated source session. Never use against the preserved upstream reference.
	All GemStone source comes from reviewed live GT-managed method specifications."
	| specifications |
	session = GtGemStoneSessionRegistry defaultSession ifTrue: [
		self error: 'Refusing class restructuring in the default session' ].
	session evaluateAndWait: GtGemStoneZincRuntimeCompatibility nativeSocketRestructuringSource
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false.
	specifications := GtGemStoneZincRuntimeCompatibility nativeSocketMethodSpecifications.
	session evaluateBlockAndWait: [ :specs |
		| dictionary symbolList |
		symbolList := System myUserProfile symbolList.
		dictionary := symbolList detect: [ :each | each name = #UserGlobals ].
		specs do: [ :spec |
			| behavior |
			behavior := dictionary at: (spec at: 'class') asSymbol.
			(spec at: 'classSide') ifTrue: [ behavior := behavior class ].
			behavior compileMethod: (spec at: 'source')
				dictionaries: symbolList category: (spec at: 'protocol') asSymbol environmentId: 0 ].
		true ]
		withArguments: { specifications }
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false.
	^ specifications size
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> applyNativeSocketMethodsToIsolatedSource [
	"Caller must provide an isolated source session. Never use against the preserved upstream reference.
	All GemStone source comes from reviewed live GT-managed method specifications."
	| specifications |
	session = GtGemStoneSessionRegistry defaultSession ifTrue: [
		self error: 'Refusing class restructuring in the default session' ].
	specifications := GtGemStoneZincRuntimeCompatibility nativeSocketMethodSpecifications.
	session evaluateBlockAndWait: [ :specs |
		| dictionary symbolList |
		symbolList := System myUserProfile symbolList.
		dictionary := symbolList detect: [ :each | each name = #UserGlobals ].
		specs do: [ :spec |
			| behavior |
			behavior := dictionary at: (spec at: 'class') asSymbol.
			(spec at: 'classSide') ifTrue: [ behavior := behavior class ].
			behavior compileMethod: (spec at: 'source')
				dictionaries: symbolList category: (spec at: 'protocol') asSymbol environmentId: 0 ].
		true ]
		withArguments: { specifications }
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false.
	^ specifications size
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> artifacts [
	| records artifacts manifest sorted groups |
	self validateSelection.
	self validateSportIndependence.
	records := self nativeRecords.
	sorted := self definitionRecordsInLoadOrder: records.
	artifacts := OrderedDictionary new.
	groups := (selection collect: #first) asSet sorted.
	groups do: [ :group |
		artifacts at: group , '-definitions.topaz' put: (String streamContents: [ :stream |
			stream nextPutAll: 'fileformat utf8'; lf.
			(sorted select: [ :row | row first = group ]) do: [ :row |
				stream nextPutAll: (self normalizedDefinition: (row at: 6)) ] ]).
		artifacts at: group , '-methods.topaz' put: (String streamContents: [ :stream |
			stream nextPutAll: 'fileformat utf8'; lf.
			((records select: [ :row | row first = group ]) sorted: [ :a :b | (a at: 2) , '/' , (a at: 3) < ((b at: 2) , '/' , (b at: 3)) ])
				do: [ :row | stream nextPutAll: (row at: 7) ] ]) ].
	self additionalArtifacts keys sorted do: [ :name |
		self assert: (artifacts includesKey: name) not.
		artifacts at: name put: (self additionalArtifacts at: name) ].
	manifest := OrderedDictionary new
		at: 'schema' put: 1;
		at: 'generator' put: self class name;
		at: 'nativeAPIs' put: #('Behavior>>fileOutClassDefinitionOn:' 'Behavior>>fileOutMethod:environmentId:on:');
		at: 'targetDictionary' put: targetDictionary;
		at: 'additionalArtifacts' put: self additionalArtifacts keys sorted asArray;
		at: 'excludedFeatures' put: #('ZnMonticelloServerDelegate: requires Monticello tooling' 'ZnTestRunnerDelegate: requires test tooling' 'SocketStreamTest: test class' 'PackageInfo: package metadata tooling' 'MCFileTreeFileDirectoryUtils and MCFileTreeFileUtils: loader filesystem integration');
		at: 'excludedSupportTests' put: #('OverriddenBaseMethodsTest' 'SentButNotImplementedTest' 'SpExceptionTest' 'SpExceptionTests' 'SpFilenameTest' 'ZipCrcTests' 'ZipWriteStreamTests');
		at: 'sourceZincRepositoryRevision' put: '506aedabd409ce8221ddafd725381a7a0e6df27d';
		at: 'regeneration' put: 'GtGemStoneZincNativeExporter new session: isolatedManagedSourceSession; exportSportFreeTo: outputDirectory';
		at: 'runtimeDependencyPolicy' put: 'Sport-free definitions, superclass ancestry, compiled class associations and class-name symbols; executable managed companions checked separately';
		at: 'sourcePackageInventoryScope' put: 'Historical package inventory of isolated GLASS-derived source; does not describe installed runtime packages';
		at: 'sourceGemStoneVersion' put: session gemstoneVersionString;
		at: 'sourcePackageVersions' put: (self sourcePackageVersions sorted: [ :a :b | a first < b first ]);
		at: 'selection' put: self canonicalSelection;
		at: 'sourceIdentities' put: (records collect: [ :row | row copyFrom: 1 to: 5 ]) asArray;
		at: 'artifactSHA256' put: (artifacts collect: [ :source | (SHA256 hashMessage: source utf8Encoded) hex ]);
		yourself.
	artifacts at: 'manifest.json' put: (NeoJSONWriter toStringPretty: manifest).
	^ artifacts
]

{ #category : #selection }
GtGemStoneZincNativeExporter >> candidateSelection [
	"Prototype selection: reviewed runtime package families and directly required support classes.
	Further clean-load validation is required before installation use."
	| candidates merged |
	candidates := OrderedCollection new.
	candidates addAll: (self selectionForDictionary: 'Globals'
		classNames: #('Stream' 'PositionableStream' 'ReadStream' 'WriteStream') group: 'dependencies').
	candidates addAll: (self selectionForClassNames:
		#('SqNumberParser' 'NumberParser' 'AssertionFailure' 'Announcer' 'AnsiReadStream' 'Base64MimeConverter' 'FileDirectory' 'FileStream'
		'GRPlatform' 'GRSmallDictionary' 'GZipWriteStream' 'HTTPSocket' 'MIMEDocument'
		'ObjectLogEntry' 'ReadWriteStream' 'RWBinaryOrTextStream' 'ServerFileDirectory'
		'TimeStamp' 'TranscriptProxy' 'TransientMutex'
		'TransientStackValue' 'Url' 'UUID' 'SmalltalkProxy' 'DynamicVariable' 'ProcessLocalVariable'
		'Announcement' 'AnnouncementSet' 'AnnouncerSubscription'
		'ActionSequence' 'BinaryOrTextFile' 'ClientFileDirectory' 'DirectoryEntry' 'FastUUIDGenerator'
		'MessageSend' 'Month' 'SecureHashAlgorithm' 'TransientRecursionLock' 'UTF8Encoding' 'WordArray' 'ZipEncoderTree'
		'InvalidUtf8Error' 'UTF8PrimitiveEncoding' 'ThirtyTwoBitRegister' 'Year' 'ZipEncoderNode')
		group: 'dependencies').
	candidates addAll: (self selectionForPackageNames:
		#('GemStone-Compression' 'Network-Url' 'Network-Url35x'
		'Grease-Core' 'Grease-GemStone-Core' 'Grease-GemStone-Kernelv360'
		'Grease-GemStone-Kernelv370' 'Grease-GemStone300-Core' 'Grease-GemStone330-Core'
		'GsSqueakCommon-Core' 'GsSqueakCommon-Core.3x' 'GsSqueakCommon-CoreV30'
		'Regex-Core' 'GemStone-ANSI-Streams')
		group: 'dependencies' excluding: #()).
	candidates addAll: self requiredKernelExtensions.
	candidates addAll: self rootSelection.
	candidates addAll: (self selectionForClassNames:
		((candidates select: [ :row | (row at: 4) and: [ (row at: 2) = 'UserGlobals' ] ]) collect: [ :row | row at: 3 ]) asArray
		group: 'dependencies').
	merged := Dictionary new.
	candidates do: [ :row |
		| key existing |
		key := (row at: 2) , '::' , (row at: 3).
		existing := merged at: key ifAbsent: [ nil ].
		existing ifNil: [ merged at: key put: row copy ]
			ifNotNil: [
				existing at: 4 put: ((existing at: 4) or: [ row at: 4 ]).
				5 to: 6 do: [ :index | existing at: index put:
					((existing at: index) , (row at: index)) asSet asArray ].
				(row first = 'zinc' and: [ row at: 4 ]) ifTrue: [ existing at: 1 put: 'zinc' ] ] ].
	merged values do: [ :row | (row at: 3) = 'SocketStreamSocket' ifTrue: [ row at: 1 put: 'dependencies' ] ].
	^ (self prunePrototypeSelection: merged values) reject: [ :row | self sportOwnedClassNames includes: (row at: 3) ]
]

{ #category : #selection }
GtGemStoneZincNativeExporter >> canonicalSelection [
	^ ((selection collect: [ :row | { row at: 1. row at: 2. row at: 3. row at: 4.
		(row at: 5) sorted asArray. (row at: 6) sorted asArray } ])
		sorted: [ :a :b | (a first , '/' , (a at: 2) , '/' , (a at: 3))
			< (b first , '/' , (b at: 2) , '/' , (b at: 3)) ]) asArray
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> currentCompanionProvenance [
	^ OrderedDictionary new
		at: 'eager-initialization-provenance.json' put: (NeoJSONWriter toStringPretty: GtGemStoneZincRuntimeCompatibility eagerInitializationProvenance) utf8Encoded;
		at: 'object-log-provenance.json' put: (NeoJSONWriter toStringPretty: GtGemStoneZincRuntimeCompatibility objectLogProvenance) utf8Encoded;
		yourself
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> definitionRecordsInLoadOrder: records [
	"Topological order includes superclass and pool owner dependencies."
	| pending ordered definedNames emitted |
	pending := (records sorted: [ :a :b |
		(a at: 2) , '/' , (a at: 3) < ((b at: 2) , '/' , (b at: 3)) ]) asOrderedCollection.
	definedNames := (records select: [ :row | (row at: 6) notEmpty ]) collect: [ :row | row at: 3 ].
	ordered := OrderedCollection new.
	emitted := Set new.
	[ pending notEmpty ] whileTrue: [
		| ready |
		ready := pending detect: [ :row |
			(({ row at: 9 } , (row at: 8)) reject: [ :name | name = (row at: 3) ])
				allSatisfy: [ :name | (definedNames includes: name) not or: [ emitted includes: name ] ] ]
			ifNone: [ self error: 'Class superclass/pool dependency cycle in export manifest' ].
		ordered add: ready.
		emitted add: (ready at: 3).
		pending remove: ready ].
	^ ordered
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> exportSportFreeTo: aDirectory [
	"Use only an isolated, managed modified source session. Fully regenerate native definitions and methods."
	self selection: self candidateSelection.
	self validateSportIndependence.
	self additionalArtifacts: self prototypeAdditionalArtifacts.
	^ self exportTo: aDirectory
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> exportTo: aDirectory [
	"Write exact UTF8 bytes, truncating before writing."
	^ self writeArtifacts: self artifacts to: aDirectory
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> fullGtIntegrationProvenance [
	"Current integration adapters, distinct from the historical GT bodies frozen in shared-kernel-provenance.json."
	^ #(
		#(ext_String_asZnUrl 'Prefer the installed private ZincGlobals ZnUrl identity during normal full GT reload; retain the original GT fallback when Zinc is absent.')
		#(ext_String_addedToZnUrl_ 'Retain native omission of empty path segments for private Zinc URLs while preserving existing GT subStrings: behavior for other URL identities.')) collect: [ :spec |
		| extension factorySource |
		extension := GtGemStoneExtensionMethods perform: spec first.
		factorySource := (GtGemStoneExtensionMethods class compiledMethodAt: spec first) sourceCode.
		OrderedDictionary new
			at: 'descriptorClass' put: 'GtGemStoneExtensionMethods';
			at: 'descriptorSelector' put: spec first asString;
			at: 'descriptorSource' put: factorySource;
			at: 'descriptorSHA256' put: (SHA256 hashMessage: factorySource utf8Encoded) hex;
			at: 'targetClass' put: extension className asString;
			at: 'targetSelector' put: extension selector asString;
			at: 'targetClassSide' put: extension meta;
			at: 'targetProtocol' put: extension protocol asString;
			at: 'expectedOriginalHash' put: extension hash asString;
			at: 'targetSource' put: extension source;
			at: 'targetSHA256' put: (SHA256 hashMessage: extension source utf8Encoded) hex;
			at: 'reason' put: spec second;
			at: 'historicalEvidence' put: 'shared-kernel-provenance.json records the original pre-integration GT bodies; this artifact records the current full GT reload adapters.';
			yourself ]
]

{ #category : #analysis }
GtGemStoneZincNativeExporter >> globalReferences [
	"Compiled association identity evidence. This is candidate dependency evidence,
	not a claim that reflective access or required message extensions are covered."
	^ session evaluateBlockAndWait: [ :rows |
		| references dictionaries |
		references := Dictionary new.
		dictionaries := System myUserProfile symbolList.
		rows do: [ :row |
			| behavior sourceDictionary |
			sourceDictionary := dictionaries detect: [ :each | each name asString = (row at: 2) ].
			behavior := sourceDictionary at: (row at: 3) asSymbol.
			{ { behavior. row at: 5. 'instance' }. { behavior class. row at: 6. 'class' } } do: [ :side |
				(side at: 2) do: [ :selector |
					((side first compiledMethodAt: selector asSymbol) literals
						select: [ :literal | literal isKindOf: Association ]) do: [ :literal |
						| home key entry |
						home := dictionaries detect: [ :dict |
							(dict associationAt: literal key ifAbsent: [ nil ]) == literal ] ifNone: [ nil ].
						home notNil ifTrue: [
							key := home name asString , '::' , literal key asString.
							entry := references at: key ifAbsentPut: [
								{ home name asString. literal key asString. literal value class name asString.
								literal value isBehavior. literal value asOop. OrderedCollection new } ].
							(entry at: 6) add: { row at: 2. row at: 3. side at: 3. selector } ] ] ] ] ].
		(references values asSortedCollection: [ :a :b | (a at: 2) < (b at: 2) ])
			collect: [ :entry | entry at: 6 put: (entry at: 6) asArray. entry ] ]
		withArguments: { self canonicalSelection }
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false
]

{ #category : #analysis }
GtGemStoneZincNativeExporter >> historicalSportOwnedClassNames [
	"Stable ownership inventory captured before the migration, even when Sport is absent."
	^ #('HTTPSocketError' 'SpAbstractError' 'SpDate' 'SpEnvironment' 'SpError'
		'SpExceptionContext' 'SpFilename' 'SpFileStream' 'SpIPAddress' 'SpMD5Digest' 'SpModel'
		'SpPortabilityTools' 'SpSocket' 'SpSocketAddress' 'SpSocketError' 'SpStreamError'
		'SpStringUtilities' 'SpTimestamp' 'SpTranscript' 'SpTransientGlobals' 'SpWeakArray')
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> initializationSource [
	| defined |
	defined := (selection select: [ :row | row at: 4 ]) collect: [ :row | row at: 3 ].
	^ String streamContents: [ :stream |
		stream nextPutAll: 'fileformat utf8'; lf; nextPutAll: '! Fresh-install initialization; no listeners or package loaders.'; lf;
			nextPutAll: 'doit'; lf.
		GtGemStoneZincRuntimeCompatibility reviewedInitializerClassNames do: [ :name |
			(defined includes: name asString) ifTrue: [ stream nextPutAll: name; nextPutAll: ' initialize.'; lf ] ].
		stream nextPutAll: 'ZnServer initialize.'; lf;
			nextPutAll: 'ZnNetworkingUtils defaultSocketStreamTimeout: 30.'; lf.
		GtGemStoneZincRuntimeCompatibility reviewedEagerInitializationStatements do: [ :statement |
			stream nextPutAll: statement; lf ].
		stream nextPutAll: 'true'; lf; nextPutAll: '%'; lf ]
]

{ #category : #initialization }
GtGemStoneZincNativeExporter >> initialize [
	super initialize.
	session := GtGemStoneSessionRegistry defaultSession.
	selection := #().
	targetDictionary := 'ZincGlobals'
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> markSportRemovalReviewPendingIn: aReport [
	| file contents |
	file := aReport asFileReference.
	contents := file contents copyReplaceAll:
		'Status: implemented and validated for fresh default extents; see the implementation and verification section below.'
		with: 'Status: final accept-race correction and revised-release validation pending; prior validated evidence is recorded below.'.
	file writeStreamDo: [ :stream | stream truncate; nextPutAll: contents ].
	^ file fullName
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> nativeRecords [
	"Resolve from the named dictionary, never by ordinary class lookup.
	The remote block changes no symbol list and has autoCommit disabled."
	^ session evaluateBlockAndWait: [ :rows |
		rows collect: [ :row | | dictionary behavior definition methods depth parent |
			dictionary := System myUserProfile symbolList
				detect: [ :each | each name asString = (row at: 2) ].
			behavior := dictionary at: (row at: 3) asSymbol.
			behavior isBehavior ifFalse: [ Error signal: 'Manifest entry is not a class' ].
			behavior name asString = (row at: 3) ifFalse: [ Error signal: 'Class alias is not a canonical export identity' ].
			definition := (row at: 4)
				ifTrue: [ String streamContents: [ :stream | behavior fileOutClassDefinitionOn: stream ] ]
				ifFalse: [ '' ].
			methods := String streamContents: [ :stream |
				(row at: 5) asSortedCollection do: [ :selector |
					behavior fileOutMethod: selector asSymbol environmentId: 0 on: stream ].
				(row at: 6) asSortedCollection do: [ :selector |
					behavior class fileOutMethod: selector asSymbol environmentId: 0 on: stream ] ].
			depth := 0.
			parent := behavior superclass.
			[ parent notNil ] whileTrue: [ depth := depth + 1. parent := parent superclass ].
			{ row at: 1. row at: 2. row at: 3. behavior asOop. depth. definition. methods.
				(behavior sharedPools collect: [ :pool | pool name asString ]) asArray.
				behavior superclass name asString } ] ]
		withArguments: { self canonicalSelection }
		serializationStrategy: #GtRsrWireSerializationStrategy
		autoCommit: false
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> normalizedDefinition: source [
	"Pristine Class has category: before inDictionary:. GLASS's native
	definition printer emits these keywords in the reverse order."
	| start dictionaryEnd categoryStart categoryEnd prefix category suffix |
	source isEmpty ifTrue: [ ^ source ].
	start := source findString: String tab , 'inDictionary: ' startingAt: 1.
	self assert: start > 0.
	dictionaryEnd := source indexOf: Character lf startingAt: start.
	categoryStart := dictionaryEnd + 1.
	self assert: ((source copyFrom: categoryStart to: source size)
		beginsWith: String tab , 'category: ').
	categoryEnd := source indexOf: Character lf startingAt: categoryStart.
	prefix := source copyFrom: 1 to: start - 1.
	category := source copyFrom: categoryStart to: categoryEnd.
	suffix := source copyFrom: categoryEnd + 1 to: source size.
	^ prefix , category , String tab , 'inDictionary: ' , targetDictionary , String lf , suffix
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> prepareIsolatedSportFreeSource [
	"Run once in a disposable clone after its GT bootstrap has loaded.
	All edits remain uncommitted in the isolated session."
	self restoreReviewedNativeKernelInIsolatedSource.
	self applyNativeSocketAdaptationToIsolatedSource.
	self selection: self candidateSelection.
	self rebindSelectedMethodsInIsolatedSource.
	self validateSportIndependence.
	^ self
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> preserveCompanionMetadataFrom: archivedManifest in: artifacts [
	"Full native regeneration preserves the optional audit metadata and ordering introduced by verified companion regeneration. Legacy manifest serialization stays unchanged."
	| manifest audit ordered hashes orderedHashes |
	(archivedManifest includesKey: 'companionRegeneration') ifFalse: [ ^ artifacts ].
	manifest := STONJSON fromString: (artifacts at: 'manifest.json').
	audit := OrderedDictionary new.
	#('generator' 'operation' 'regeneratedArtifacts' 'nativeArtifacts') do: [ :key |
		audit at: key put: ((archivedManifest at: 'companionRegeneration') at: key) ].
	manifest at: 'companionRegeneration' put: audit.
	hashes := manifest at: 'artifactSHA256'.
	orderedHashes := OrderedDictionary new.
	hashes keys sorted do: [ :key | orderedHashes at: key put: (hashes at: key) ].
	manifest at: 'artifactSHA256' put: orderedHashes.
	ordered := OrderedDictionary new.
	manifest keys sorted do: [ :key | ordered at: key put: (manifest at: key) ].
	artifacts at: 'manifest.json' put: (NeoJSONWriter toStringPretty: ordered).
	^ artifacts
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> preserveFrozenBaselineFrom: sourceDirectory to: destinationDirectory [
	"Copy every frozen byte before mutation; refuse to overwrite an earlier rollback baseline."
	| source destination checksums |
	source := sourceDirectory asFileReference.
	destination := destinationDirectory asFileReference.
	destination exists ifTrue: [ self error: 'Rollback destination already exists' ].
	destination ensureCreateDirectory.
	checksums := OrderedDictionary new.
	source files sorted do: [ :file |
		| bytes |
		bytes := file binaryContents.
		(destination / file basename) binaryWriteStreamDo: [ :stream | stream nextPutAll: bytes ].
		self assert: (destination / file basename) binaryContents = bytes.
		checksums at: file basename put: (SHA256 hashMessage: bytes) hex ].
	(destination / 'rollback-SHA256.json') writeStreamDo: [ :stream |
		stream nextPutAll: (NeoJSONWriter toStringPretty: checksums) ].
	^ checksums
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> prototypeAdditionalArtifacts [
	| artifacts selected directory licenses overlay provenance |
	GtGemStoneZincRuntimeCompatibility validateSharedKernelEvidenceFor: selection session: session.
	GtGemStoneZincRuntimeCompatibility validateUnicodeDictionaryProvenanceIn: session.
	artifacts := OrderedDictionary new.
	artifacts at: 'native-structure-provenance.json' put: (NeoJSONWriter toStringPretty:
		(GtGemStoneZincStructuralValidation new captureSelection: self canonicalSelection session: session) metadataSnapshot).
	artifacts at: 'native-socket-api-provenance.json' put: (NeoJSONWriter toStringPretty: GtGemStoneZincRuntimeCompatibility nativeSocketAPIProvenance).
	artifacts at: 'native-socket-provenance.json' put: (NeoJSONWriter toStringPretty: GtGemStoneZincRuntimeCompatibility nativeSocketMethodSpecifications).
	artifacts at: 'sport-removal-inventory.json' put: (NeoJSONWriter toStringPretty: self sportOwnedClassNames).
	selected := selection collect: [ :row | row at: 3 ].
	overlay := (GtGemStoneZincRuntimeCompatibility extensions ,
		(GtGemStoneZincRuntimeCompatibility constructorExtensionsFor: selection session: session))
		select: [ :extension | selected includes: extension className asString ].
	artifacts at: 'runtime-compatibility.topaz' put: (String streamContents: [ :stream |
		stream nextPutAll: 'fileformat utf8'; lf; nextPutAll: 'set compile_env: 0'; lf.
		overlay do: [ :extension |
			self validateSportFreeGeneratedSource: extension source.
			stream nextPutAll: 'category: '; nextPutAll: extension protocol asString printString; lf;
				nextPutAll: (extension meta ifTrue: [ 'classmethod: ' ] ifFalse: [ 'method: ' ]);
				nextPutAll: extension className; lf;
				nextPutAll: extension source; lf; nextPutAll: '%'; lf ] ]).
	provenance := overlay collect: [ :extension |
		{ extension className asString. extension selector asString. extension meta.
			extension protocol asString. extension hash } ].
	artifacts at: 'compatibility-provenance.json' put: (NeoJSONWriter toStringPretty: provenance).
	artifacts at: 'constructor-provenance.json' put: (NeoJSONWriter toStringPretty:
		(GtGemStoneZincRuntimeCompatibility constructorProvenanceFor: selection session: session)).
	artifacts at: 'shared-kernel-provenance.json' put: (NeoJSONWriter toStringPretty:
		GtGemStoneZincRuntimeCompatibility reviewedSharedKernelEvidence).
	artifacts at: 'full-gt-integration-provenance.json' put: (NeoJSONWriter toStringPretty: self fullGtIntegrationProvenance).
	artifacts at: 'unicode-dictionary-provenance.json' put: (NeoJSONWriter toStringPretty: GtGemStoneZincRuntimeCompatibility unicodeDictionaryProvenance).
	artifacts at: 'exception-identity-provenance.json' put: (NeoJSONWriter toStringPretty: GtGemStoneZincRuntimeCompatibility exceptionIdentityProvenance).
	artifacts at: 'exclusions.json' put: (NeoJSONWriter toStringPretty: self prototypeMethodExclusions).
	artifacts at: 'global-bindings.topaz' put: (String streamContents: [ :stream |
		stream nextPutAll: 'fileformat utf8'; lf; nextPutAll: 'doit'; lf;
			nextPutAll: targetDictionary , ' at: #Smalltalk put: SmalltalkProxy new.'; lf;
			nextPutAll: targetDictionary , ' at: #Transcript put: TranscriptProxy.'; lf;
			nextPutAll: 'true'; lf; nextPutAll: '%'; lf ]).
	artifacts at: 'initialization.topaz' put: (self validateSportFreeGeneratedSource: self initializationSource).
	directory := FileLocator imageDirectory / 'github-cache'.
	licenses := #(
		#('LICENSE-Zinc.txt' 'GsDevKit/zinc/506aedabd409ce8221ddafd725381a7a0e6df27d/GsDevKit-zinc-506aeda/license.txt')
		#('LICENSE-GLASS.txt' 'glassdb/glass/master/glassdb-glass-fddbc3b/LICENSE')
		#('LICENSE-Grease.txt' 'GsDevKit/Grease/master/GsDevKit-Grease-dcad886/LICENSE.md')).
	licenses do: [ :license | artifacts at: license first put: (directory resolve: license second) contents ].
	artifacts at: 'license-provenance.json' put: (NeoJSONWriter toStringPretty: licenses).
	self currentCompanionProvenance keysAndValuesDo: [ :name :content | artifacts at: name put: content utf8Decoded ].
	^ artifacts
]

{ #category : #selection }
GtGemStoneZincNativeExporter >> prototypeMethodExclusions [
	^ #(
		#('ZnConstants' 'class' 'frameworkMCVersion' 'Replaced by frozen provenance accessor in compatibility overlay')
		#('FileDirectory' 'instance' 'asRepositorySpecFor:' 'Monticello repository integration')
		#('ClientFileDirectory' 'instance' 'asRepositorySpecFor:' 'Monticello repository integration')
		#('FileDirectory' 'instance' 'fileTreeUtilityClass' 'Monticello FileTree integration')
		#('Url' 'instance' 'asRepository:password:' 'Monticello repository integration')
		#('FileUrl' 'instance' 'asRepository:password:' 'Monticello repository integration')
		#('FileUrl' 'instance' 'pathForDirectory' 'Monticello FileTree integration')
		#('FileUrl' 'class' 'workingDirectory' 'Monticello FileTree integration')
		#('FastUUIDGenerator' 'class' 'default' 'Replaced by SessionTemps accessor in compatibility overlay')
		#('FastUUIDGenerator' 'class' 'initialize' 'Replaced by SessionTemps clearing in compatibility overlay')
		#('HttpUrl' 'instance' 'asRepository:password:' 'Monticello repository integration')
		#('FtpUrl' 'instance' 'asRepository:password:' 'Monticello repository integration')
		#('SmalltalkProxy' 'instance' 'systemOrganization' 'Package organization tooling')
		#('ObjectLogEntry' 'instance' 'labelText' 'Object log rich text presentation')
	)
]

{ #category : #selection }
GtGemStoneZincNativeExporter >> prunePrototypeSelection: rows [
	| exclusions |
	exclusions := self prototypeMethodExclusions.
	^ ((rows reject: [ :row | #('PackageInfo' 'MCFileTreeFileDirectoryUtils' 'MCFileTreeFileUtils' 'OverriddenBaseMethodsTest' 'SentButNotImplementedTest'
		'SpExceptionTest' 'SpExceptionTests' 'SpFilenameTest' 'ZipCrcTests' 'ZipWriteStreamTests') includes: (row at: 3) ]) collect: [ :row |
		| result |
		result := row copy.
		exclusions do: [ :excluded |
			(row at: 3) = excluded first ifTrue: [
				| index |
				index := (excluded at: 2) = 'instance' ifTrue: [ 5 ] ifFalse: [ 6 ].
				result at: index put: ((result at: index) reject: [ :selector | selector = (excluded at: 3) ]) ] ].
		5 to: 6 do: [ :index | result at: index put: (result at: index) asSet asArray ].
		result ]) asArray
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> rebindSelectedMethodsInIsolatedSource [
	"Recompilation is necessary after the two class identities change; preserve protocols."
	session = GtGemStoneSessionRegistry defaultSession ifTrue: [
		self error: 'Refusing recompilation in the default session' ].
	^ session evaluateBlockAndWait: [ :rows |
		| dictionaries count |
		dictionaries := System myUserProfile symbolList.
		count := 0.
		rows do: [ :row |
			| behavior dictionary |
			dictionary := dictionaries detect: [ :each | each name asString = (row at: 2) ].
			behavior := dictionary at: (row at: 3) asSymbol.
			{ {behavior. row at: 5}. {behavior class. row at: 6} } do: [ :side |
				(side at: 2) do: [ :selector |
					| source protocol |
					source := (side first compiledMethodAt: selector asSymbol) sourceString.
					protocol := side first categoryOfSelector: selector asSymbol.
					[ side first compileMethod: source dictionaries: dictionaries category: protocol environmentId: 0 ]
						on: ((dictionaries detect: [ :each | each includesKey: #CompileWarning ]) at: #CompileWarning) do: [ :warning | warning resume ].
					count := count + 1 ] ] ].
		count ]
		withArguments: { self canonicalSelection }
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> recordSportRemovalCompletion: evidenceText inReport: aReportFile [
	"Preserve the original investigation and plan, adding verified implementation evidence."
	| file original marker prefix annotation completed |
	self assert: evidenceText notEmpty.
	file := aReportFile asFileReference.
	original := file contents.
	annotation := 'This is the historical pre-migration analysis; verified implementation evidence appears below.'.
	[ original includesSubstring: annotation, ' ', annotation ] whileTrue: [
		original := original copyReplaceAll: annotation, ' ', annotation with: annotation ].
	(original includesSubstring: annotation) ifFalse: [
		original := original copyReplaceAll: 'Analysis date: 19 October 2026.'
			with: 'Analysis date: 19 October 2026. ', annotation ].
	completed := 'Status: implemented and validated for fresh default extents; see the implementation and verification section below.'.
	#('Status: proposed; no implementation changes have been made.'
		'Status: final accept-race correction and revised-release validation pending; prior validated evidence is recorded below.')
		do: [ :status | original := original copyReplaceAll: status with: completed ].
	marker := '## Sport removal implementation and verification'.
	prefix := (original includesSubstring: marker)
		ifTrue: [ original copyFrom: 1 to: (original findString: marker) - 1 ]
		ifFalse: [ original ].
	file writeStreamDo: [ :stream |
		stream truncate; nextPutAll: prefix withUnixLineEndings; lf; lf;
			nextPutAll: marker; lf; lf; nextPutAll: evidenceText withUnixLineEndings; lf ].
	^ file fullName
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> regenerateCompanionsFrom: manifestFile to: aDirectory [
	"Validate every frozen artifact before writing. Native source bytes and captured source metadata remain unchanged; this operation needs no source database."
	| file manifest bytes hashes newHashes ordered output changed |
	file := manifestFile asFileReference.
	manifest := STONJSON fromString: file contents.
	self assert: (manifest at: 'schema') = 1.
	self targetDictionary: (manifest at: 'targetDictionary').
	self selection: (manifest at: 'selection').
	self validateSelection.
	self validateFrozenSportFreeSelection.
	hashes := manifest at: 'artifactSHA256'.
	bytes := OrderedDictionary new.
	hashes keys sorted do: [ :name |
		| content |
		self assert: name notEmpty.
		self assert: (name includes: $/) not.
		self assert: (name includes: $\) not.
		self assert: (name ~= '.' and: [ name ~= '..' ]).
		content := (file parent / name) binaryReadStreamDo: [ :stream | stream upToEnd ].
		self assert: (SHA256 hashMessage: content) hex = (hashes at: name)
			description: 'Frozen artifact checksum mismatch: ', name.
		bytes at: name put: content ].
	self assert: (bytes includesKey: 'initialization.topaz').
	bytes at: 'initialization.topaz' put: self initializationSource utf8Encoded.
	changed := OrderedCollection with: 'initialization.topaz'.
	(bytes includesKey: 'runtime-compatibility.topaz') ifTrue: [
		self assert: (bytes includesKey: 'constructor-provenance.json').
		(self runtimeCompanionsFromFrozenConstructors: (bytes at: 'constructor-provenance.json'))
			keysAndValuesDo: [ :name :content | bytes at: name put: content. changed add: name ] ].
	self currentCompanionProvenance keysAndValuesDo: [ :name :content |
		bytes at: name put: content. changed add: name ].
	manifest at: 'additionalArtifacts' put:
		(((manifest at: 'additionalArtifacts' ifAbsent: [ #() ]) , self currentCompanionProvenance keys) asSet sorted asArray).
	bytes removeKey: 'LICENSE-Sport.txt' ifAbsent: [ ].
	bytes at: 'license-provenance.json' put: (NeoJSONWriter toStringPretty:
		((STONJSON fromString: (bytes at: 'license-provenance.json') utf8Decoded)
			reject: [ :row | row first = 'LICENSE-Sport.txt' ])) utf8Encoded.
	manifest at: 'additionalArtifacts' put: ((manifest at: 'additionalArtifacts') reject: [ :name | name = 'LICENSE-Sport.txt' ]).
	changed add: 'license-provenance.json'.
	newHashes := OrderedDictionary new.
	bytes keys sorted do: [ :name | newHashes at: name put: (SHA256 hashMessage: (bytes at: name)) hex ].
	manifest at: 'artifactSHA256' put: newHashes.
	manifest at: 'companionRegeneration' put: (OrderedDictionary new
		at: 'generator' put: self class name;
		at: 'operation' put: 'regenerateCompanionsFrom:to:';
		at: 'regeneratedArtifacts' put: changed sorted asArray;
		at: 'nativeArtifacts' put: 'Preserved byte-for-byte after SHA256 verification; no source database inspection';
		yourself).
	ordered := OrderedDictionary new.
	manifest keys sorted do: [ :key | ordered at: key put: (manifest at: key) ].
	bytes at: 'manifest.json' put: (NeoJSONWriter toStringPretty: ordered) utf8Encoded.
	output := aDirectory asFileReference.
	output ensureCreateDirectory.
	bytes keys sorted do: [ :name |
		(output / name) binaryWriteStreamDo: [ :stream | stream truncate; nextPutAll: (bytes at: name) ] ].
	^ bytes keys asArray
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> regenerateFrom: manifestFile to: aDirectory [
	| file manifest extras |
	file := manifestFile asFileReference.
	manifest := STONJSON fromString: file contents.
	self assert: (manifest at: 'schema') = 1.
	self targetDictionary: (manifest at: 'targetDictionary').
	self selection: (manifest at: 'selection').
	extras := OrderedDictionary new.
	(manifest at: 'additionalArtifacts' ifAbsent: [ #() ]) do: [ :name |
		extras at: name put: (file parent / name) contents ].
	self additionalArtifacts: extras.
	^ self writeArtifacts: (self preserveCompanionMetadataFrom: manifest in: self artifacts) to: aDirectory
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> regenerateLicenseCompanionsFrom: aDirectory to: anOutput [
	"License-only update. Preserve every native/runtime and ownership/history artifact byte."
	| source output manifest bytes licenses hashes |
	source := aDirectory asFileReference.
	output := anOutput asFileReference.
	manifest := STONJSON fromString: (source / 'manifest.json') contents.
	self selection: (manifest at: 'selection').
	self validateSelection; validateFrozenSportFreeSelection.
	(source / 'manifest.sha256') contents lines do: [ :line |
		| fields |
		fields := line substrings.
		self assert: fields size = 2.
		self assert: (SHA256 hashMessage: (source / fields second) binaryContents) hex = fields first ].
	bytes := OrderedDictionary new.
	(source files reject: [ :file | #('LICENSE-Sport.txt' 'manifest.sha256') includes: file basename ])
		do: [ :file | bytes at: file basename put: file binaryContents ].
	licenses := (STONJSON fromString: (bytes at: 'license-provenance.json') utf8Decoded)
		reject: [ :row | row first = 'LICENSE-Sport.txt' ].
	bytes at: 'license-provenance.json' put: (NeoJSONWriter toStringPretty: licenses) utf8Encoded.
	hashes := manifest at: 'artifactSHA256'.
	hashes removeKey: 'LICENSE-Sport.txt' ifAbsent: [ ].
	hashes at: 'license-provenance.json' put: (SHA256 hashMessage: (bytes at: 'license-provenance.json')) hex.
	manifest at: 'additionalArtifacts' put: ((manifest at: 'additionalArtifacts')
		reject: [ :name | name = 'LICENSE-Sport.txt' ]).
	manifest at: 'licenseArtifactChange' put: 'LICENSE-Sport.txt removed with the Sport dependency; native runtime and historical ownership/source inventory unchanged'.
	bytes at: 'manifest.json' put: (NeoJSONWriter toStringPretty: manifest) utf8Encoded.
	output ensureCreateDirectory.
	bytes keysAndValuesDo: [ :name :content |
		(output / name) binaryWriteStreamDo: [ :stream | stream truncate; nextPutAll: content ] ].
	GtGemStoneZincInstallerArtifacts writeZincImportersTo: output.
	GtGemStoneZincInstallerArtifacts finalizeChecksumsIn: output.
	#('dependencies-definitions.topaz' 'dependencies-methods.topaz' 'zinc-definitions.topaz'
		'zinc-methods.topaz' 'runtime-compatibility.topaz' 'initialization.topaz')
		do: [ :name | self assert: (source / name) binaryContents = (output / name) binaryContents ].
	^ output fullName
]

{ #category : #selection }
GtGemStoneZincNativeExporter >> requiredKernelExtensions [
	"Selected GLASS runtime extensions demonstrated necessary by clean Solo checks."
	^ {
		{ 'dependencies'. 'Globals'. 'Object'. false. #('assert:' 'as:' 'isArray' 'isStream' 'isFloat'). #() }.
		{ 'dependencies'. 'Globals'. 'BlockClosure'. false. #('ifError:'). #() }.
		{ 'dependencies'. 'Globals'. 'BinaryFloat'. false. #('isFloat'). #() }.
		{ 'dependencies'. 'Globals'. 'Integer'. false. #('isLarge' 'printStringBase:'). #('readFrom:ifFail:') }.
		{ 'dependencies'. 'Globals'. 'SmallInteger'. false. #('isLarge'). #() }.
		{ 'dependencies'. 'Globals'. 'DateAndTime'. false. #('asTimeStamp' 'asTime' 'secondsSinceMidnight'). #('date:time:offset:') }.
		{ 'dependencies'. 'Globals'. 'TimeZone'. false. #('offset'). #() }.
		{ 'dependencies'. 'Globals'. 'Time'. false. #(). #('millisecondsSince:' 'milliseconds:since:' 'totalSeconds') }.
		{ 'dependencies'. 'Globals'. 'CharacterCollection'. false. #('padded:to:with:' 'findTokens:' 'skipDelimiters:startingAt:' 'findDelimiters:startingAt:'). #() }.
		{ 'dependencies'. 'Globals'. 'ByteArray'. false. #('asString'). #() }.
		{ 'dependencies'. 'Globals'. 'Array'. false. #('isArray'). #() }.
		{ 'dependencies'. 'Globals'. 'String'. false. #('asZnUrl'). #('crlf') }.
		{ 'dependencies'. 'Globals'. 'Dictionary'. false. #(). #('newFromPairs:') }.
		{ 'dependencies'. 'Globals'. 'Character'. false. #('to:' 'charCode'). #('escape') }.
		{ 'dependencies'. 'Globals'. 'SequenceableCollection'. false. #('collect:from:to:' 'copyUpTo:' 'copyAfter:'). #('new:withAll:') }
	}
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> restoreReviewedNativeKernelInIsolatedSource [
	"Undo bootstrap GT bridges only for the existing independently reviewed native whitelist."
	session = GtGemStoneSessionRegistry defaultSession ifTrue: [
		self error: 'Refusing native kernel restoration in the default session' ].
	^ session evaluateBlockAndWait: [ :evidence |
		| dictionaries |
		dictionaries := System myUserProfile symbolList.
		evidence do: [ :spec |
			| behavior |
			behavior := (dictionaries detect: [ :each | each name = #Globals ])
				at: (spec at: 'class') asSymbol.
			(spec at: 'classSide') ifTrue: [ behavior := behavior class ].
			behavior compileMethod: (spec at: 'nativeSource') dictionaries: dictionaries
				category: (spec at: 'nativeProtocol') asSymbol environmentId: 0 ].
		true ]
		withArguments: { GtGemStoneZincRuntimeCompatibility reviewedSharedKernelEvidence }
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false
]

{ #category : #selection }
GtGemStoneZincNativeExporter >> rootSelection [
	^ self selectionForPackageNames:
		#('Zinc-HTTP' 'SocketStream' 'Zinc-Character-Encoding-Core'
		'Zinc-Character-Encoding-GS32-Core' 'Zinc-Resource-Meta-Core' 'Zinc-FileSystem-Legacy')
		group: 'zinc'
		excluding: #('ZnMonticelloServerDelegate' 'SocketStreamTest' 'ZnTestRunnerDelegate')
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> runtimeCompanionsFromFrozenConstructors: constructorBytes [
	| evidence constructors selected overlay result |
	evidence := STONJSON fromString: constructorBytes utf8Decoded.
	constructors := evidence collect: [ :row |
		GtGemStoneExtensionMethod new
			className: row first asSymbol; selector: #new; meta: true;
			protocol: row second asSymbol; gtVersions: nil; hash: #new;
			source: 'new
	<gtGsExtension>
	^ (super new) initialize' ].
	selected := selection collect: [ :row | row at: 3 ].
	overlay := (GtGemStoneZincRuntimeCompatibility extensions , constructors)
		select: [ :extension | selected includes: extension className asString ].
	result := OrderedDictionary new.
	result at: 'runtime-compatibility.topaz' put: (String streamContents: [ :stream |
		stream nextPutAll: 'fileformat utf8'; lf; nextPutAll: 'set compile_env: 0'; lf.
		overlay do: [ :extension |
			stream nextPutAll: 'category: '; nextPutAll: extension protocol asString printString; lf;
				nextPutAll: (extension meta ifTrue: [ 'classmethod: ' ] ifFalse: [ 'method: ' ]);
				nextPutAll: extension className; lf;
				nextPutAll: extension source; lf; nextPutAll: '%'; lf ] ]) utf8Encoded.
	result at: 'compatibility-provenance.json' put: (NeoJSONWriter toStringPretty:
		(overlay collect: [ :extension |
			{ extension className asString. extension selector asString. extension meta.
				extension protocol asString. extension hash } ])) utf8Encoded.
	^ result
]

{ #category : #accessing }
GtGemStoneZincNativeExporter >> selection: anArray [
	selection := anArray
]

{ #category : #selection }
GtGemStoneZincNativeExporter >> selectionForClassNames: classNames group: groupName [
	"Explicit UserGlobals class identities plus UserGlobals superclass identities.
	This is a candidate manifest; callers must review tooling references before use."
	^ session evaluateBlockAndWait: [ :names :group |
		| user classes pending |
		user := System myUserProfile symbolList detect: [ :dict | dict name = #UserGlobals ].
		classes := IdentitySet new.
		pending := OrderedCollection new.
		names do: [ :name | pending add: (user at: name asSymbol) ].
		[ pending isEmpty ] whileFalse: [
			| behavior parent |
			behavior := pending removeFirst.
			(classes includes: behavior) ifFalse: [
				classes add: behavior.
				parent := behavior superclass.
				(parent notNil and: [ (user at: parent name ifAbsent: [ nil ]) == parent ])
					ifTrue: [ pending add: parent ].
				behavior sharedPools do: [ :pool | | owner |
					owner := user at: pool name ifAbsent: [ nil ].
					(owner notNil and: [ owner isBehavior and: [ owner _classVars == pool ] ])
						ifTrue: [ pending add: owner ] ] ] ].
		(classes asSortedCollection: [ :a :b | a name < b name ]) collect: [ :behavior |
			{ group. 'UserGlobals'. behavior name asString. true.
				(behavior selectors collect: [ :each | each asString ]) asArray.
				(behavior class selectors collect: [ :each | each asString ]) asArray } ] ]
		withArguments: { classNames. groupName }
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false
]

{ #category : #selection }
GtGemStoneZincNativeExporter >> selectionForDictionary: dictionaryName classNames: classNames group: groupName [
	^ session evaluateBlockAndWait: [ :dictionaryName :names :group |
		| dictionary |
		dictionary := System myUserProfile symbolList detect: [ :each | each name asString = dictionaryName ].
		names collect: [ :name | | behavior |
			behavior := dictionary at: name asSymbol.
			{ group. dictionaryName. name. true.
				(behavior selectors collect: [ :selector | selector asString ]) asArray.
				(behavior class selectors collect: [ :selector | selector asString ]) asArray } ] ]
		withArguments: { dictionaryName. classNames. groupName }
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false
]

{ #category : #selection }
GtGemStoneZincNativeExporter >> selectionForPackageNames: packageNames group: groupName excluding: excludedClassNames [
	"Snapshots select names and extension selectors only. Every defined class is
	exported using its complete native dictionary-qualified implementation."
	^ session evaluateBlockAndWait: [ :packages :group :excluded |
		| definitions classNames methodDefinitions names user globals |
		definitions := OrderedCollection new.
		packages do: [ :name |
			definitions addAll: ((MCWorkingCopy allManagers
				detect: [ :manager | manager packageName = name ]) package snapshot definitions) ].
		classNames := (definitions select: [ :each | each isClassDefinition ]) collect: [ :each | each className asString ].
		methodDefinitions := definitions select: [ :each | each isMethodDefinition ].
		names := (classNames , (methodDefinitions collect: [ :each | each className asString ])) asSet asSortedCollection.
		user := System myUserProfile symbolList detect: [ :each | each name = #UserGlobals ].
		globals := System myUserProfile symbolList detect: [ :each | each name = #Globals ].
		(names reject: [ :name | excluded includes: name ]) collect: [ :name |
			| dictionary behavior defined selectedMethods instanceSelectors classSelectors |
			dictionary := (user includesKey: name asSymbol) ifTrue: [ user ] ifFalse: [ globals ].
			behavior := dictionary at: name asSymbol.
			defined := classNames includes: name.
			selectedMethods := methodDefinitions select: [ :each | each className asString = name ].
			instanceSelectors := defined ifTrue: [ behavior selectors ]
				ifFalse: [ (selectedMethods reject: [ :each | each classIsMeta ]) collect: [ :each | each selector ] ].
			classSelectors := defined ifTrue: [ behavior class selectors ]
				ifFalse: [ (selectedMethods select: [ :each | each classIsMeta ]) collect: [ :each | each selector ] ].
			{ group. dictionary name asString. name. defined.
				(instanceSelectors collect: [ :each | each asString ]) asArray.
				(classSelectors collect: [ :each | each asString ]) asArray } ] ]
		withArguments: { packageNames. groupName. excludedClassNames }
		serializationStrategy: #GtRsrWireSerializationStrategy
		autoCommit: false
]

{ #category : #accessing }
GtGemStoneZincNativeExporter >> session: aSession [
	session := aSession
]

{ #category : #accessing }
GtGemStoneZincNativeExporter >> sourcePackageVersions [
	^ session evaluateBlockAndWait: [
		(MCWorkingCopy allManagers collect: [ :manager |
			{ manager packageName asString.
				(manager ancestry ancestors collect: [ :version | version name asString ]) asArray } ]) asArray ]
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false
]

{ #category : #analysis }
GtGemStoneZincNativeExporter >> sportOwnedClassNames [
	"Ownership comes from source categories, including Sport-Portability, rather than the Sp prefix."
	^ (self historicalSportOwnedClassNames , (session evaluateBlockAndWait: [
		| classes |
		classes := IdentitySet new.
		System myUserProfile symbolList do: [ :dict |
			dict valuesDo: [ :value |
				(value isBehavior and: [
					value category asString = 'Sport' or: [
						(value category asString beginsWith: 'Sport-') or: [ value category asString beginsWith: 'Sport.' ] ] ])
					ifTrue: [ classes add: value ] ] ].
		(classes collect: [ :each | each name asString ]) asArray sorted ]
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false)) asSet asArray sorted
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> sportRemovalCompletionEvidence [
	^ 'Implemented and verified on 19 October 2026 with GemStone 3.7.6. The fresh installed runtime has **zero Sport-owned definitions, Sport superclass links, compiled Sport class references or Sport class-name symbol dependencies**. The absence audit covers both ZincGlobals and Globals, inherited methods and nested literals; Sport is genuinely absent rather than hidden by dictionary priority.

The final manifest contains 293 dictionary-qualified selection entries: 253 private class definitions, 40 shared-class extension entries and 3,802 selected methods. SocketStreamSocket now subclasses Object and stores its native GsSocket through TransientStackValue with _setNoStubbing. HTTPSocket subclasses SocketStreamSocket; both definitions load in dependency order. Native socket errors use the established NetworkError, ConnectionClosed and ConnectionTimedOut vocabulary. Connect and stream timeout arguments are seconds, converted to native milliseconds; -1 means indefinite waiting. DNS timeout guarantees are not introduced.

Finite accepts perform one bounded readiness wait, explicitly enable native nonblocking mode and then call GsSocket acceptTimeoutMs: 0. If readiness disappears, a transient nil result returns timeout without destroying the listener; reported failures retain their normalized error behavior. Regression tests reject an indefinite accept or a second timed wait. The native acceptTimeoutMs: API has a per-wait timeout rather than an absolute overall deadline; the adapter uses zero after its own bounded wait.

Exactly 21 previously exported definitions were removed: HTTPSocketError, SpAbstractError, SpDate, SpEnvironment, SpError, SpExceptionContext, SpFileStream, SpFilename, SpIPAddress, SpMD5Digest, SpModel, SpPortabilityTools, SpSocket, SpSocketAddress, SpSocketError, SpStreamError, SpStringUtilities, SpTimestamp, SpTranscript, SpTransientGlobals and SpWeakArray. This includes Sport-Portability, beyond the original exact-category analysis.

The live GToolkit-GemStone-ZincExport package owns the adaptation, exporter, importer and validation sources. All implementation changes were authored in live GT and saved through scoped Iceberg operations. A separate cloned source extent supplied full native definitions and methods; the preserved upstream GLASS reference and original default stone were left intact. The final managed specification contains 61 replacements, including bounded legacy HTTP parsing, URL metadata/percent encoding, authentication and POST/PUT cleanup required by clean-load tests. No shared Character, String or stream compatibility patches were added for these legacy fixes.

The exporter rejects Sport selection and compiled dependencies, audits executable generated overlays and initialization with a real Smalltalk scanner, and retains a stable ownership inventory even when Sport is absent. Offline companion regeneration now rejects old Sport-bearing manifests before creating output; it cannot migrate their native definitions. A full isolated native export is required.

**Generated release and provenance**

- [Final manifest](../gt4gemstone/scripts/zinc/manifest.json), [source/protocol/binding and layout evidence](../gt4gemstone/scripts/zinc/native-structure-provenance.json), [managed replacement sources and original-source attribution](../gt4gemstone/scripts/zinc/native-socket-provenance.json), [observed native API behavior](../gt4gemstone/scripts/zinc/native-socket-api-provenance.json) and [ownership inventory](../gt4gemstone/scripts/zinc/sport-removal-inventory.json).
- Two complete exports, including normal importers and checksums, were byte-identical in [sport-free-export](zinc-work/sport-free-export/) and [sport-free-export-repeat](zinc-work/sport-free-export-repeat/).
- The normal package-release.sh produced [gt4gemstone-sport-free-no-sport-license-final-3.7.zip](zinc-work/sport-release/gt4gemstone-sport-free-no-sport-license-final-3.7.zip). All 32 packaged checksum records were verified against archive members and exact reviewed staging bytes; archive SHA-256 is recorded in the [checksum file](zinc-work/sport-release/gt4gemstone-sport-free-no-sport-license-final-3.7.zip.sha256). Normal repository and packaged preflight checks passed.
- Historical Sport package versions remain as provenance. LICENSE-Sport.txt was introduced by the exporter for the removed dependency and is no longer included in the active export or release. Other project licenses remain unchanged. The license-only companion regeneration preserves every native/runtime Topaz file and all ownership, source, protocol and binding evidence byte-for-byte; existing runtime acceptance evidence therefore remains applicable.

**Acceptance evidence**

The pristine default-extent Solo installation passed with errorCount 0: [combined import and validation log](zinc-work/sport-free-validation/default-extent-solo/acceptfix-full-gt-http.log). Checks cover Sport absence, class layouts, protocols and compiled bindings; native numeric/hostname connections, refusal and DNS failure, listen/accept and timeouts, EOF, actual OS reset, partial and zero progress, buffer offsets, 1 MB transfer, repeated close and failure cleanup; private exception identity, static files, Unicode, encoding, gzip and session-local state.

Legacy HTTP checks exercised real GET requests, hostname/port Host preservation, redirects, 404 responses, proxies, authentication, POST and PUT success/failure, timeout callbacks and closure of all captured sockets. Bounded parser tests include EOF, unknown/truncated body lengths, folded headers, malformed percent sequences and UTF-8 metadata. See [legacy log](zinc-work/sport-free-validation/default-extent-solo/acceptfix-full-gt-http.log) and [actual socket reset log](zinc-work/sport-free-validation/default-extent-solo/reset.log).

A fresh real stone named sporttargetaccept was installed from the final package through the ordinary [GT release importer](zinc-work/sport-target-accept/normal-release-import.log) and [Zinc importer](zinc-work/sport-target-accept/normal-zinc-import.log), both with successful commit and errorCount 0. SystemUser and read-only DataCurator validation passed, including server stop/start and database commit/abort while the session continued.

The ordinary scripts/inputGT.sh full current GT reload also passed with successful commit and errorCount 0: [reload log](zinc-work/sport-target-accept/normal-current-GT-reload.log). Its temporary current-image export is retained as evidence; tracked GT.gs was restored byte-for-byte afterwards. Two narrowly scoped exporter exclusions omit unsupported GeoSphere Point conversion and personal Knowling RAG integration; their original implementations are unchanged.

After a real stone stop/start, a new DataCurator session passed [runtime validation](zinc-work/sport-target-accept/datacurator-post-restart-validation.json) and [listener/commit/abort lifecycle checks](zinc-work/sport-target-accept/datacurator-post-restart-lifecycle.json). [Restart metadata](zinc-work/sport-target-accept/restart-metadata.json) records a changed startup identity and no initial session Zinc keys. A newly created session listener passed external GET, HEAD, Unicode POST, malformed-request 400 and recovery: [HTTP results](zinc-work/sport-target-accept/post-restart-http-external.json). Test listeners and fixture services were closed.

Normal release importers used their ordinary 200,000 KB temporary-object setting. The full current GT reload used GEM_TEMPOBJ_CACHE_SIZE=300000 KB via the isolated target configuration; the larger setting was needed by that full export, not by the socket adapter.

All nine portable exporter examples passed, including lexical rejection regressions and the actual no-write offline companion guard. Generated shell syntax checks passed. Managed source changes pass git diff --check. Full-worktree whitespace checking still reports preserved native formatting in generated Topaz; native source/fileout bytes were deliberately retained rather than manually edited.

**Rollout and rollback boundary**

This result supports a fresh default-extent installation. Migrating persisted instances across the changed SocketStreamSocket/HTTPSocket hierarchy remains a separate upgrade concern.

The complete pre-change export is preserved at [sport-removal-rollback-20261019](zinc-work/sport-removal-rollback-20261019/), including its original manifest and checksums plus independently recorded rollback-SHA256.json. All 29 original checksum entries passed verification. Roll back a fresh deployment using that complete frozen export and its normal importer/preflight, keeping it separate from the revised artifacts.
'
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> sportRemovalStatusReport [
	^ '# Sport removal completed

The fresh GemStone 3.7.6 runtime has zero Sport runtime dependencies. The regenerated selection contains 253 private class definitions and 3,802 selected methods; 21 Sport-owned definitions were removed.

Clean Solo, normal release importers, ordinary full GT reload, real stone restart, socket/HTTP/legacy checks and session-state cleanup all passed. This result supports fresh default extents; persisted-instance migration is separate.

See the [implementation report and evidence](../sport-dependency-analysis.md#sport-removal-implementation-and-verification), [final release](sport-release/gt4gemstone-sport-free-no-sport-license-final-3.7.zip) and [archive checksum](sport-release/gt4gemstone-sport-free-no-sport-license-final-3.7.zip.sha256).
'
]

{ #category : #accessing }
GtGemStoneZincNativeExporter >> targetDictionary: aString [
	self assert: (aString notEmpty and: [ aString allSatisfy: [ :each | each isAlphaNumeric or: [ each = $_ ] ] ]).
	targetDictionary := aString
]

{ #category : #validation }
GtGemStoneZincNativeExporter >> validateFrozenSportFreeSelection [
	"Companion refresh cannot remove native definitions or change class layouts."
	(selection anySatisfy: [ :row | self historicalSportOwnedClassNames includes: (row at: 3) ])
		ifTrue: [ self error: 'Sport-bearing frozen exports require full isolated native regeneration; companion refresh cannot migrate them' ].
	^ selection
]

{ #category : #validation }
GtGemStoneZincNativeExporter >> validateSelection [
	| identities targetNames |
	identities := Set new.
	targetNames := Set new.
	selection do: [ :row |
		self assert: row size = 6.
		self assert: (#('dependencies' 'zinc') includes: row first).
		self assert: (row at: 4) isBoolean.
		self assert: (targetNames includes: (row at: 3)) not.
		targetNames add: (row at: 3).
		self assert: (identities includes: (row at: 2) , '::' , (row at: 3)) not.
		identities add: (row at: 2) , '::' , (row at: 3).
		{ row at: 5. row at: 6 } do: [ :selectors |
			self assert: selectors size = selectors asSet size ] ].
	^ selection
]

{ #category : #validation }
GtGemStoneZincNativeExporter >> validateSportFreeGeneratedSource: source [
	"Use lexical tokens so comments, quotes in strings and character literals cannot hide code."
	| names |
	names := self historicalSportOwnedClassNames.
	(OCScanner scanTokens: source) do: [ :token |
		| value words |
		value := token value.
		(value isString or: [ value isSymbol ]) ifTrue: [
			words := value asString findTokens: ' ()[]{}.,;:#''"!%	', String crlf.
			(names anySatisfy: [ :name | words includes: name ]) ifTrue: [
				self error: 'Sport dependency in generated executable source: ', value asString ] ] ].
	^ source
]

{ #category : #validation }
GtGemStoneZincNativeExporter >> validateSportIndependence [
	"Reject owned definitions, superclass links, compiled class bindings and class-name symbols."
	| owned failures |
	owned := self sportOwnedClassNames.
	failures := session evaluateBlockAndWait: [ :rows :names |
		| findings dictionaries |
		findings := OrderedCollection new.
		dictionaries := System myUserProfile symbolList.
		rows do: [ :row |
			| behavior sourceDictionary parent pending |
			sourceDictionary := dictionaries detect: [ :each | each name asString = (row at: 2) ].
			behavior := sourceDictionary at: (row at: 3) asSymbol.
			(names includes: behavior name asString) ifTrue: [ findings add: { row at: 3. 'owned class' } ].
			parent := behavior superclass.
			[ parent notNil ] whileTrue: [
				(names includes: parent name asString) ifTrue: [ findings add: { row at: 3. 'superclass'. parent name asString } ].
				parent := parent superclass ].
			{ { behavior. row at: 5. 'instance' }. { behavior class. row at: 6. 'class' } } do: [ :side |
				(side at: 2) do: [ :selector |
					pending := (side first compiledMethodAt: selector asSymbol) literals asOrderedCollection.
					[ pending isEmpty ] whileFalse: [ | literal value |
						literal := pending removeLast.
						value := (literal isKindOf: Association) ifTrue: [ literal value ] ifFalse: [ literal ].
						((value isBehavior and: [ names includes: value name asString ])
							or: [ value isSymbol and: [ names includes: value asString ] ])
							ifTrue: [ findings add: { row at: 3. side at: 3. selector. value printString } ].
						value isArray ifTrue: [ pending addAll: value ] ] ] ] ].
		findings asArray ]
		withArguments: { self canonicalSelection. owned }
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false.
	failures ifNotEmpty: [ self error: 'Sport runtime dependency rejected: ', failures printString ].
	^ owned
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> writeArtifacts: artifacts to: aDirectory [
	"Write already-generated string artifacts as exact truncated UTF8 bytes."
	| directory |
	directory := aDirectory asFileReference.
	directory ensureCreateDirectory.
	artifacts keysAndValuesDo: [ :name :source |
		(directory / name) binaryWriteStreamDo: [ :stream |
			stream truncate.
			stream nextPutAll: source utf8Encoded ] ].
	^ directory
]

{ #category : #validation }
GtGemStoneZincNativeExporter >> writeDictionaryHashProbeTo: aFile [
	GtGemStoneZincSoloHarness writeImportScriptTo: aFile files: #() validation: '| rows | rows := OrderedCollection new. rows add: { #layout. Dictionary allInstVarNames asArray }. #(''x'' ''lambda'' ''λ'' ''🙂'') do: [ :string | | unicode | unicode := string asUnicodeString. rows add: {string. string hash. unicode hash. (string _unicodeEqual: unicode). ([string = unicode] on: Error do: [:error | error class name])} ]. GsFile gciLogServer: ''ZINC_DICTIONARY_HASH_PROBE'', rows asArray printString. true'
]

{ #category : #validation }
GtGemStoneZincNativeExporter >> writeSoloHttpDriverTo: aFile port: aPort waitSeconds: seconds [
	| validation |
	self assert: (seconds between: 1 and: 300).
	validation := String streamContents: [ :stream |
		stream nextPutAll: '[ '; nextPutAll: (GtGemStoneZincRuntimeCompatibility startValidationServerSourceOn: aPort); nextPutAll: ' ] value.'; lf;
			nextPutAll: 'GsFile gciLogServer: ''ZINC_SOLO_HTTP_READY''.'; lf;
			nextPutAll: '[ (Delay forSeconds: '; print: seconds; nextPutAll: ') wait ] ensure: [ [ ';
			nextPutAll: GtGemStoneZincRuntimeCompatibility stopValidationServerSource;
			nextPutAll: ' ] value ].'; lf; nextPutAll: 'true' ].
	^ GtGemStoneZincSoloHarness writePrototypeDriverTo: aFile includeRuntime: true validation: validation
]

{ #category : #exporting }
GtGemStoneZincNativeExporter >> writeSportRemovalStatusReportTo: aFile [
	^ aFile asFileReference writeStreamDo: [ :stream |
		stream truncate; nextPutAll: self sportRemovalStatusReport ]
]
