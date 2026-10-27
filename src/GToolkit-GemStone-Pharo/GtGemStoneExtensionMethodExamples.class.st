"
I provide executable examples for GT-managed GemStone extension method descriptors and their registry.
"
Class {
	#name : #GtGemStoneExtensionMethodExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> abstractFractionAsScaledDecimalExtension [
	<gtExample>
	<return: #GtGemStoneExtensionMethod>
	| extension expectedSource |
	extension := GtGemStoneExtensionMethods ext_AbstractFraction_asScaledDecimal.
	self assert: extension selector equals: #asScaledDecimal.
	self assert: extension protocol equals: #'gt-extension'.
	self assert: extension className equals: #AbstractFraction.
	self assert: extension meta not.
	self assert: extension gtVersions isNil.
	self assert: extension hash equals: #new.
	expectedSource := (Fraction compiledMethodAt: #asScaledDecimal) sourceCode.
	expectedSource := expectedSource
		copyReplaceAll: 'asScaledDecimal' , String cr
		with: 'asScaledDecimal' , String cr , String tab , '<gtGsExtension>' , String cr.
	expectedSource := expectedSource copyReplaceAll: 'Else, use a default number of decimals.' with: 'Else, use the GT default of eight decimal places.'.
	expectedSource := expectedSource copyReplaceAll: 'denominator' with: 'self denominator'.
	expectedSource := expectedSource copyReplaceAll: 'super asScaledDecimal' with: 'self asScaledDecimal: 8'.
	self assert: (extension source withLineEndings: String lf)
		equals: (expectedSource withLineEndings: String lf).
	self assert: (GtGemStoneExtensionMethods extensionSelectors includes: #ext_AbstractFraction_asScaledDecimal).
	^ extension
]

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> collectionIntersectionExtension [
	<gtExample>
	<return: #GtGemStoneExtensionMethod>
	| extension |
	extension := GtGemStoneExtensionMethods ext_Collection_intersection_.
	self assert: extension selector equals: #intersection:.
	self assert: extension protocol equals: #'gt-extension-method'.
	self assert: extension className equals: #Collection.
	self assert: extension meta not.
	self assert: extension gtVersions isNil.
	self assert: extension hash equals: #new.
	self assert: (extension source includesSubstring: '<gtGsExtension>').
	^ extension
]

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> compilesDescriptorOnSpecifiedBehavior [
	<gtExample>
	| extension target method reconstructed |
	extension := GtGemStoneExtensionMethod new
		selector: #example:;
		protocol: #testing;
		meta: true;
		gtVersions: #('v1' 'v2');
		className: #Object;
		hash: 'original hash';
		source: 'example: anObject
	<gtGsExtension>
	^ ''quoted source'''.
	target := GtGemStoneExtensionMethodBehaviorFixture class.
	[
		method := extension compileExtensionIn: target.
		self assert: method methodClass equals: target.
		self assert: method selector equals: #ext_Object_class_example_.
		self assert: method protocolName equals: #extensions.
		reconstructed := target soleInstance perform: method selector.
		self assert: reconstructed selector equals: extension selector.
		self assert: reconstructed protocol equals: extension protocol.
		self assert: reconstructed meta equals: extension meta.
		self assert: reconstructed gtVersions equals: extension gtVersions.
		self assert: reconstructed className equals: extension className.
		self assert: reconstructed hash equals: extension hash.
		self assert: reconstructed source equals: extension source
	] ensure: [ target removeSelector: extension extensionSelector ].
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
GtGemStoneExtensionMethodExamples >> objectAssertIdenticalToExtension [
	<gtExample>
	| extension |
	extension := GtGemStoneExtensionMethods ext_Object_assert_identicalTo_.
	self assert: extension selector equals: #assert:identicalTo:.
	self assert: extension className equals: #Object.
	self assert: extension meta not.
	self assert: extension gtVersions isNil.
	self assert: extension hash equals: #new.
	self assert: extension protocol equals: #'gt-extension-method'.
	self assert: (extension source includesSubstring: '<gtGsExtension>').
	self assert: (extension source includesSubstring: 'expected == actual').
	^ extension
]

{ #category : #examples }
GtGemStoneExtensionMethodExamples >> registryDelegatesDescriptorCompilation [
	<gtExample>
	| method extension |
	[
		method := GtGemStoneExtensionMethods
			newFromLocalClass: #GtGemStoneExtensionMethodBehaviorFixture
			selector: #initialize meta: false.
		self assert: method methodClass equals: GtGemStoneExtensionMethods class.
		extension := GtGemStoneExtensionMethods perform: method selector.
		self assert: extension className equals: #GtGemStoneExtensionMethodBehaviorFixture.
		self assert: extension selector equals: #initialize.
		self assert: extension hash equals: #new
	] ensure: [
		GtGemStoneExtensionMethods class removeSelector: #ext_GtGemStoneExtensionMethodBehaviorFixture_initialize ].
	^ extension
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
	self assert: extension protocol equals: #'gt-extension-method'.
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
