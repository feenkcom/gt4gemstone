Class {
	#name : #GtGemStoneZincNativeExporterExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-ZincExport'
}

{ #category : #examples }
GtGemStoneZincNativeExporterExamples >> acceptNativeSourceWithHistoricalComment [
	<gtExample>
	| exporter source |
	exporter := GtGemStoneZincNativeExporter basicNew.
	source := 'm "SpSocket historical attribution" ^ GsSocket new'.
	self assert: (exporter validateSportFreeGeneratedSource: source) = source.
	self assert: (exporter historicalSportOwnedClassNames includes: 'SpPortabilityTools').
	^ exporter
]

{ #category : #examples }
GtGemStoneZincNativeExporterExamples >> frozenCompanionRegeneration [
	<gtExample>
	| root source first second rejected manifest native oldInit exporter names failed |
	root := FileLocator temp / ('zinc-companion-example-', UUID new asString).
	source := root / 'source'. first := root / 'first'. second := root / 'second'. rejected := root / 'rejected'.
	source ensureCreateDirectory.
	native := 'native artifact preserved' utf8Encoded.
	oldInit := 'old initialization' utf8Encoded.
	(source / 'dependencies-methods.topaz') binaryWriteStreamDo:[:stream | stream truncate; nextPutAll: native].
	(source / 'initialization.topaz') binaryWriteStreamDo:[:stream | stream truncate; nextPutAll: oldInit].
	manifest := OrderedDictionary new
		at: 'schema' put: 1; at: 'targetDictionary' put: 'ZincGlobals'; at: 'selection' put: #();
		at: 'sourceIdentities' put: #(#('frozen identity')); at: 'sourcePackageVersions' put: #(#('frozen version'));
		at: 'artifactSHA256' put: (OrderedDictionary new
			at: 'dependencies-methods.topaz' put: (SHA256 hashMessage: native) hex;
			at: 'initialization.topaz' put: (SHA256 hashMessage: oldInit) hex; yourself); yourself.
	(source / 'manifest.json') binaryWriteStreamDo:[:stream | stream truncate; nextPutAll: (NeoJSONWriter toStringPretty: manifest) utf8Encoded].
	exporter := GtGemStoneZincNativeExporter new.
	names := exporter regenerateCompanionsFrom: source / 'manifest.json' to: first.
	exporter regenerateCompanionsFrom: source / 'manifest.json' to: second.
	names do:[:name | self assert: (first / name) binaryContents = (second / name) binaryContents].
	self assert: (first / 'dependencies-methods.topaz') binaryContents = native.
	self assert: ((STONJSON fromString: (first / 'manifest.json') contents) at: 'sourceIdentities') = (manifest at: 'sourceIdentities').
	(source / 'dependencies-methods.topaz') binaryWriteStreamDo:[:stream | stream truncate; nextPutAll: 'tampered' utf8Encoded].
	failed := false.
	[exporter regenerateCompanionsFrom: source / 'manifest.json' to: rejected] on: AssertionFailure do:[:error | failed := true].
	self assert: failed.
	self assert: rejected exists not.
	^ names
]

{ #category : #examples }
GtGemStoneZincNativeExporterExamples >> nativeDictionaryIdentityAndDeterminism [
	<gtExample>
	<noTest>
	"Requires the captured upstream reference database connected in the default session."
	| exporter first second symbolListBefore symbolListAfter definition manifest |
	symbolListBefore := GtGemStoneSessionRegistry defaultSession
		evaluateBlockAndWait: [ System myUserProfile symbolList collect: [ :each | each asOop ] ]
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false.
	exporter := GtGemStoneZincNativeExporter new.
	exporter targetDictionary: 'UserGlobals'.
	exporter selection: { { 'zinc'. 'UserGlobals'. 'ZnBase64Encoder'. true. #('initialize' 'encode:'). #('initialize') } }.
	first := exporter artifacts.
	exporter selection: { { 'zinc'. 'UserGlobals'. 'ZnBase64Encoder'. true. #('encode:' 'initialize'). #('initialize') } }.
	second := exporter artifacts.
	self assert: first = second.
	definition := first at: 'zinc-definitions.topaz'.
	self assert: (definition includesSubstring: 'inDictionary: UserGlobals').
	self assert: (definition includesSubstring: 'instVarNames: #( alphabet') .
	self assert: ((first at: 'zinc-methods.topaz') includesSubstring: 'category: ').
	self assert: ((first at: 'zinc-methods.topaz') includesSubstring: 'classmethod: ZnBase64Encoder').
	self assert: ((first at: 'zinc-methods.topaz') includesSubstring: 'removeSelector:') not.
	manifest := STONJSON fromString: (first at: 'manifest.json').
	self assert: ((manifest at: 'sourceIdentities') first at: 2) = 'UserGlobals'.
	self assert: ((manifest at: 'artifactSHA256') at: 'zinc-definitions.topaz')
		equals: (SHA256 hashMessage: definition utf8Encoded) hex.
	symbolListAfter := GtGemStoneSessionRegistry defaultSession
		evaluateBlockAndWait: [ System myUserProfile symbolList collect: [ :each | each asOop ] ]
		serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false.
	self assert: symbolListBefore = symbolListAfter.
	^ manifest at: 'artifactSHA256'
]

{ #category : #examples }
GtGemStoneZincNativeExporterExamples >> plainExtentDefinitionKeywords [
	<gtExample>
	| exporter source normalized |
	exporter := GtGemStoneZincNativeExporter basicNew.
	exporter targetDictionary: 'ZincGlobals'.
	source := 'Object subclass: ''Example''' , String lf ,
		String tab , 'poolDictionaries: {ExampleConstants _classVars}' , String lf ,
		String tab , 'inDictionary: Globals' , String lf ,
		String tab , 'category: ''Example-Runtime''' , String lf ,
		String tab , 'options: #( #modifiable )' , String lf.
	normalized := exporter normalizedDefinition: source.
	self assert: (normalized findString: 'category:') < (normalized findString: 'inDictionary:').
	self assert: (normalized includesSubstring: 'inDictionary: ZincGlobals').
	self assert: (normalized includesSubstring: 'poolDictionaries: {ExampleConstants _classVars}').
	self assert: (normalized includesSubstring: 'options: #( #modifiable )').
	^ normalized
]

{ #category : #examples }
GtGemStoneZincNativeExporterExamples >> poolOwnersBeforeConsumers [
	<gtExample>
	| exporter records ordered |
	exporter := GtGemStoneZincNativeExporter basicNew.
	records := {
		{ 'dependencies'. 'UserGlobals'. 'ZipArchive'. 1. 2. 'definition'. ''. #('ZipFileConstants'). 'Object' }.
		{ 'dependencies'. 'UserGlobals'. 'ZipFileConstants'. 2. 2. 'definition'. ''. #(). 'SharedPool' }.
		{ 'dependencies'. 'UserGlobals'. 'SharedPool'. 3. 1. 'definition'. ''. #(). 'Object' } }.
	ordered := exporter definitionRecordsInLoadOrder: records.
	self assert: (ordered collect: [ :record | record at: 3 ]) asArray
		equals: #('SharedPool' 'ZipFileConstants' 'ZipArchive').
	^ ordered
]

{ #category : #examples }
GtGemStoneZincNativeExporterExamples >> preserveFrozenCompanionAudit [
	<gtExample>
	| exporter archived audit generated reordered first second legacy decoded native |
	exporter := GtGemStoneZincNativeExporter new.
	audit := OrderedDictionary new
		at: 'nativeArtifacts' put: 'verified unchanged'; at: 'regeneratedArtifacts' put: #('initialization.topaz');
		at: 'operation' put: 'regenerateCompanionsFrom:to:'; at: 'generator' put: 'GtGemStoneZincNativeExporter'; yourself.
	archived := Dictionary new at: 'companionRegeneration' put: audit; yourself.
	generated := OrderedDictionary new
		at: 'schema' put: 1; at: 'selection' put: #();
		at: 'artifactSHA256' put: (OrderedDictionary new at: 'z.topaz' put: 'z'; at: 'a.topaz' put: 'a'; yourself); yourself.
	reordered := OrderedDictionary new
		at: 'artifactSHA256' put: (OrderedDictionary new at: 'a.topaz' put: 'a'; at: 'z.topaz' put: 'z'; yourself);
		at: 'selection' put: #(); at: 'schema' put: 1; yourself.
	native := 'native unchanged'.
	first := OrderedDictionary new at: 'native.topaz' put: native; at: 'manifest.json' put: (NeoJSONWriter toStringPretty: generated); yourself.
	second := OrderedDictionary new at: 'native.topaz' put: native; at: 'manifest.json' put: (NeoJSONWriter toStringPretty: reordered); yourself.
	exporter preserveCompanionMetadataFrom: archived in: first.
	exporter preserveCompanionMetadataFrom: archived in: second.
	self assert: (first at: 'manifest.json') = (second at: 'manifest.json') description: 'Canonical bytes'.
	self assert: (first at: 'native.topaz') = native description: 'Native bytes'.
	decoded := STONJSON fromString: (first at: 'manifest.json').
	audit keysAndValuesDo: [ :key :value | self assert: ((decoded at: 'companionRegeneration') at: key) = value description: key ].
	self assert: (decoded at: 'selection') = #().
	legacy := OrderedDictionary new at: 'manifest.json' put: 'legacy exact bytes'; yourself.
	exporter preserveCompanionMetadataFrom: Dictionary new in: legacy.
	self assert: (legacy at: 'manifest.json') = 'legacy exact bytes'.
	^ decoded
]

{ #category : #examples }
GtGemStoneZincNativeExporterExamples >> rejectAmbiguousTargetIdentity [
	<gtExample>
	| exporter rejected |
	exporter := GtGemStoneZincNativeExporter basicNew.
	exporter selection: {
		{ 'dependencies'. 'Globals'. 'SharedName'. true. #(). #() }.
		{ 'zinc'. 'UserGlobals'. 'SharedName'. true. #(). #() } }.
	rejected := false.
	[ exporter validateSelection ] on: AssertionFailure do: [ :error | rejected := true ].
	self assert: rejected.
	^ rejected
]

{ #category : #examples }
GtGemStoneZincNativeExporterExamples >> rejectSportCompanionSelection [
	<gtExample>
	| exporter rejected fixture manifestFile output selection |
	exporter := GtGemStoneZincNativeExporter basicNew.
	selection := { { 'dependencies'. 'UserGlobals'. 'SpPortabilityTools'. true. #(). #() } }.
	fixture := FileLocator temp / ('sport-companion-selection-', UUID new asString).
	fixture ensureCreateDirectory.
	manifestFile := fixture / 'manifest.json'.
	manifestFile writeStreamDo: [ :stream |
		stream nextPutAll: (NeoJSONWriter toString: (Dictionary new
			at: 'schema' put: 1;
			at: 'targetDictionary' put: 'ZincGlobals';
			at: 'selection' put: selection;
			yourself)) ].
	output := fixture / 'must-not-be-written'.
	self assert: output exists not.
	rejected := false.
	[ exporter regenerateCompanionsFrom: manifestFile to: output ] on: Error do: [ :error |
		self assert: (error messageText beginsWith: 'Sport-bearing frozen exports').
		rejected := true ].
	self assert: rejected.
	self assert: output exists not.
	exporter selection: { { 'dependencies'. 'Globals'. 'Object'. false. #(). #() } }.
	self assert: exporter validateFrozenSportFreeSelection size = 1.
	exporter selection: #().
	self assert: exporter validateFrozenSportFreeSelection isEmpty.
	^ exporter
]

{ #category : #examples }
GtGemStoneZincNativeExporterExamples >> rejectSportGeneratedExecutableSource [
 <gtExample>
 | exporter safe unsafe |
 exporter := GtGemStoneZincNativeExporter new.
 safe := 'probe "SpSocket historical comment" ^ GsSocket new'.
 self assert: (exporter validateSportFreeGeneratedSource: safe) equals: safe.
 unsafe := #('probe ^ SpSocket new' 'probe ^ #SpSocketError' 'probe ^ #(SpPortabilityTools)' 'probe ^ Smalltalk at: #SpIPAddress' 'probe ^ ''SpSocket''').
 unsafe do: [:source |
   | rejected | rejected := false. [exporter validateSportFreeGeneratedSource: source] on: Error do: [:error | rejected := true]. self assert: rejected].
 self assert: exporter historicalSportOwnedClassNames size equals: 21.
 self assert: (exporter historicalSportOwnedClassNames includes: 'SpPortabilityTools').
 ^ exporter
]

{ #category : #examples }
GtGemStoneZincNativeExporterExamples >> rejectSportInGeneratedSource [
	<gtExample>
	| exporter rejected |
	exporter := GtGemStoneZincNativeExporter basicNew.
	#('m ^ SpSocket new' 'm ^ #SpSocketError' 'm ^ ''"'', SpSocket name') do: [ :source |
		rejected := false.
		[ exporter validateSportFreeGeneratedSource: source ] on: Error do: [ :error |
			self assert: (error messageText beginsWith: 'Sport dependency').
			rejected := true ].
		self assert: rejected ].
	^ exporter
]
