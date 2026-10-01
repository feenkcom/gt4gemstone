"
I provide executable examples for GT-managed GemStone extension method descriptors and their registry.
"
Class {
	#name : #GtGemStoneExtensionMethodExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Examples'
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
