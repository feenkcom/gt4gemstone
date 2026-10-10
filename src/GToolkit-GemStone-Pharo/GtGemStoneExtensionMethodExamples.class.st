"
I provide executable examples for GT-managed GemStone extension method descriptors and their registry.
"
Class {
	#name : #GtGemStoneExtensionMethodExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> collectionIntersectionExtension [
	<gtExample>
	<return: #GtGemStoneExtensionMethod>
	| extension |
	extension := GtGemStoneExtensionMethods ext_Collection_intersection_.
	self assert: extension selector equals: #intersection:.
	self assert: extension protocol equals: #enumerating.
	self assert: extension className equals: #Collection.
	self assert: extension meta not.
	self assert: extension gtVersions isNil.
	self assert: extension hash equals: #new.
	self assert: (extension source includesSubstring: '<gtGsExtension>').
	^ extension
]

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> createsProtocolBeforeCompiling [
	<gtExample>
	<return: #GtGemStoneExtensionMethodBehaviorFixture>
	| extension behavior |
	extension := GtGemStoneExtensionMethod new protocol: #enumerating.
	behavior := GtGemStoneExtensionMethodBehaviorFixture new.
	extension ensureProtocolIn: behavior.
	extension ensureProtocolIn: behavior.
	self assert: behavior categories asArray equals: #(enumerating).
	^ behavior
]

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> discoversExtensionMethods [
	<gtExample>
	<return: #Array>
	| extensions |
	extensions := GtGemStoneExtensionMethods extensions.
	self assert: extensions size equals: GtGemStoneExtensionMethods extensionSelectors size.
	self assert: (extensions allSatisfy: [ :each | each isKindOf: GtGemStoneExtensionMethod ]).
	self assert: ((extensions collect: #className) asSet includesAll: #(Collection Set)).
	^ extensions
]

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> extensionAppliesToAllVersions [
	<gtExample>
	<return: #GtGemStoneExtensionMethod>
	| extension |
	extension := self collectionIntersectionExtension.
	self assert: extension appliesToCurrentVersion.
	^ extension
]

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> extensionSha256 [
	<gtExample>
	<return: #String>
	| digest |
	digest := GtGemStoneExtensionMethod new sha256Of: 'abc'.
	self assert: digest equals: 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad'.
	^ digest
]

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> extensionSha256WithLineEndings [
	<gtExample>
	<return: #String>
	| extension carriageReturn lineFeed expectedDigest inputs |
	extension := GtGemStoneExtensionMethod new.
	carriageReturn := Character cr asString.
	lineFeed := Character lf asString.
	expectedDigest := (SHA256 hashMessage: ('a', lineFeed, 'b', lineFeed, 'c') utf8Encoded) hex.
	inputs := {
		'a', lineFeed, 'b', lineFeed, 'c'.
		'a', carriageReturn, 'b', carriageReturn, 'c'.
		'a', carriageReturn, lineFeed, 'b', carriageReturn, lineFeed, 'c'.
		'a', carriageReturn, 'b', carriageReturn, lineFeed, 'c' }.
	inputs do: [ :each |
		self assert: (extension sha256Of: each) equals: expectedDigest ].
	^ expectedDigest
]

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> rejectsNonExtensionHashUpdate [
	<gtExample>
	| method rejected |
	method := GtGemStoneExtensionMethods class >> #extensions.
	rejected := false.
	[ GtGemStoneExtensionMethods updateHashOf: #extensions ]
		on: Error
		do: [ :error | rejected := true ].
	self assert: rejected.
	self assert: (GtGemStoneExtensionMethods class >> #extensions) == method.
	^ rejected
]

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> setIntersectionExtension [
	<gtExample>
	<return: #GtGemStoneExtensionMethod>
	| extension gtSource expectedSource |
	extension := GtGemStoneExtensionMethods ext_Set_intersection_.
	self assert: extension selector equals: #intersection:.
	self assert: extension protocol equals: #enumerating.
	self assert: extension className equals: #Set.
	self assert: extension meta not.
	self assert: extension gtVersions isNil.
	self assert: extension hash equals: #new.
	gtSource := (Set compiledMethodAt: #intersection:) sourceCode.
	expectedSource := gtSource copyReplaceAll: 'intersection: aCollection' with: 'intersection: aCollection
	<gtGsExtension>'.
	self
		assert: (extension source withLineEndings: String lf)
		equals: (expectedSource withLineEndings: String lf).
	^ extension
]

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> unixLineEndings [
	<gtExample>
	<return: #GtGemStoneExtensionMethod>
	| extension carriageReturn lineFeed cases |
	extension := GtGemStoneExtensionMethod new.
	carriageReturn := Character cr asString.
	lineFeed := Character lf asString.
	cases := {
		{ ''. '' }.
		{ 'plain text'. 'plain text' }.
		{ 'a', lineFeed, 'b'. 'a', lineFeed, 'b' }.
		{ 'a', carriageReturn, 'b'. 'a', lineFeed, 'b' }.
		{ 'a', carriageReturn, lineFeed, 'b'. 'a', lineFeed, 'b' }.
		{ carriageReturn, 'a', carriageReturn, lineFeed, 'b', lineFeed, 'c', carriageReturn. lineFeed, 'a', lineFeed, 'b', lineFeed, 'c', lineFeed }.
		{ carriageReturn, carriageReturn, lineFeed, lineFeed, carriageReturn. lineFeed, lineFeed, lineFeed, lineFeed }.
		{ 'a\b', carriageReturn, 'c'. 'a\b', lineFeed, 'c' }.
		{ (Character codePoint: 16r03BB) asString, carriageReturn, lineFeed, (Character codePoint: 16r1F600) asString. (Character codePoint: 16r03BB) asString, lineFeed, (Character codePoint: 16r1F600) asString } }.
	cases do: [ :each |
		| original normalized |
		original := each first copy.
		normalized := extension withUnixLineEndings: each first.
		self assert: normalized equals: each second.
		self assert: each first equals: original.
		self assert: (extension withUnixLineEndings: normalized) equals: normalized ].
	^ extension
]

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> updatesExtensionHash [
	<gtExample>
	<return: #GtGemStoneExtensionMethod>
	| selector originalMethod originalExtension extension updatedMethod |
	selector := #ext_TestExecutionEnvironment_registerDefaultServices.
	originalMethod := GtGemStoneExtensionMethods class >> selector.
	originalExtension := GtGemStoneExtensionMethods perform: selector.
	extension := GtGemStoneExtensionMethods updateHashOf: selector.
	updatedMethod := GtGemStoneExtensionMethods class >> selector.
	self assert: extension hash equals: extension existingMethodHash.
	self assert: extension selector equals: originalExtension selector.
	self assert: extension className equals: originalExtension className.
	self assert: extension meta equals: originalExtension meta.
	self assert: extension gtVersions equals: originalExtension gtVersions.
	self assert: extension protocol equals: originalExtension protocol.
	self assert: extension source equals: originalExtension source.
	self assert: updatedMethod protocolName equals: originalMethod protocolName.
	GtGemStoneExtensionMethods updateHashOf: selector.
	self assert: (GtGemStoneExtensionMethods class >> selector) == updatedMethod.
	^ extension
]
