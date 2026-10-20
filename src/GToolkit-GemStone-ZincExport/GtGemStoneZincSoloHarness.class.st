"
Generates independent Solo inventory and no-commit import drivers for frozen Zinc runtime exports. All generated files are validation artifacts outside source repositories. Solo sessions never replace or commit to the reference stone.
"
Class {
	#name : #GtGemStoneZincSoloHarness,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-ZincExport'
}

{ #category : #validation }
GtGemStoneZincSoloHarness class >> auditManifest: aManifest session: aSession [
	"Audit the frozen selection through the real target login without consulting source-reference classes."
	| manifest rows script |
	manifest := STONJSON fromString: aManifest asFileReference contents.
	rows := manifest at: 'selection'.
	script := '| z rows methods defined dictionaries active persistent |', String lf,
		'dictionaries := GsSession currentSession symbolList.', String lf,
		'z := dictionaries detect: [ :each | each name = #ZincGlobals ].', String lf,
		'(Globals at: #ZincGlobals) == z ifFalse: [ self error: ''Zinc dictionary identity mismatch'' ].', String lf,
		'(dictionaries indexOf: Globals) < (dictionaries indexOf: z) ifFalse: [ self error: ''GT dictionary priority changed'' ].', String lf,
		'persistent := System myUserProfile symbolList. active := dictionaries reject: [ :each | each name = #SessionMethods ]. active size = persistent size ifFalse: [ self error: ''Unexpected transient compilation context'' ]. 1 to: persistent size do: [ :i | (active at: i) == (persistent at: i) ifFalse: [ self error: ''Transient dictionary priority changed'' ] ].', String lf,
		'rows := ', rows asArray storeString, '.', String lf,
		'methods := 0. defined := 0.', String lf,
		'rows do: [ :row | | behavior |', String lf,
		' behavior := (row at: 4) ifTrue: [ defined := defined + 1. z at: (row at: 3) asSymbol ] ifFalse: [ Globals at: (row at: 3) asSymbol ].', String lf,
		' (row at: 5) do: [ :selector | (behavior includesSelector: selector asSymbol) ifFalse: [ self error: ''Missing native method: '', (row at: 3), ''>>'', selector ]. methods := methods + 1 ].', String lf,
		' (row at: 6) do: [ :selector | (behavior class includesSelector: selector asSymbol) ifFalse: [ self error: ''Missing native class method: '', (row at: 3), ''>>'', selector ]. methods := methods + 1 ] ].', String lf,
		'#(WAComponent WAApplication MCWorkingCopy Gofer Metacello GsUpgrader) do: [ :name |', String lf,
		' (dictionaries anySatisfy: [ :dictionary | dictionary includesKey: name ]) ifTrue: [ self error: ''Unexpected tooling/framework: '', name asString ] ].', String lf,
		'#(Announcer ZnBase64Encoder Stream ReadStream WriteStream) do: [ :name | (Globals at: name) == (z at: name) ifTrue: [ self error: ''GT and Zinc identities merged'' ] ].', String lf,
		'{ ''ZINC_REAL_MANIFEST_AUDIT_OK''. rows size. defined. methods. System myUserProfile userId. dictionaries collect: [ :each | each name ] }'.
	^ aSession evaluateAndWait: script serializationStrategy: #GtRsrWireSerializationStrategy
]

{ #category : #scripts }
GtGemStoneZincSoloHarness class >> inventoryScript [
	^ 'iferr 1 stk
iferr 2 stack
iferr 3 exit
expectvalue true
run
GsSession currentSession isSolo ifFalse: [ self error: ''Requires isolated Solo session'' ].
GsFile gciLogServer: ''ZINC_SOLO_INVENTORY_BEGIN''.
System myUserProfile symbolList do: [ :dictionary |
  GsFile gciLogServer: ''DICTIONARY '', dictionary name asString.
  dictionary keys asSortedCollection do: [ :key |
    | value |
    value := dictionary at: key.
    (value isKindOf: Behavior) ifTrue: [
      GsFile gciLogServer: ''CLASS '', dictionary name asString, '' '', key asString, '' '', value superclass printString.
      value selectors asSortedCollection do: [ :selector |
        GsFile gciLogServer: ''INSTANCE '', dictionary name asString, '' '', key asString, '' '', selector asString ].
      value class selectors asSortedCollection do: [ :selector |
        GsFile gciLogServer: ''CLASSMETHOD '', dictionary name asString, '' '', key asString, '' '', selector asString ] ] ] ].
GsFile gciLogServer: ''ZINC_SOLO_INVENTORY_END''.
true
%
errorCount
logout
exit
'
]

{ #category : #scripts }
GtGemStoneZincSoloHarness class >> proxyBindingsScript [
	^ 'expectvalue true
run
ZincGlobals at: #Smalltalk put: SmalltalkProxy new.
ZincGlobals at: #Transcript put: TranscriptProxy.
true
%
'
]

{ #category : #scripts }
GtGemStoneZincSoloHarness class >> restoreCompileContextScript [
	^ 'expectvalue true
run
GsSession currentSession transientSymbolList: nil.
(System myUserProfile symbolList last name = #ZincGlobals)
  ifFalse: [ self error: ''Zinc dictionary order changed'' ].
true
%
'
]

{ #category : #scripts }
GtGemStoneZincSoloHarness class >> systemUserLoginScript [
	^ 'set solologin on
set user SystemUser pass swordfish
login
'
]

{ #category : #validation }
GtGemStoneZincSoloHarness class >> validateLifecycleSession: aSession port: port to: evidenceFile [
 | results clientProbe startProbe stopProbe run |
 results := OrderedDictionary new.
 run := [:source | aSession evaluateAndWait: ('[ ', source, ' ] value. true') serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false].
 clientProbe := GtGemStoneZincRuntimeCompatibility clientValidationSourceOn: port.
 startProbe := GtGemStoneZincRuntimeCompatibility startValidationServerSourceOn: port.
 stopProbe := GtGemStoneZincRuntimeCompatibility stopValidationServerSource.
 results at: 'initialPersistence' put: (run value: GtGemStoneZincRuntimeCompatibility persistentRuntimeStateValidationSource).
 [
  results at: 'start' put: (run value: startProbe).
  results at: 'clientBeforeCommit' put: (run value: clientProbe).
  aSession commitTransaction ifFalse: [self error: 'Lifecycle validation commit failed']. results at: 'commit' put: true.
  results at: 'clientAfterCommit' put: (run value: clientProbe).
  aSession abortTransaction. results at: 'abort' put: true.
  results at: 'clientAfterAbort' put: (run value: clientProbe).
  results at: 'stop' put: (run value: stopProbe).
  results at: 'restartListener' put: (run value: startProbe).
  results at: 'clientAfterListenerRestart' put: (run value: clientProbe).
  results at: 'activePersistence' put: (run value: GtGemStoneZincRuntimeCompatibility persistentRuntimeStateValidationSource)
 ] ensure: [results at: 'finalStop' put: (run value: stopProbe)].
 evidenceFile asFileReference binaryWriteStreamDo: [:stream | stream truncate: 0; nextPutAll: (STONJSON toStringPretty: results) utf8Encoded].
 ^ results
]

{ #category : #validation }
GtGemStoneZincSoloHarness class >> validateRuntimeSession: aSession to: aFile staticDirectory: aDirectory [
	"Run the same native behavioral probes through the real GT connection and retain wire-decoded evidence."
	| checks results file |
	aSession isRunning ifFalse: [ self error: 'Validation requires a running GemStone session' ].
	checks := {
		'legacyRuntimeHttp' -> (GtGemStoneZincRuntimeCompatibility legacyRuntimeHttpValidationSourceForDictionaryNamed: 'ZincGlobals' port: 19604). 'sportIndependence' -> GtGemStoneZincStructuralValidation sportIndependenceValidationSource. 'nativeSocketFault' -> GtGemStoneZincRuntimeCompatibility nativeSocketFaultValidationSource. 'exceptionIdentity' -> GtGemStoneZincRuntimeCompatibility exceptionIdentityValidationSource. 'legacyParser' -> GtGemStoneZincRuntimeCompatibility legacyHttpParserValidationSource. 'legacyHttp' -> (GtGemStoneZincRuntimeCompatibility legacyHttpValidationSourceForDictionaryNamed: 'ZincGlobals' port: 19595). 'nativeReset' -> GtGemStoneZincRuntimeCompatibility nativeSocketResetValidationSource. 'percentCodec' -> GtGemStoneZincRuntimeCompatibility percentCodecValidationSource. 'legacyWriteHttp' -> (GtGemStoneZincRuntimeCompatibility legacyWriteHttpValidationSourceForDictionaryNamed: 'ZincGlobals' port: 19602). 'nativeSocket' -> GtGemStoneZincRuntimeCompatibility nativeSocketValidationSource. 'core' -> GtGemStoneZincRuntimeCompatibility coreValidationSource.
		'query' -> GtGemStoneZincRuntimeCompatibility unicodeQueryValidationSource.
		'staticFile' -> (GtGemStoneZincRuntimeCompatibility staticFileValidationSourceForDirectory: aDirectory).
		'eagerConstants' -> GtGemStoneZincRuntimeCompatibility eagerConstantsValidationSource.
		'sessionLogging' -> GtGemStoneZincRuntimeCompatibility sessionLoggingValidationSource.
		'persistentRuntime' -> GtGemStoneZincRuntimeCompatibility persistentRuntimeStateValidationSource }.
	checks := checks reject: [:check | #('nativeSocketFault' 'legacyParser' 'legacyHttp' 'legacyWriteHttp') includes: check key]. results := OrderedDictionary new.
	results at: 'session' put: aSession displayName;
		at: 'version' put: aSession gemstoneVersionString.
	checks do: [ :check | results at: check key put: (aSession evaluateAndWait: ('[ ', check value, ' ] value. true') serializationStrategy: #GtRsrWireSerializationStrategy) ].
	file := aFile asFileReference.
	file parent ensureCreateDirectory.
	file binaryWriteStreamDo: [ :stream |
		stream truncate: 0; nextPutAll: (STONJSON toStringPretty: results) utf8Encoded ].
	^ results
]

{ #category : #validation }
GtGemStoneZincSoloHarness class >> validateSession: aSession to: aFile staticDirectory: aDirectory [
	"Run the same native behavioral probes through the real GT connection and retain wire-decoded evidence."
	| checks results file |
	aSession isRunning ifFalse: [ self error: 'Validation requires a running GemStone session' ].
	checks := {
		'sportIndependence' -> GtGemStoneZincStructuralValidation sportIndependenceValidationSource. 'nativeSocketFault' -> GtGemStoneZincRuntimeCompatibility nativeSocketFaultValidationSource. 'exceptionIdentity' -> GtGemStoneZincRuntimeCompatibility exceptionIdentityValidationSource. 'legacyParser' -> GtGemStoneZincRuntimeCompatibility legacyHttpParserValidationSource. 'legacyHttp' -> (GtGemStoneZincRuntimeCompatibility legacyHttpValidationSourceForDictionaryNamed: 'ZincGlobals' port: 19595). 'nativeReset' -> GtGemStoneZincRuntimeCompatibility nativeSocketResetValidationSource. 'percentCodec' -> GtGemStoneZincRuntimeCompatibility percentCodecValidationSource. 'legacyWriteHttp' -> (GtGemStoneZincRuntimeCompatibility legacyWriteHttpValidationSourceForDictionaryNamed: 'ZincGlobals' port: 19602). 'nativeSocket' -> GtGemStoneZincRuntimeCompatibility nativeSocketValidationSource. 'core' -> GtGemStoneZincRuntimeCompatibility coreValidationSource.
		'query' -> GtGemStoneZincRuntimeCompatibility unicodeQueryValidationSource.
		'staticFile' -> (GtGemStoneZincRuntimeCompatibility staticFileValidationSourceForDirectory: aDirectory).
		'eagerConstants' -> GtGemStoneZincRuntimeCompatibility eagerConstantsValidationSource.
		'sessionLogging' -> GtGemStoneZincRuntimeCompatibility sessionLoggingValidationSource.
		'persistentRuntime' -> GtGemStoneZincRuntimeCompatibility persistentRuntimeStateValidationSource }.
	results := OrderedDictionary new.
	results at: 'session' put: aSession displayName;
		at: 'version' put: aSession gemstoneVersionString.
	checks do: [ :check | results at: check key put: (aSession evaluateAndWait: ('[ ', check value, ' ] value. true') serializationStrategy: #GtRsrWireSerializationStrategy) ].
	file := aFile asFileReference.
	file parent ensureCreateDirectory.
	file binaryWriteStreamDo: [ :stream |
		stream truncate: 0; nextPutAll: (STONJSON toStringPretty: results) utf8Encoded ].
	^ results
]

{ #category : #generating }
GtGemStoneZincSoloHarness class >> writeContextScriptsTo: aDirectory [
	| directory |
	directory := aDirectory asFileReference.
	directory ensureCreateDirectory.
	(directory / 'zinc-compile-context.topaz') binaryWriteStreamDo: [ :stream | stream position: 0; truncate. stream nextPutAll: self zincCompileContextScript withUnixLineEndings utf8Encoded ].
	(directory / 'restore-compile-context.topaz') binaryWriteStreamDo: [ :stream | stream position: 0; truncate. stream nextPutAll: self restoreCompileContextScript withUnixLineEndings utf8Encoded ].
	^ directory fullName
]

{ #category : #generation }
GtGemStoneZincSoloHarness class >> writeCurrentGtExportTo: aFile [
	"Use the normal GT exporter with a truncating UTF8 stream."
	| file source |
	file := aFile asFileReference.
	file parent ensureCreateDirectory.
	source := String streamContents: [ :stream |
		GtGemStoneGtCodeExporter new configuredExporter
			writeTopazOn: (ZnNewLineWriterStream on: stream) ].
	file binaryWriteStreamDo: [ :stream |
		stream truncate: 0; nextPutAll: source utf8Encoded ].
	^ file
]

{ #category : #generating }
GtGemStoneZincSoloHarness class >> writeImportScriptTo: aFile files: orderedFiles validation: validationSource [
	"Use raw generated exports, never a driver containing commit commands."
	| output |
	orderedFiles do: [ :path | path asFileReference exists ifFalse: [ self error: 'Missing artifact: ', path asString ] ].
	output := String streamContents: [ :stream |
		stream nextPutAll: 'iferr 1 stk'; lf; nextPutAll: 'iferr 2 stack'; lf; nextPutAll: 'iferr 3 exit'; lf.
		stream nextPutAll: 'expectvalue true'; lf; nextPutAll: 'run'; lf; nextPutAll: 'GsSession currentSession isSolo ifFalse: [ self error: ''Requires Solo'' ]. true'; lf; nextPutAll: '%'; lf.
		orderedFiles do: [ :path | stream nextPutAll: 'input '; nextPutAll: path asFileReference fullName; lf ].
		stream nextPutAll: 'expectvalue true'; lf; nextPutAll: 'run'; lf; nextPutAll: validationSource; lf; nextPutAll: '%'; lf.
		stream nextPutAll: 'errorCount'; lf; nextPutAll: 'logout'; lf; nextPutAll: 'exit'; lf ].
	 aFile asFileReference binaryWriteStreamDo: [ :stream | stream position: 0; truncate. stream nextPutAll: output withUnixLineEndings utf8Encoded ].
	 ^ aFile asFileReference fullName
]

{ #category : #generating }
GtGemStoneZincSoloHarness class >> writeInventoryTo: aDirectory [
	| directory |
	directory := aDirectory asFileReference.
	directory ensureCreateDirectory.
	(directory / 'solo-systemuser.ini') binaryWriteStreamDo: [ :stream | stream position: 0; truncate. stream nextPutAll: (self systemUserLoginScript) utf8Encoded ].
	(directory / 'solo-inventory.topaz') binaryWriteStreamDo: [ :stream | stream position: 0; truncate. stream nextPutAll: (self inventoryScript) utf8Encoded ].
	^ directory fullName
]

{ #category : #generating }
GtGemStoneZincSoloHarness class >> writePrototypeCompileDriverTo: aFile includeRuntime: includeRuntime [
	^ self writePrototypeDriverTo: aFile includeRuntime: includeRuntime validation: 'GsFile gciLogServer: ''ZINC_SOLO_COMPILE_PASS''. true'
]

{ #category : #generating }
GtGemStoneZincSoloHarness class >> writePrototypeDriverTo: aFile includeRuntime: includeRuntime validation: validationSource [
	| root directory prototype gtFiles zincFiles |
	root := FileLocator imageDirectory asFileReference.
	directory := aFile asFileReference parent.
	prototype := directory parent / 'native-prototype'.
	gtFiles := #('gt4gemstone/src-gs/Announcements.gs' 'gt4gemstone/src-gs/RemoteServiceReplication.gs' 'gt4gemstone/src-gs/STON.gs' 'gt4gemstone/src-gs/patch-gemstone.gs' 'gtoolkit-wireencoding/src-gs/gtoolkit-wireencoding.gs' 'gt4gemstone/src-gs/gt4gemstone.gs' 'gtoolkit-remote/src-gs/gtoolkit-remote.gs') collect: [ :relative | (root / relative) fullName ].
	zincFiles := (#('dependencies-definitions.topaz' 'zinc-definitions.topaz' 'global-bindings.topaz' 'dependencies-methods.topaz' 'zinc-methods.topaz') collect: [ :name | (prototype / name) fullName ]) asOrderedCollection.
	includeRuntime ifTrue: [ zincFiles add: (prototype / 'runtime-compatibility.topaz') fullName; add: (prototype / 'initialization.topaz') fullName ].
	^ self writeStagedImportScriptTo: aFile gtFiles: gtFiles zincFiles: zincFiles validation: validationSource
]

{ #category : #generating }
GtGemStoneZincSoloHarness class >> writePrototypeRuntimeDriverTo: aFile [
	^ self writePrototypeDriverTo: aFile includeRuntime: true validation: (GtGemStoneZincRuntimeCompatibility coreValidationSource, '. true')
]

{ #category : #generating }
GtGemStoneZincSoloHarness class >> writeStagedImportScriptTo: aFile gtFiles: gtFiles zincFiles: zincFiles validation: validationSource [
	| directory inputs |
	directory := aFile asFileReference parent.
	self writeContextScriptsTo: directory.
	inputs := gtFiles asOrderedCollection.
	inputs add: (directory / 'zinc-compile-context.topaz') fullName.
	inputs addAll: zincFiles.
	inputs add: (directory / 'restore-compile-context.topaz') fullName.
	^ self writeImportScriptTo: aFile files: inputs validation: validationSource
]

{ #category : #scripts }
GtGemStoneZincSoloHarness class >> zincCompileContextScript [
	^ 'expectvalue true
run
| persistent zinc compiling |
persistent := System myUserProfile symbolList.
(persistent anySatisfy: [ :dictionary | dictionary name = #ZincGlobals ])
  ifTrue: [ self error: ''Zinc import requires a fresh install'' ].
persistent createDictionaryNamed: #ZincGlobals at: persistent size + 1.
zinc := persistent last.
Globals at: #ZincGlobals put: zinc.
compiling := persistent copy.
compiling remove: zinc.
compiling insertObject: zinc at: 1.
GsSession currentSession transientSymbolList: compiling.
true
%
'
]
