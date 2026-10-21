"
I provide executable examples for the GemStone Topaz exporter.
"
Class {
	#name : #GtGemStoneTopazExporterExamples,
	#superclass : #Object,
	#instVars : [
		'packageNames',
		'additionalClasses',
		'stubClasses',
		'stubClassesWithoutParents',
		'excludedClasses',
		'excludedMethods',
		'includeGsCodeMethods',
		'gsCodeClasses'
	],
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #initialization }
GtGemStoneTopazExporterExamples class >> initialize [
	^ self
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> cacheSelectedClassesAndInvalidateOnConfigurationChanges [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter classes |
	exporter := GtGemStoneTopazExporter new.
	classes := exporter selectedClasses.
	self assert: classes isEmpty.
	self assert: exporter selectedClasses == classes.
	exporter packages: { 'GToolkit-GemStone-Pharo' }.
	classes := exporter selectedClasses.
	self assert: (classes includes: GtGemStoneTopazExporter).
	self assert: exporter selectedClasses == classes.
	exporter packageNames: #().
	classes := exporter selectedClasses.
	self assert: classes isEmpty.
	exporter additionalClasses: { Collection }.
	classes := exporter selectedClasses.
	self assert: classes asArray equals: { Collection }.
	self assert: exporter selectedClasses == classes.
	exporter excludedClasses: { Collection }.
	classes := exporter selectedClasses.
	self assert: classes isEmpty.
	self assert: exporter selectedClasses == classes.
	exporter excludedClasses: #().
	self assert: exporter selectedClasses asArray equals: { Collection }.
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportAlternateClassDefinition [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter original definition output |
	exporter := GtGemStoneTopazExporter new
		additionalClasses: { ZnDefaultCharacterEncoder };
		yourself.
	original := exporter asTopazString.
	definition := 'GtGsDynamicVariable subclass: ''ZnDefaultCharacterEncoder''
  instVarNames: #()
  classVars: #()
  classInstVars: #()
  poolDictionaries: #()
  inDictionary: Globals
  options: #()
'.
	exporter alternateClassDefinitions: { 'ZnDefaultCharacterEncoder' -> definition } asDictionary.
	output := exporter asTopazString.
	self assert: output withUnixLineEndings equals: (original copyReplaceAll: 'DynamicVariable subclass:' with: 'GtGsDynamicVariable subclass:') withUnixLineEndings.
	self assert: ZnDefaultCharacterEncoder superclass equals: DynamicVariable.
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportClassInitializationsAtEnd [
	"Check the class initialisation code.
	Disabled for now while class initialisation is disabled."
	<gtExample>
	<noTest>
	<return: #GtGemStoneTopazExporter>
	| exporter output expectedSuffix |
	exporter := GtGemStoneTopazExporter new
		additionalClasses: { GtGemStoneTopazExporter. GtGemStoneTopazExporterExamples };
		yourself.
	output := exporter asTopazString.
	expectedSuffix := 'run', String lf,
		'GtGemStoneTopazExporterExamples initialize.', String lf,
		'true', String lf,
		'%', String lf.
	self assert: (output endsWith: expectedSuffix).
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportExcludingMethods [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter output |
	exporter := GtGemStoneTopazExporter new
		additionalClasses: { GtGemStoneTopazExporter };
		excludedMethods: {
			GtGemStoneTopazExporter >> #topazQuoted:.
			GtGemStoneTopazExporter class >> #packages:additionalClasses:excluding: };
		yourself.
	output := exporter asTopazString.
	self assert: (output includesSubstring: 'method: GtGemStoneTopazExporter', String lf, 'initialize').
	self assert: (output includesSubstring: 'method: GtGemStoneTopazExporter', String lf, 'topazQuoted:') not.
	self assert: (output includesSubstring: 'classmethod: GtGemStoneTopazExporter', String lf, 'packages: packageNames additionalClasses: additionalClasses excluding: excludedClasses') not.
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportExcludingTraitOriginMethod [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter output |
	exporter := GtGemStoneTopazExporter new
		additionalClasses: { GtGemStoneTopazExporterTraitedFixture };
		excludedMethods: { TGtGemStoneTopazExporterFixture >> #traitGreeting };
		yourself.
	output := exporter asTopazString.
	self assert: (output includesSubstring: 'method: GtGemStoneTopazExporterTraitedFixture', String lf, 'traitGreeting') not.
	self assert: (output includesSubstring: 'method: GtGemStoneTopazExporterTraitedFixture', String lf, 'localGreeting').
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportFlattenedTrait [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter output |
	exporter := GtGemStoneTopazExporter new
		additionalClasses: { GtGemStoneTopazExporterTraitedFixture. TGtGemStoneTopazExporterFixture. };
		yourself.
	output := exporter asTopazString.
	self assert: (exporter selectedClasses includes: GtGemStoneTopazExporterTraitedFixture).
	self assert: (exporter selectedClasses includes: TGtGemStoneTopazExporterFixture) not.
	self assert: (output includesSubstring: 'method: GtGemStoneTopazExporterTraitedFixture', String lf, 'traitGreeting').
	self assert: (output includesSubstring: 'TGtGemStoneTopazExporterFixture') not.
	self assert: (output includesSubstring: 'instVarNames: #( localValue traitValue)').
	self assert: (output includesSubstring: 'classInstVars: #( localClassValue traitClassSlot)').
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportGsCodeMethod [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter output gsSource pharoSource |
	exporter := GtGemStoneTopazExporter new
		includeGsCodeMethods: true;
		gsCodeClasses: { GtGemStoneTopazExporterExamples };
		additionalClasses: { GtGemStoneTopazExporterExamples };
		yourself.
	output := exporter asTopazString withUnixLineEndings.
	gsSource := 'method: GtGemStoneTopazExporterExamples
', 'gsCodeExampleMethod
	"Provide an example method with the gsCode: pragma"
	^ self copyFrom: 1 to: 3'.
	pharoSource := 'method: GtGemStoneTopazExporterExamples
', 'gsCodeExampleMethod
	"Provide an example method with the gsCode: pragma"
	<gsCode: ''^ self copyFrom: 1 to: 3''>
	^ self first: 3'.
	self assert: (output includesSubstring: gsSource withUnixLineEndings).
	self assert: (output includesSubstring: pharoSource withUnixLineEndings) not.
	^ exporter
]

{ #category : #Examples }
GtGemStoneTopazExporterExamples >> exportGsCodeMethodBySearchingAllClasses [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter output |
	exporter := GtGemStoneTopazExporter new
		includeGsCodeMethods: true;
		additionalClasses: { GtGemStoneTopazExporterExamples };
		yourself.
	output := exporter asTopazString.
	self assert: (output includesSubstring: 'method: GtGemStoneTopazExporterExamples', String lf, 'exportGsCodeMethod').
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportNewMethods [
	<gtExample>
	| exporter output script |
	exporter := GtGemStoneTopazExporter new
		newMethodClassNames: #('GtGemStoneTopazExporter' 'GtGemStoneTopazExporter');
		yourself.
	self assert: exporter newMethodClasses asArray equals: { GtGemStoneTopazExporter }.
	output := exporter asTopazString.
	self assert: (output includesSubstring: 'className: #''GtGemStoneTopazExporter'';').
	self assert: (output includesSubstring: 'meta: true;').
	self assert: (output includesSubstring: 'selector: #new;').
	self assert: (output includesSubstring: 'hash: #new;').
	self assert: (output includesSubstring: '<gtGsExtension>').
	self assert: (output includesSubstring: '^ self basicNew initialize').
	self assert: (output indexOfSubCollection: 'GtGemStoneExtensionMethod new')
		> (output indexOfSubCollection: 'GtGemStoneExtensionMethods apply.').
	script := String streamContents: [ :stream | exporter writeNewMethodsOn: stream ].
	self assert: (output endsWith: script).
	RBParser parseExpression: (script copyFrom: 5 to: (script lastIndexOf: $%) - 1).
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportPreservingInheritedNew [
	<gtExample>
	| exporter script |
	self assert: (NeoJSONObject classSide methodDict includesKey: #new) not.
	self assert: (NeoJSONObject classSide lookupSelector: #new) methodClass equals: OrderedDictionary classSide.
	exporter := GtGemStoneTopazExporter new
		newMethodClassNames: #('NeoJSONObject' 'GtGemStoneTopazExporter');
		yourself.
	self assert: exporter newMethodClasses asArray equals: { GtGemStoneTopazExporter }.
	script := String streamContents: [ :stream | exporter writeNewMethodsOn: stream ].
	self assert: (script includesSubstring: 'className: #''NeoJSONObject'';') not.
	self assert: (script includesSubstring: 'className: #''GtGemStoneTopazExporter'';').
	exporter newMethodPackageNames: #('Neo-JSON-Core'); newMethodClassNames: #().
	self assert: (exporter newMethodClasses includes: NeoJSONObject) not.
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportRbAliasStubDefinitionsOnlyWhenAbsent [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter aliases output |
	exporter := GtGemStoneTopazExporter new
		stubClasses: { OCProgramNode };
		yourself.
	aliases := exporter class environment associations select: [ :each |
		(each key beginsWith: 'RB') and: [ each value == OCProgramNode
			and: [ (exporter gemstoneClassNames includes: each key) not ] ] ].
	self assert: aliases notEmpty.
	output := String streamContents: [ :stream | exporter writeRbAliasStubsOn: stream ].
	aliases do: [ :each |
		self assert: (output includesSubstring:
			'(System myUserProfile symbolList resolveSymbol: #', each key, ') isNil ifTrue: [') ].
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportSelectedClassOverStubAncestor [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter packageExporter output |
	exporter := GtGemStoneTopazExporter new
		additionalClasses: { OrderedDictionary };
		stubClasses: { ZnMultiValueDictionary };
		yourself.
	self assert: (exporter stubClasses includes: OrderedDictionary).
	output := exporter asTopazString.
	self assert: (output includesSubstring: 'Collection subclass: ''OrderedDictionary''').
	self assert: (output includesSubstring: ') category: ''Collections-Sequenceable'';').
	self assert: (output includesSubstring: 'OrderedDictionary subclass: ''ZnMultiValueDictionary''').
	self assert: (output includesSubstring: 'method: OrderedDictionary').
	self assert: (output includesSubstring: 'method: ZnMultiValueDictionary') not.
	packageExporter := GtGemStoneTopazExporter new
		packages: { OrderedDictionary package name };
		stubClasses: { ZnMultiValueDictionary };
		yourself.
	output := String streamContents: [ :stream |
		packageExporter writeDefinitionOf: OrderedDictionary on: stream ].
	self assert: (output includesSubstring: 'Collection subclass: ''OrderedDictionary''').
	self assert: (output includesSubstring: ') category: ''Collections-Sequenceable'';').
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportStubClassesWithoutMethods [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter output classes |
	exporter := GtGemStoneTopazExporter new
		stubClasses: { GtLReplyMessage };
		yourself.
	classes := exporter classesToDefine.
	self assert: classes size equals: 3.
	self assert: (classes includesAll: { GtLBasicMessage. GtLChatMessage. GtLReplyMessage }).
	self assert: (classes includes: GtLBasicMessage superclass) not.
	output := exporter asTopazString.
	self assert: (output includesSubstring: 'Object subclass: ''GtLBasicMessage''').
	self assert: (output includesSubstring: 'GtLBasicMessage subclass: ''GtLChatMessage''').
	self assert: (output includesSubstring: 'GtLChatMessage subclass: ''GtLReplyMessage''').
	self assert: (output includesSubstring: ') category: ''GToolkit-Stubs'';').
	classes do: [ :each |
		self assert: (output includesSubstring: 'removeallmethods ', each name) not.
		self assert: (output includesSubstring: 'method: ', each name) not ].
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportStubDefinitionsOnlyWhenAbsent [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter output selectedOutput |
	exporter := self exportStubClassesWithoutMethods.
	output := exporter asTopazString.
	exporter classesToDefine do: [ :each |
		self assert: (output includesSubstring:
			'(System myUserProfile symbolList resolveSymbol: #', each name, ') isNil ifTrue: [') ].
	exporter alternateClassDefinitions:
		{ 'GtLReplyMessage' -> 'Object subclass: ''GtLReplyMessage'' instVarNames: #() classVars: #() classInstVars: #() poolDictionaries: #() inDictionary: Globals options: #()' } asDictionary.
	output := String streamContents: [ :stream |
		exporter writeDefinitionOf: GtLReplyMessage on: stream ].
	self assert: (output includesSubstring: 'resolveSymbol: #GtLReplyMessage) isNil ifTrue: [').
	exporter := self exportSelectedClassOverStubAncestor.
	selectedOutput := String streamContents: [ :stream |
		exporter writeDefinitionOf: OrderedDictionary on: stream ].
	self assert: (selectedOutput includesSubstring: 'resolveSymbol:') not.
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportSuperclassBeforeSubclass [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter output replyPosition basicPosition firstMethodPosition lastDefinitionPosition |
	exporter := GtGemStoneTopazExporter new
		additionalClasses: { GtLReplyMessage. GtLBasicMessage. GtLChatMessage. };
		yourself.
	output := exporter asTopazString.
	replyPosition := output indexOfSubCollection: 'subclass: ''GtLReplyMessage'''.
	basicPosition := output indexOfSubCollection: 'subclass: ''GtLBasicMessage'''.
	firstMethodPosition := output indexOfSubCollection: 'method: GtLBasicMessage'.
	lastDefinitionPosition := output indexOfSubCollection: 'subclass: ''GtLReplyMessage''' startingAt: replyPosition.
	self assert: replyPosition > 0.
	self assert: replyPosition > basicPosition.
	self assert: lastDefinitionPosition < firstMethodPosition.
	self assert: (output includesSubstring: 'removeallmethods GtLReplyMessage').
	self assert: (output includesSubstring: 'removeallclassmethods GtLReplyMessage').
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportUnusedAlternateClassDefinition [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter original definitions |
	exporter := GtGemStoneTopazExporter new
		additionalClasses: { ZnDefaultCharacterEncoder };
		yourself.
	original := exporter asTopazString.
	definitions := { ZnUrl -> 'Object subclass: ''ZnUrl''' } asDictionary.
	exporter alternateClassDefinitions: definitions.
	definitions at: ZnUrl put: 'Changed caller dictionary'.
	self assert: (exporter alternateClassDefinitions at: #ZnUrl) equals: 'Object subclass: ''ZnUrl'''.
	self assert: exporter asTopazString equals: original.
	exporter alternateClassDefinitions: Dictionary new.
	self assert: exporter asTopazString equals: original.
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportWithoutNewMethodsByDefault [
	<gtExample>
	| exporter output |
	exporter := GtGemStoneTopazExporter new.
	self assert: exporter newMethodPackageNames isEmpty.
	self assert: exporter newMethodClassNames isEmpty.
	output := exporter asTopazString.
	self assert: (output includesSubstring: 'GtGemStoneExtensionMethod new') not.
	self assert: (output includesSubstring: 'GtGemStoneExtensionMethods apply.').
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> gemstoneSourceForGsCodeMethod [
	<gtExample>
	<return: #String>
	| method source expected |
	method := self class >> #gsCodeExampleMethod.
	source := GtGemStoneTopazExporter gemstoneSourceFor: method.
	expected := 'gsCodeExampleMethod
	"Provide an example method with the gsCode: pragma"
	^ self copyFrom: 1 to: 3'.
	self
		assert: source withUnixLineEndings
		equals: expected withUnixLineEndings.
	^ source
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> gemstoneSourceForNilGsCodeMethod [
	<gtExample>
	<return: #String>
	| method source |
	method := self class >> #gsCodeNilExampleMethod.
	source := GtGemStoneTopazExporter gemstoneSourceFor: method.
	self assert: source equals: method sourceCode.
	^ source
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> gemstoneSourceForSourceWithGsCode [
	<gtExample>
	<return: #String>
	| source gemstoneSource expected |
	source := 'example
	<gsCode: ''example ^ 42''>
	^ 1'.
	gemstoneSource := GtGemStoneTopazExporter gemstoneSourceForSource: source.
	expected := 'example
	example ^ 42'.
	self assert: gemstoneSource equals: expected.
	^ gemstoneSource
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> gemstoneSourceForSourceWithNilGsCode [
	<gtExample>
	<return: #String>
	| source gemstoneSource |
	source := 'example
	<gsCode: nil>
	^ 1'.
	gemstoneSource := GtGemStoneTopazExporter gemstoneSourceForSource: source.
	self assert: gemstoneSource equals: source.
	^ gemstoneSource
]

{ #category : #Examples }
GtGemStoneTopazExporterExamples >> gsCodeExampleMethod [
	"Provide an example method with the gsCode: pragma"
	<gsCode: '^ self copyFrom: 1 to: 3'>
	^ self first: 3
]

{ #category : #'examples - support' }
GtGemStoneTopazExporterExamples >> gsCodeNilExampleMethod [
	"Use gsCode: as an export flag while retaining this source"
	<gsCode: nil>
	^ self first: 3
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> refreshSelectedClassesForEachExport [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter classes output |
	exporter := GtGemStoneTopazExporter new
		additionalClasses: { GtLBasicMessage };
		yourself.
	classes := exporter selectedClasses.
	output := exporter asTopazString.
	self assert: (output includesSubstring: 'subclass: ''GtLBasicMessage''').
	self assert: exporter selectedClasses ~~ classes.
	classes := exporter selectedClasses.
	self assert: exporter selectedClasses == classes.
	self assert: exporter asTopazString equals: output.
	self assert: exporter selectedClasses ~~ classes.
	self assert: exporter selectedClasses asArray equals: classes asArray.
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> rejectInvalidAlternateClassDefinitions [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter |
	exporter := GtGemStoneTopazExporter new.
	self assert: exporter alternateClassDefinitions isEmpty.
	{ ZnUrl -> ''. ZnUrl -> '  '. ZnUrl -> 42. #GtNonexistentAlternateDefinitionClass -> 'Object subclass: ''Missing''' }
		do: [ :association |
			self assert: ([ exporter alternateClassDefinitions: { association } asDictionary. false ]
				on: Error do: [ :error | true ]) ].
	self assert: exporter alternateClassDefinitions isEmpty.
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> selectNewMethodPackagesAndClasses [
	<gtExample>
	| exporter expected excluded explicitNewClass |
	excluded := GtGemStoneTopazExporterExamples.
	explicitNewClass := Smalltalk globals allClasses detect: [ :each | each classSide methodDict includesKey: #new ].
	exporter := GtGemStoneTopazExporter new
		newMethodPackageNames: { GtGemStoneTopazExporter package name };
		newMethodClassNames: { 'GtGemStoneTopazExporter'. explicitNewClass name };
		excludedClasses: { excluded };
		yourself.
	expected := GtGemStoneTopazExporter package definedClasses reject: [ :each |
		each isTrait
			or: [ each == excluded
			or: [ each superclass == PackageManifest
			or: [ (each classSide methodDict includesKey: #new)
			or: [ (each classSide lookupSelector: #new) methodClass ~= Behavior ] ] ] ] ].
	self assert: exporter newMethodClasses asSet equals: expected asSet.
	self assert: (exporter newMethodClasses includes: explicitNewClass) not.
	self assert: (exporter newMethodClasses includes: excluded) not.
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> selectPackageWithInclusionAndExclusion [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter classes |
	exporter := GtGemStoneTopazExporter new
		packageNames: { 'GToolkit-GemStone-Pharo' };
		additionalClasses: { Collection };
		excludedClasses: { GtGemStoneTopazExporterExamples };
		yourself.
	classes := exporter selectedClasses.
	self assert: (classes includes: GtGemStoneTopazExporter).
	self assert: (classes includes: Collection).
	self assert: (classes includes: GtGemStoneTopazExporterExamples) not.
	^ exporter
]
