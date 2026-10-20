"
Captures explicit dictionary-qualified reference class layouts, selected method protocols and compiled class-global associations. Generates isolated Solo and real-stone validation artifacts without modifying reference state.
"
Class {
	#name : #GtGemStoneZincStructuralValidation,
	#superclass : #Object,
	#instVars : [
		'metadata',
		'pristineMetadata'
	],
	#category : #'GToolkit-GemStone-ZincExport'
}

{ #category : #generating }
GtGemStoneZincStructuralValidation class >> capturePrototypeAndWriteFullGtReloadTo: aFile [
	^ (self capturePrototypeNear: aFile) writeSoloDriverTo: aFile reloadFiles: { (FileLocator imageDirectory / 'llm/zinc-work/current-GT.gs') fullName }
]

{ #category : #generating }
GtGemStoneZincStructuralValidation class >> capturePrototypeAndWriteTo: aFile reloadGt: reloadGt [
	^ (self capturePrototypeNear: aFile) writeSoloDriverTo: aFile reloadGt: reloadGt
]

{ #category : #capturing }
GtGemStoneZincStructuralValidation class >> capturePrototypeNear: aFile [
	| manifest selection validator log |
	manifest := NeoJSONReader fromString: (aFile asFileReference parent parent / 'native-prototype/manifest.json') contents.
	selection := manifest at: 'selection'.
	validator := self new captureSelection: selection.
	log := aFile asFileReference parent / 'structural-import.log'.
	(log exists and: [ log contents lines anySatisfy: [ :line | line beginsWith: 'ZINC_PRISTINE_LAYOUT|' ] ]) ifTrue: [ validator capturePristineMetadataFromLog: log ].
	^ validator
]

{ #category : #scripts }
GtGemStoneZincStructuralValidation class >> originalGtKernelMetadataSourceFor: selectedRows [
	^ '| selected records |
selected := __ROWS__.
records := OrderedCollection new.
selected do: [ :row |
  | behavior |
  behavior := Globals at: (row at: 3) asSymbol.
  { { behavior. row at: 5. ''instance'' }. { behavior class. row at: 6. ''class'' } } do: [ :side |
    (side at: 2) do: [ :selector |
      records add: { row at: 3. side at: 3. selector.
        (side first includesSelector: selector asSymbol).
        (side first includesSelector: selector asSymbol)
          ifTrue: [ (side first categoryOfSelector: selector asSymbol) asString ] ifFalse: [ '''' ].
        (side first includesSelector: selector asSymbol)
          ifTrue: [ (side first compiledMethodAt: selector asSymbol) sourceString ] ifFalse: [ '''' ] } ] ] ].
GsFile gciLogServer: ''ZINC_ORIGINAL_GT_KERNEL_METADATA '', (STON toString: records asArray).
true' copyReplaceAll: '__ROWS__' with: selectedRows storeString
]

{ #category : #scripts }
GtGemStoneZincStructuralValidation class >> pristineStreamCaptureScript [
	^ 'expectvalue true
run
| rows join |
join := [ :names | names inject: '''' into: [ :string :name | string, name asString, '','' ] ].
rows := #(Stream PositionableStream ReadStream WriteStream ReadWriteStream) collect: [ :name |
  | behavior |
  behavior := Globals at: name.
  GsFile gciLogServer: ''ZINC_PRISTINE_LAYOUT|'', name asString, ''|'', behavior superclass name asString, ''|'',
    (join value: behavior instVarNames), ''|'', (join value: behavior allInstVarNames), ''|'',
    (join value: behavior classVarNames asSortedCollection), ''|'', (join value: behavior class instVarNames), ''|'',
    (join value: behavior _optionsArrayForDefinition asSortedCollection), ''|'', (join value: (behavior sharedPools collect: [ :pool | pool name ]) asSortedCollection).
  { name. behavior. behavior superclass.
    behavior instVarNames. behavior allInstVarNames.
    behavior classVarNames asSortedCollection asArray.
    behavior class instVarNames. behavior _optionsArrayForDefinition asSortedCollection asArray } ].
SessionTemps current at: #ZincPristineGlobalStreamMetadata put: rows.
true
%
'
]

{ #category : #validation }
GtGemStoneZincStructuralValidation class >> sharedAdapterBehaviorValidationSource [
	^ '| z check bytes text dictionary value failed stream read url combined server exceptions |
z := GsSession currentSession symbolList detect: [ :each | each name = #ZincGlobals ].
check := [ :condition :message | condition ifFalse: [ self error: message ] ].
check value: #(1 2) isArray value: ''Array isArray regression''.
check value: Object new isArray not value: ''Object isArray regression''.
bytes := #[0 65 127 255].
text := bytes asString.
check value: (text asByteArray = bytes) value: ''ByteArray asString byte conversion regression''.
check value: (bytes hex = ''00417fff'') value: ''ByteArray lowercase hex regression''.
dictionary := Dictionary newFromPairs: { #first. 1. #second. 2. #first. 3 }.
check value: (dictionary size = 2 and: [ (dictionary at: #first) = 3 and: [ (dictionary at: #second) = 2 ] ]) value: ''Dictionary pair construction regression''.
stream := ''-123x'' readStream.
value := Integer readFrom: stream ifFail: [ #failed ].
check value: (value = -123 and: [ stream peek = $x ]) value: ''Integer signed parsing or stream position regression''.
check value: ((Integer readFrom: '''' ifFail: [ #failed ]) = #failed) value: ''Integer empty failure regression''.
check value: ((Integer readFrom: ''-'' ifFail: [ #failed ]) = #failed) value: ''Integer missing digits failure regression''.
check value: ((Integer readFrom: ''42'' ifFail: [ #failed ]) = 42) value: ''Integer string parsing regression''.
Object new assert: [ true ].
failed := false.
[ [ Object new assert: [ false ] ] on: (z at: #AssertionFailure) do: [ :error | failed := true ] ] on: Error do: [ :error | failed := true ].
check value: failed value: ''Object assertion failure regression''.
check value: (1 closeTo: 1) value: ''Integer closeTo equality regression''.
check value: (1 closeTo: 2) not value: ''Integer closeTo inequality regression''.
check value: (1 closeTo: 1.0) value: ''Numeric closeTo float regression''.
stream := String new writeStream.
stream nextPutAll: ''stream-check''.
check value: (stream contents = ''stream-check'') value: ''Shared text writeStream regression''.
read := stream contents readStream.
check value: (read next: 6) = ''stream'' value: ''Shared stream reading regression''.
check value: (read upToEnd = ''-check'') value: ''Shared stream remainder regression''.
stream := ByteArray new writeStream.
stream nextPut: 0; nextPut: 255.
check value: (stream contents = #[0 255]) value: ''Shared binary writeStream regression''.
url := (z at: #ZnUrl) fromString: ''http://localhost/base''.
combined := #(''child'' ''tail'') addedToZnUrl: url.
check value: (combined segments size = 3) value: ''Collection URL segments count regression''.
check value: ((combined segments at: 2) asUnicodeString = ''child'' asUnicodeString) value: ''Collection URL segment value regression''.
combined := ''/child//tail/'' addedToZnUrl: url.
check value: (combined segments size = 3) value: ''String URL tokenization regression''.
check value: ((combined segments at: 3) asUnicodeString = ''tail'' asUnicodeString) value: ''String URL final segment regression''.
url := ''http://localhost/bridge?x=1'' asZnUrl.
check value: (url class == (z at: #ZnUrl)) value: ''String URL bridge did not select native Zinc''.
check value: ((url queryAt: ''x'') asUnicodeString = ''1'' asUnicodeString) value: ''String URL query regression''.
server := (z at: #ZnMultiThreadedServer) new.
exceptions := server exceptionSet: #(#ConnectionClosed).
check value: (exceptions size = 1 and: [ (exceptions at: 1) == (z at: #ConnectionClosed) ]) value: ''Native exception set class member identity changed''.
check value: (exceptions handles: (z at: #ConnectionClosed) basicNew) value: ''Private ConnectionClosed missing from native termination handlers''.
((Globals includesKey: #ConnectionClosed) and: [ (Globals at: #ConnectionClosed) ~~ (z at: #ConnectionClosed) ]) ifTrue: [
	check value: (exceptions handles: (Globals at: #ConnectionClosed) basicNew) not value: ''Private termination handler selected overlapping GT ConnectionClosed'' ].
check value: (server readRequestTerminationExceptionSet handles: (z at: #ConnectionClosed) basicNew) value: ''Native termination handler lost private exception identity''.
GsFile gciLogServer: ''ZINC_SHARED_ADAPTER_BEHAVIOR_PASS''.
true'
]

{ #category : #generating }
GtGemStoneZincStructuralValidation class >> sportIndependenceValidationSource [
 ^ '| forbidden dictionaries inspectLiteral z count seen owners |
forbidden := __NAMES__.
dictionaries := GsSession currentSession symbolList.
forbidden do: [:name |
 (dictionaries anySatisfy: [:dictionary | dictionary includesKey: name asSymbol])
  ifTrue: [self error: ''Sport class is installed: '', name]].
z := dictionaries detect: [:dictionary | dictionary name = #ZincGlobals].
(z at: #SocketStreamSocket) superclass == Object ifFalse: [self error: ''Native socket superclass mismatch''].
(z at: #SocketStreamSocket) allInstVarNames = #(underlyingSocket) ifFalse: [self error: ''Native socket transient storage layout mismatch''].
(z at: #HTTPSocket) superclass == (z at: #SocketStreamSocket) ifFalse: [self error: ''Legacy socket superclass mismatch''].
seen := IdentitySet new. inspectLiteral := [:literal | (seen includes: literal) ifFalse: [seen add: literal.
 (literal isSymbol and: [forbidden includes: literal asString]) ifTrue: [self error: ''Sport class-name symbol dependency: '', literal asString].
 ((literal isKindOf: Association) and: [forbidden includes: literal key asString]) ifTrue: [self error: ''Sport global binding dependency: '', literal key asString].
 (literal isKindOf: Association) ifTrue: [inspectLiteral value: literal value]. literal isBehavior ifTrue: [(forbidden includes: literal name asString) ifTrue: [self error: ''Sport behavior literal dependency'']].
 literal isArray ifTrue: [literal do: [:each | inspectLiteral value: each]]]].
#(NetworkError ConnectionClosed) do: [:name | (Globals at: name ifAbsent: [nil]) == (z at: name) ifTrue: [self error: ''Private socket exception identity merged'']]. count := 0. owners := IdentitySet new.
(z values, Globals values) do: [:behavior | behavior isBehavior ifTrue: [
 (behavior allSuperclasses anySatisfy: [:superclass | forbidden includes: superclass name asString]) ifTrue: [self error: ''Sport ancestor dependency: '', behavior name asString].
 {behavior. behavior class} do: [:side |
  | owner | owner := side. [owner notNil and: [(owners includes: owner) not]] whileTrue: [owners add: owner. owner selectors do: [:selector |
   | method | method := owner compiledMethodAt: selector.
   method literals do: [:literal | inspectLiteral value: literal].
   count := count + 1]. owner := owner superclass]]]].
GsFile gciLogServer: ''ZINC_SPORT_ABSENT_PASS '', count printString.
true' copyReplaceAll: '__NAMES__' with: GtGemStoneZincNativeExporter new historicalSportOwnedClassNames asArray storeString
]

{ #category : #generating }
GtGemStoneZincStructuralValidation class >> writeOriginalGtBaselineDriverTo: aFile [
	| root manifest rows gtFiles |
	root := FileLocator imageDirectory asFileReference.
	manifest := NeoJSONReader fromString: (aFile asFileReference parent parent / 'native-prototype/manifest.json') contents.
	rows := (manifest at: 'selection') select: [ :row | (row at: 4) not and: [ (row at: 2) = 'Globals' ] ].
	gtFiles := #('gt4gemstone/src-gs/Announcements.gs' 'gt4gemstone/src-gs/RemoteServiceReplication.gs' 'gt4gemstone/src-gs/STON.gs' 'gt4gemstone/src-gs/patch-gemstone.gs' 'gtoolkit-wireencoding/src-gs/gtoolkit-wireencoding.gs' 'gt4gemstone/src-gs/gt4gemstone.gs' 'gtoolkit-remote/src-gs/gtoolkit-remote.gs') collect: [ :relative | (root / relative) fullName ].
	^ GtGemStoneZincSoloHarness writeImportScriptTo: aFile files: gtFiles validation: (self originalGtKernelMetadataSourceFor: rows)
]

{ #category : #generating }
GtGemStoneZincStructuralValidation class >> writeOriginalGtBaselineJsonFrom: aLog to: aFile [
	| marker line rows source |
	marker := 'ZINC_ORIGINAL_GT_KERNEL_METADATA '.
	line := aLog asFileReference contents lines detect: [ :each | each beginsWith: marker ].
	rows := STON fromString: (line allButFirst: marker size).
	source := NeoJSONWriter toStringPretty: rows.
	aFile asFileReference binaryWriteStreamDo: [ :stream | stream position: 0; truncate. stream nextPutAll: source utf8Encoded ].
	^ { rows size. (rows count: [ :row | row at: 4 ]). ((rows select: [ :row | row at: 4 ]) collect: [ :row | row copyFrom: 1 to: 5 ]) }
]

{ #category : #generating }
GtGemStoneZincStructuralValidation class >> writeSharedAdapterEvidenceTo: aFile [
	| root manifest rows baseline descriptors keys native records source |
	root := FileLocator imageDirectory asFileReference.
	manifest := NeoJSONReader fromString: (root / 'llm/zinc-work/native-prototype/manifest.json') contents.
	rows := manifest at: 'selection'.
	baseline := NeoJSONReader fromString: (root / 'llm/zinc-work/default-extent-solo/original-gt-kernel-baseline.json') contents.
	descriptors := GtGemStoneExtensionMethods extensions select: [ :extension |
		baseline anySatisfy: [ :row | row first = extension className asString and: [ row second = (extension meta ifTrue: [ 'class' ] ifFalse: [ 'instance' ]) and: [ row third = extension selector asString ] ] ] ].
	keys := descriptors collect: [ :extension | { extension className asString. extension meta. extension selector asString } ].
	native := GtGemStoneSessionRegistry defaultSession evaluateBlockAndWait: [ :entries |
		entries collect: [ :entry |
			| behavior method |
			behavior := Globals at: entry first asSymbol.
			entry second ifTrue: [ behavior := behavior class ].
			method := behavior compiledMethodAt: entry third asSymbol.
			{ (behavior categoryOfSelector: entry third asSymbol) asString. method sourceString } ] ]
		withArguments: { keys } serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false.
	records := descriptors withIndexCollect: [ :extension :index |
		| original old nativeRow selected |
		original := native at: index.
		old := baseline detect: [ :row | row first = extension className asString and: [ row second = (extension meta ifTrue: [ 'class' ] ifFalse: [ 'instance' ]) and: [ row third = extension selector asString ] ] ].
		selected := rows anySatisfy: [ :row | (row at: 4) not and: [ row second = 'Globals' and: [ row third = extension className asString and: [ (row at: (extension meta ifTrue: [ 6 ] ifFalse: [ 5 ])) includes: extension selector asString ] ] ] ].
		OrderedDictionary new
			at: 'class' put: extension className asString;
			at: 'selector' put: extension selector asString;
			at: 'classSide' put: extension meta;
			at: 'currentlySelected' put: selected;
			at: 'baselineExists' put: (old at: 4);
			at: 'baselineProtocol' put: (old at: 5);
			at: 'baselineSource' put: (old at: 6);
			at: 'nativeProtocol' put: original first;
			at: 'nativeSource' put: original second;
			at: 'nativeSHA256' put: (extension sha256Of: original second);
			at: 'gtProtocol' put: extension protocol asString;
			at: 'gtExpectedOriginalHash' put: extension hash asString;
			at: 'gtSource' put: extension source;
			yourself ].
	source := NeoJSONWriter toStringPretty: records.
	aFile asFileReference binaryWriteStreamDo: [ :stream | stream position: 0; truncate. stream nextPutAll: source utf8Encoded ].
	^ records size
]

{ #category : #capturing }
GtGemStoneZincStructuralValidation >> applyOverlayExpectations [
	^ self applyOverlayExpectations: GtGemStoneZincRuntimeCompatibility extensions
]

{ #category : #capturing }
GtGemStoneZincStructuralValidation >> applyOverlayExpectations: extensionDescriptors [
	"Overlays intentionally replace source globals. Compare their managed protocol and presence, not the removed native bindings."
	extensionDescriptors do: [ :extension |
		(metadata detect: [ :row | (row at: 2) = extension className asString ] ifNone: [ nil ]) ifNotNil: [ :row |
			| side methods existing |
			side := extension meta ifTrue: [ 'class' ] ifFalse: [ 'instance' ].
			methods := (row at: 12) asOrderedCollection.
			existing := methods detect: [ :method | method first = side and: [ method second = extension selector asString ] ] ifNone: [ nil ].
			existing ifNotNil: [
				self assert: existing third = extension protocol asString.
				row first = 'Globals' ifFalse: [ existing at: 4 put: #() ] ]
			ifNil: [ methods add: { side. extension selector asString. extension protocol asString. #() } ].
			row at: 12 put: methods asArray ] ].
	^ self
]

{ #category : #capturing }
GtGemStoneZincStructuralValidation >> capturePristineMetadataFromLog: aFile [
	| lines |
	lines := aFile asFileReference contents lines select: [ :line | line beginsWith: 'ZINC_PRISTINE_LAYOUT|' ].
	self assert: lines size = 5.
	pristineMetadata := lines collect: [ :line |
		| fields |
		fields := line splitOn: $|.
		{ fields second. fields third }, ((fields copyFrom: 4 to: 9) collect: [ :field | ((field splitOn: $,) reject: #isEmpty) asArray ]) ].
	^ self
]

{ #category : #capturing }
GtGemStoneZincStructuralValidation >> captureSelection: selection [
 ^ self captureSelection: selection session: GtGemStoneSessionRegistry defaultSession
]

{ #category : #capturing }
GtGemStoneZincStructuralValidation >> captureSelection: selection session: sourceSession [
	metadata := sourceSession evaluateBlockAndWait: [ :rows |
		| dictionaries definedNames |
		dictionaries := System myUserProfile symbolList.
		definedNames := (rows select: [ :row | row at: 4 ]) collect: [ :row | row at: 3 ].
		rows collect: [ :row |
			| dictionary behavior protocols superName superHome |
			dictionary := dictionaries detect: [ :each | each name asString = (row at: 2) ].
			behavior := dictionary at: (row at: 3) asSymbol.
			superName := behavior superclass ifNil: [ '' ] ifNotNil: [ :superclass | superclass name asString ].
			superHome := (definedNames includes: superName) ifTrue: [ 'ZincGlobals' ] ifFalse: [ 'Globals' ].
			protocols := OrderedCollection new.
			{ { behavior. row at: 5. 'instance' }. { behavior class. row at: 6. 'class' } } do: [ :side |
				(side at: 2) do: [ :selector | | method references |
					method := side first compiledMethodAt: selector asSymbol.
					references := OrderedCollection new.
					method literals do: [ :literal |
						((literal isKindOf: Association) and: [ literal value isBehavior ]) ifTrue: [
							(dictionaries anySatisfy: [ :each | (each associationAt: literal key ifAbsent: [ nil ]) == literal ]) ifTrue: [
								references add: { literal key asString. ((definedNames includes: literal key asString) or: [ literal key = #Transcript ]) ifTrue: [ 'ZincGlobals' ] ifFalse: [ 'Globals' ] } ] ] ].
					protocols add: { side at: 3. selector. (side first categoryOfSelector: selector asSymbol) asString. references asArray } ] ].
			{ (row at: 4) ifTrue: [ 'ZincGlobals' ] ifFalse: [ row at: 2 ]. row at: 3. row at: 2. row at: 4.
				superName. superHome. (behavior instVarNames collect: #asString) asArray.
				(behavior classVarNames collect: #asString) asSortedCollection asArray.
				(behavior class instVarNames collect: #asString) asArray.
				(behavior _optionsArrayForDefinition collect: #asString) asSortedCollection asArray.
				(behavior sharedPools collect: [ :pool | pool name asString ]) asSortedCollection asArray.
				protocols asArray } ] ]
		withArguments: { selection }
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false.
	self applyOverlayExpectations: (GtGemStoneZincRuntimeCompatibility extensions, (GtGemStoneZincRuntimeCompatibility constructorExtensionsFor: selection session: sourceSession)).
	^ self
]

{ #category : #metadata }
GtGemStoneZincStructuralValidation >> loadCapturedMetadataFrom: aDirectory [
	"Use previously captured reference metadata when regenerating only reviewed companions. No source database is required."
	| directory |
	directory := aDirectory asFileReference.
	metadata := STONJSON fromString: (directory / 'reference-structure.json') contents.
	pristineMetadata := STONJSON fromString: (directory / 'pristine-kernel-stream-structure.json') contents.
	self applyOverlayExpectations: GtGemStoneZincRuntimeCompatibility extensions.
	^ self
]

{ #category : #accessing }
GtGemStoneZincStructuralValidation >> metadataSnapshot [
	"Dictionary-qualified layouts, selected protocols and compiled global binding expectations."
	^ metadata deepCopy
]

{ #category : #generating }
GtGemStoneZincStructuralValidation >> validationBody [
	^ 'pristine do: [ :row |
  | behavior actual |
  behavior := Globals at: row first asSymbol.
  actual := { behavior superclass name asString.
    (behavior instVarNames collect: [ :name | name asString ]) asArray.
    (behavior allInstVarNames collect: [ :name | name asString ]) asArray.
    (behavior classVarNames collect: [ :name | name asString ]) asSortedCollection asArray.
    (behavior class instVarNames collect: [ :name | name asString ]) asArray.
    (behavior _optionsArrayForDefinition collect: [ :name | name asString ]) asSortedCollection asArray.
    (behavior sharedPools collect: [ :pool | pool name asString ]) asSortedCollection asArray }.
  actual = (row copyFrom: 2 to: 8) ifFalse: [ self error: ''Pristine native Globals layout mismatch: '', row first ] ].
(SessionTemps current at: #ZincPristineGlobalStreamMetadata ifAbsent: [ nil ]) ifNotNil: [ :rows |
  rows do: [ :row |
    | behavior |
    behavior := Globals at: row first.
    { behavior. behavior superclass. behavior instVarNames. behavior allInstVarNames.
      behavior classVarNames asSortedCollection asArray. behavior class instVarNames.
      behavior _optionsArrayForDefinition asSortedCollection asArray }
      = (row copyFrom: 2 to: 8)
      ifFalse: [ self error: ''Pristine Globals stream changed: '', row first asString ] ] ].
expected do: [ :row |
  | dictionary behavior actual protocols |
  dictionary := dictionaries detect: [ :each | each name asString = (row at: 1) ].
  behavior := dictionary at: (row at: 2) asSymbol.
  actual := {
    behavior superclass ifNil: [ '''' ] ifNotNil: [ :superclass | superclass name asString ].
    (behavior instVarNames collect: [ :name | name asString ]) asArray.
    (behavior classVarNames collect: [ :name | name asString ]) asSortedCollection asArray.
    (behavior class instVarNames collect: [ :name | name asString ]) asArray.
    (behavior _optionsArrayForDefinition collect: [ :name | name asString ]) asSortedCollection asArray.
    (behavior sharedPools collect: [ :pool |
      (row at: 11) detect: [ :poolName |
        (ZincGlobals at: poolName asSymbol ifAbsent: [ Globals at: poolName asSymbol ]) _classVars == pool ]
        ifNone: [ ''UNEXPECTED_POOL_IDENTITY'' ] ]) asSortedCollection asArray }.
  actual = { row at: 5. row at: 7. row at: 8. row at: 9. row at: 10. row at: 11 }
    ifFalse: [ GsFile gciLogServer: ''STRUCTURE_ACTUAL '', actual printString.
      GsFile gciLogServer: ''STRUCTURE_EXPECTED '', { row at: 5. row at: 7. row at: 8. row at: 9. row at: 10. row at: 11 } printString.
      self error: ''Class structure mismatch: '', (row at: 1), ''::'', (row at: 2) ].
  ((row at: 4) and: [ (row at: 5) notEmpty ]) ifTrue: [
    | superDictionary |
    superDictionary := dictionaries detect: [ :each | each name asString = (row at: 6) ].
    behavior superclass == (superDictionary at: (row at: 5) asSymbol)
      ifFalse: [ self error: ''Superclass binding mismatch: '', (row at: 2) ] ].
  (row at: 12) do: [ :methodRow |
    | side selector method |
    side := methodRow first = ''class'' ifTrue: [ behavior class ] ifFalse: [ behavior ].
    selector := (methodRow at: 2) asSymbol.
    (side includesSelector: selector) ifFalse: [ self error: ''Missing own method: '', (row at: 2), ''>>'', selector asString ].
    (side categoryOfSelector: selector) asString = (methodRow at: 3)
      ifFalse: [ self error: ''Protocol mismatch: '', (row at: 2), ''>>'', selector asString ].
    method := side compiledMethodAt: selector.
    (methodRow at: 4) do: [ :binding |
      | expectedDictionary expectedClass |
      expectedDictionary := dictionaries detect: [ :each | each name asString = (binding at: 2) ].
      expectedClass := expectedDictionary at: binding first asSymbol.
      (method literals anySatisfy: [ :literal |
        (literal isKindOf: Association) and: [
          literal key asString = binding first and: [ literal value == expectedClass ] ] ])
        ifFalse: [ self error: ''Compiled binding mismatch: '', (row at: 2), ''>>'', selector asString, '' -> '', binding first ] ] ] ].
#(WAComponent WAApplication Gofer Metacello MCWorkingCopy GsUpgrader) do: [ :name |
  (dictionaries anySatisfy: [ :dictionary | dictionary includesKey: name ])
    ifTrue: [ self error: ''Unexpected framework/tooling global: '', name asString ] ].
#(Announcer ZnBase64Encoder Stream ReadStream WriteStream) do: [ :name |
  (Globals at: name) == (ZincGlobals at: name)
    ifTrue: [ self error: ''Shared GT/Zinc class identity: '', name asString ] ].
(ZincGlobals at: #Smalltalk) class == (ZincGlobals at: #SmalltalkProxy)
  ifFalse: [ self error: ''Smalltalk proxy binding mismatch'' ].
(ZincGlobals at: #Transcript) == (ZincGlobals at: #TranscriptProxy)
  ifFalse: [ self error: ''Transcript proxy binding mismatch'' ].
{
  { ''RsrConnection''. false. ''initialize''. ''Announcer''. ''Globals'' }.
  { ''ByteArray''. false. ''base64Encoded''. ''ZnBase64Encoder''. ''Globals'' }.
  { ''ZnLogSupport''. false. ''announcer''. ''Announcer''. ''ZincGlobals'' }
} do: [ :binding |
  | dictionary behavior method expectedDictionary |
  dictionary := binding first = ''ZnLogSupport'' ifTrue: [ ZincGlobals ] ifFalse: [ Globals ].
  behavior := dictionary at: binding first asSymbol.
  method := (binding second ifTrue: [ behavior class ] ifFalse: [ behavior ]) compiledMethodAt: (binding at: 3) asSymbol.
  expectedDictionary := dictionaries detect: [ :each | each name asString = (binding at: 5) ].
  (method literals anySatisfy: [ :literal |
    (literal isKindOf: Association) and: [
      literal key asString = (binding at: 4) and: [ literal value == (expectedDictionary at: (binding at: 4) asSymbol) ] ] ])
    ifFalse: [ self error: ''Explicit GT/Zinc binding failure: '', binding first, ''>>'', (binding at: 3) ] ].
GsFile gciLogServer: ''ZINC_STRUCTURE_PROTOCOL_BINDINGS_PASS''.
true'
]

{ #category : #generating }
GtGemStoneZincStructuralValidation >> validationSource [
	metadata ifNil: [ self error: 'Capture the reference selection first' ].
	^ String streamContents: [ :stream |
		stream nextPutAll: '| expected dictionaries pristine |'; lf;
			nextPutAll: 'expected := '; nextPutAll: metadata storeString; nextPutAll: '.'; lf;
			nextPutAll: 'pristine := '; nextPutAll: (pristineMetadata ifNil: [ #() ]) storeString; nextPutAll: '.'; lf;
			nextPutAll: 'dictionaries := GsSession currentSession symbolList.'; lf;
			nextPutAll: self validationBody ]
]

{ #category : #generating }
GtGemStoneZincStructuralValidation >> validationSourceAfterGtReload [
	| original source |
	original := metadata.
	[ metadata := metadata select: [ :row | row first = 'ZincGlobals' ].
		source := self validationSource ] ensure: [ metadata := original ].
	^ source, '. ', String lf,
		'(''http://localhost/after-reload'' asZnUrl class == (ZincGlobals at: #ZnUrl)) ifFalse: [ self error: ''String URL conversion did not select native Zinc runtime'' ]. true'
]

{ #category : #generation }
GtGemStoneZincStructuralValidation >> writeArtifactsTo: aDirectory [
	| directory files wrap |
	directory := aDirectory asFileReference.
	directory ensureCreateDirectory.
	wrap := [ :source | 'expectvalue true', String lf, 'run', String lf, source, '. true', String lf, '%', String lf ].
	files := OrderedDictionary new
		at: 'reference-structure.json' put: (NeoJSONWriter toStringPretty: metadata);
		at: 'pristine-kernel-stream-structure.json' put: (NeoJSONWriter toStringPretty: (pristineMetadata ifNil: [ #() ]));
		at: 'sport-independence-validation.topaz' put: (wrap value: self class sportIndependenceValidationSource); at: 'native-socket-fault-validation.topaz' put: (wrap value: GtGemStoneZincRuntimeCompatibility nativeSocketFaultValidationSource); at: 'exception-identity-validation.topaz' put: (wrap value: GtGemStoneZincRuntimeCompatibility exceptionIdentityValidationSource); at: 'legacy-http-validation.topaz' put: (wrap value: (GtGemStoneZincRuntimeCompatibility legacyHttpValidationSourceForDictionaryNamed: 'ZincGlobals' port: 19595)); at: 'legacy-parser-validation.topaz' put: (wrap value: GtGemStoneZincRuntimeCompatibility legacyHttpParserValidationSource); at: 'native-reset-validation.topaz' put: (wrap value: GtGemStoneZincRuntimeCompatibility nativeSocketResetValidationSource); at: 'percent-codec-validation.topaz' put: (wrap value: GtGemStoneZincRuntimeCompatibility percentCodecValidationSource); at: 'legacy-write-http-validation.topaz' put: (wrap value: (GtGemStoneZincRuntimeCompatibility legacyWriteHttpValidationSourceForDictionaryNamed: 'ZincGlobals' port: 19602)); at: 'native-socket-validation.topaz' put: (wrap value: GtGemStoneZincRuntimeCompatibility nativeSocketValidationSource); at: 'structural-validation.topaz' put: (wrap value: self validationSource);
		at: 'post-reload-validation.topaz' put: (wrap value: self validationSourceAfterGtReload);
		at: 'shared-adapter-behavior.topaz' put: (wrap value: self class sharedAdapterBehaviorValidationSource);
		at: 'pristine-stream-capture.topaz' put: self class pristineStreamCaptureScript;
		at: 'unicode-query-validation.topaz' put: (wrap value: GtGemStoneZincRuntimeCompatibility unicodeQueryValidationSource);
		at: 'eager-constants-validation.topaz' put: (wrap value: GtGemStoneZincRuntimeCompatibility eagerConstantsValidationSource);
		at: 'session-logging-validation.topaz' put: (wrap value: GtGemStoneZincRuntimeCompatibility sessionLoggingValidationSource);
		at: 'core-validation.topaz' put: (wrap value: GtGemStoneZincRuntimeCompatibility coreValidationSource);
		at: 'static-validation.topaz' put: (wrap value: (GtGemStoneZincRuntimeCompatibility staticFileValidationSourceForDirectory: (directory parent / 'native-prototype') fullName));
		at: 'persistent-state-validation.topaz' put: (wrap value: GtGemStoneZincRuntimeCompatibility persistentRuntimeStateValidationSource);
		yourself.
	files keysAndValuesDo: [ :name :source | (directory / name) binaryWriteStreamDo: [ :stream | stream position: 0; truncate. stream nextPutAll: source withUnixLineEndings utf8Encoded ] ].
	^ directory
]

{ #category : #generation }
GtGemStoneZincStructuralValidation >> writeFullGtHttpDriverTo: aFile port: aPort [
	| baseline output marker validation |
	baseline := aFile asFileReference parent / 'full-gt-reload-import.topaz'.
	self writeSoloDriverTo: baseline reloadFiles: { (FileLocator imageDirectory / 'llm/zinc-work/current-GT.gs') fullName }.
	output := baseline contents.
	marker := 'errorCount', String lf, 'logout', String lf, 'exit', String lf.
	(output endsWith: marker) ifFalse: [ self error: 'Unexpected Solo driver trailer' ].
	validation := '[ ', (GtGemStoneZincRuntimeCompatibility startValidationServerSourceOn: aPort), ' ] value.', String lf,
		'[ [ ', (GtGemStoneZincRuntimeCompatibility clientValidationSourceOn: aPort), ' ] value.', String lf,
		'GsFile gciLogServer: ''ZINC_FULL_GT_CLIENT_PASS''.', String lf,
		'GsFile gciLogServer: ''ZINC_FULL_GT_HTTP_READY''.', String lf,
		'(Delay forSeconds: 45) wait ] ensure: [ [ ', GtGemStoneZincRuntimeCompatibility stopValidationServerSource, ' ] value ].', String lf, 'true'.
	output := (output allButLast: marker size), 'expectvalue true', String lf, 'run', String lf, validation, String lf, '%', String lf, marker.
	aFile asFileReference binaryWriteStreamDo: [ :stream | stream position: 0; truncate; nextPutAll: output utf8Encoded ].
	^ aFile asFileReference fullName
]

{ #category : #generation }
GtGemStoneZincStructuralValidation >> writeSoloDriverTo: aFile reloadFiles: reloadFiles [
	| root directory prototype gtFiles files |
	root := FileLocator imageDirectory asFileReference.
	directory := self writeArtifactsTo: aFile asFileReference parent.
	prototype := directory parent / 'native-prototype'.
	GtGemStoneZincSoloHarness writeContextScriptsTo: directory.
	gtFiles := #('gt4gemstone/src-gs/Announcements.gs' 'gt4gemstone/src-gs/RemoteServiceReplication.gs' 'gt4gemstone/src-gs/STON.gs' 'gt4gemstone/src-gs/patch-gemstone.gs' 'gtoolkit-wireencoding/src-gs/gtoolkit-wireencoding.gs' 'gt4gemstone/src-gs/gt4gemstone.gs' 'gtoolkit-remote/src-gs/gtoolkit-remote.gs') collect: [ :relative | (root / relative) fullName ].
	files := OrderedCollection with: (directory / 'pristine-stream-capture.topaz') fullName.
	files addAll: gtFiles; add: (directory / 'zinc-compile-context.topaz') fullName.
	#('dependencies-definitions.topaz' 'zinc-definitions.topaz' 'global-bindings.topaz' 'dependencies-methods.topaz' 'zinc-methods.topaz' 'runtime-compatibility.topaz' 'initialization.topaz') do: [ :name | files add: (prototype / name) fullName ].
	files add: (directory / 'restore-compile-context.topaz') fullName;
		add: (directory / 'sport-independence-validation.topaz') fullName; add: (directory / 'native-socket-fault-validation.topaz') fullName; add: (directory / 'exception-identity-validation.topaz') fullName; add: (directory / 'legacy-parser-validation.topaz') fullName; add: (directory / 'legacy-http-validation.topaz') fullName; add: (directory / 'native-reset-validation.topaz') fullName; add: (directory / 'percent-codec-validation.topaz') fullName; add: (directory / 'legacy-write-http-validation.topaz') fullName; add: (directory / 'native-socket-validation.topaz') fullName; add: (directory / 'structural-validation.topaz') fullName;
		add: (directory / 'eager-constants-validation.topaz') fullName;
		add: (directory / 'session-logging-validation.topaz') fullName;
		add: (directory / 'unicode-query-validation.topaz') fullName;
		add: (directory / 'shared-adapter-behavior.topaz') fullName;
		add: (directory / 'core-validation.topaz') fullName;
		add: (directory / 'static-validation.topaz') fullName;
		add: (directory / 'persistent-state-validation.topaz') fullName.
	reloadFiles notEmpty ifTrue: [ files addAll: reloadFiles;
		add: (directory / 'sport-independence-validation.topaz') fullName; add: (directory / 'native-socket-fault-validation.topaz') fullName; add: (directory / 'exception-identity-validation.topaz') fullName; add: (directory / 'legacy-parser-validation.topaz') fullName; add: (directory / 'legacy-http-validation.topaz') fullName; add: (directory / 'native-reset-validation.topaz') fullName; add: (directory / 'percent-codec-validation.topaz') fullName; add: (directory / 'legacy-write-http-validation.topaz') fullName; add: (directory / 'native-socket-validation.topaz') fullName; add: (directory / 'post-reload-validation.topaz') fullName;
		add: (directory / 'eager-constants-validation.topaz') fullName;
		add: (directory / 'session-logging-validation.topaz') fullName;
		add: (directory / 'unicode-query-validation.topaz') fullName;
		add: (directory / 'shared-adapter-behavior.topaz') fullName;
		add: (directory / 'core-validation.topaz') fullName;
		add: (directory / 'static-validation.topaz') fullName;
		add: (directory / 'persistent-state-validation.topaz') fullName ].
	^ GtGemStoneZincSoloHarness writeImportScriptTo: aFile files: files validation: 'GsFile gciLogServer: ''ZINC_STRUCTURE_DRIVER_PASS''. true'
]

{ #category : #generating }
GtGemStoneZincStructuralValidation >> writeSoloDriverTo: aFile reloadGt: reloadGt [
	| root reloadFiles |
	root := FileLocator imageDirectory asFileReference.
	reloadFiles := reloadGt ifFalse: [ #() ] ifTrue: [ #('gt4gemstone/src-gs/Announcements.gs' 'gt4gemstone/src-gs/RemoteServiceReplication.gs' 'gt4gemstone/src-gs/STON.gs' 'gt4gemstone/src-gs/patch-gemstone.gs' 'gtoolkit-wireencoding/src-gs/gtoolkit-wireencoding.gs' 'gt4gemstone/src-gs/gt4gemstone.gs' 'gtoolkit-remote/src-gs/gtoolkit-remote.gs') collect: [ :relative | (root / relative) fullName ] ].
	^ self writeSoloDriverTo: aFile reloadFiles: reloadFiles
]
