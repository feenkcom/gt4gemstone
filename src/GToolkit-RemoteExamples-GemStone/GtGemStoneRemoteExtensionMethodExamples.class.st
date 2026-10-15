Class {
	#name : #GtGemStoneRemoteExtensionMethodExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone-Examples'
}

{ #category : #examples }
GtGemStoneRemoteExtensionMethodExamples >> createsDescriptorFromGemStoneSession [
	<gtExample>
	| extension method target |
	
	self runningServer gt4gemstoneVersion <= (GtGemStoneSemanticVersionNumber major: 1 minor: 1 patch: 630) ifTrue:
		[ (self runningServer evaluateBlockAndWaitReturnPrimitive:
			[ (GsSession currentSession objectNamed: #GtGemStoneExtensionMethod) isNil ]) ifTrue:
				[ ^ self ] ].
	extension := GtGemStoneExtensionMethod
		newFromClass: #GtGemStoneExtensionMethod selector: #source meta: false
		session: self runningServer.
	self assert: extension selector equals: #source.
	self assert: extension className equals: #GtGemStoneExtensionMethod.
	self assert: extension meta not.
	self assert: extension hash equals: #new.
	self assert: (extension source includesSubstring: '<gtGsExtension>').
	self assert: (GtGemStoneParser
		parse: extension source
		startingAt: GtGemStoneParser startingStateForMethod) pragmas size equals: 1.
	target := GtGemStoneExtensionMethodBehaviorFixture class.
	[
		method := extension compileExtensionIn: target.
		self assert: (target soleInstance perform: method selector) source equals: extension source
	] ensure: [ target removeSelector: extension extensionSelector ].
	^ extension
]

{ #category : #examples }
GtGemStoneRemoteExtensionMethodExamples >> createsDescriptorsFromLocalMethods [
	<gtExample>
	"noTest as this example assumes a default GemStone session"
	<noTest>
	| extension overwrite source ast |
	extension := GtGemStoneExtensionMethod
		newFromLocalClass: #GtGemStoneExtensionMethodBehaviorFixture
		selector: #initialize meta: false.
	self assert: extension hash equals: #new.
	ast := OCParser parseMethod: extension source.
	self assert: (ast pragmas select: [ :each | each selector = #gtGsExtension ]) size equals: 1.
	source := (GtGemStoneExtensionMethods class >> #ext_Object_assert_) sourceCode.
	overwrite := GtGemStoneExtensionMethod
		overwriteFromLocalClass: #GtGemStoneExtensionMethods
		selector: #ext_Object_assert_ meta: true.
	self assert: overwrite meta.
	self assert: overwrite hash equals: (overwrite sha256Of: source).
	self assert: (overwrite source includesSubstring: (source last: 40)).
	^ overwrite
]

{ #category : #examples }
GtGemStoneRemoteExtensionMethodExamples >> registryDelegatesOverwriteCompilation [
	<gtExample>
	"noTest as this example assumes a default GemStone session"
	<noTest>
	| method extension originalSource generatedSelector |
	originalSource := (GtGemStoneExtensionMethods class >> #extensionSelectors) sourceCode.
	generatedSelector := #ext_GtGemStoneExtensionMethods_class_extensionSelectors.
	[
		method := GtGemStoneExtensionMethods
			overwriteFromLocalClass: #GtGemStoneExtensionMethods
			selector: #extensionSelectors meta: true.
		self assert: method selector equals: generatedSelector.
		extension := GtGemStoneExtensionMethods perform: method selector.
		self assert: extension meta.
		self assert: extension hash equals: (extension sha256Of: originalSource)
	] ensure: [ GtGemStoneExtensionMethods class removeSelector: generatedSelector ].
	^ extension
]
