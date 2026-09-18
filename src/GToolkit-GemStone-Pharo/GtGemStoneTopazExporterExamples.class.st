"
I provide executable examples for the GemStone Topaz exporter.
"
Class {
	#name : #GtGemStoneTopazExporterExamples,
	#superclass : #Object,
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
GtGemStoneTopazExporterExamples >> exportStubClassesWithParentsWithoutMethods [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter output classes collectionPosition requestHistoryPosition |
	exporter := GtGemStoneTopazExporter new
		stubClasses: { GtLRequestHistory };
		excludedClasses: { Collection };
		yourself.
	classes := exporter classesToDefine.
	self assert: (classes includes: GtLRequestHistory).
	self assert: (classes includes: SequenceableCollection) not.
	self assert: (classes includes: OrderedCollection) not.
	self assert: (classes includes: Collection) not.
	self assert: (classes includes: Object) not.
	output := exporter asTopazString.
	requestHistoryPosition := output indexOfSubCollection: 'subclass: ''GtLRequestHistory'''.
	collectionPosition := output indexOfSubCollection: 'subclass: ''OrderedCollection'''.
	self assert: requestHistoryPosition > 0.
	self assert: collectionPosition equals: 0.
	self assert: (output includesSubstring: ') category: ''GToolkit-Stubs'';').
	self assert: (output includesSubstring: 'removeallmethods OrderedCollection') not.
	self assert: (output includesSubstring: 'method: OrderedCollection') not.
	^ exporter
]

{ #category : #examples }
GtGemStoneTopazExporterExamples >> exportStubClassesWithoutParentsWithoutMethods [
	<gtExample>
	<return: #GtGemStoneTopazExporter>
	| exporter output classes |
	exporter := GtGemStoneTopazExporter new
		stubClassesWithoutParents: { OrderedCollection };
		yourself.
	classes := exporter classesToDefine.
	self assert: classes size equals: 1.
	self assert: classes first equals: OrderedCollection.
	self assert: (classes includes: SequenceableCollection) not.
	output := exporter asTopazString.
	self assert: (output includesSubstring: 'subclass: ''OrderedCollection''').
	self assert: (output includesSubstring: 'subclass: ''SequenceableCollection''') not.
	self assert: (output includesSubstring: ') category: ''GToolkit-Stubs'';').
	self assert: (output includesSubstring: 'removeallmethods OrderedCollection') not.
	self assert: (output includesSubstring: 'method: OrderedCollection') not.
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
