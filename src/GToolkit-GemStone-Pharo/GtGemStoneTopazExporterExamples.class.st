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
