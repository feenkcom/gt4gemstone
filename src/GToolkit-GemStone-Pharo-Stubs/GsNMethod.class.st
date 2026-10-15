"
I am a Pharo-side declaration for GemStone's GsNMethod. My gsCode: methods provide compiled-method compatibility required by the gtExample framework.
"
Class {
	#name : #GsNMethod,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Stubs'
}

{ #category : #accessing }
GsNMethod >> gtExample [
	<gsCode: 'self gtExamplesFactory exampleMethod: self do: [ :example | ^ example ].
	^ nil'>
	^ self shouldNotImplement
]

{ #category : #accessing }
GsNMethod >> gtExampleReturnValueClass [
	<gsCode: '| returnValue |
	returnValue := self gtExample result returnValue.
	(returnValue isKindOf: Exception)
		ifTrue: [ ReturnPragmasRefactoringError
				signal: ''An  example failed''
				failingExample: self ].
	^ returnValue class'>
	^ self shouldNotImplement
]

{ #category : #accessing }
GsNMethod >> gtExampleValue [
	<gsCode: '^ self gtExample returnValue'>
	^ self shouldNotImplement
]

{ #category : #accessing }
GsNMethod >> gtExampleWithProviderClass: aProviderClass [
	<gsCode: 'self gtExamplesFactory
		exampleFromMethod: self
		withProviderClass: aProviderClass
		do: [ :example | ^ example ].
	^ nil'>
	^ self shouldNotImplement
]

{ #category : #accessing }
GsNMethod >> gtExampleWithResult [
	<gsCode: '"GemStone does not support compiled-method properties or Pharo weak references."
	| anExample |
	anExample := self gtExample.
	^ anExample ifNotNil: [ anExample asExampleWithResult ]'>
	^ self shouldNotImplement
]

{ #category : #accessing }
GsNMethod >> gtExampleWithResultForExample: anExample [
	<gsCode: '"GemStone does not support compiled-method properties or Pharo weak references."
	self
		assert: [ anExample receiverClass ~= anExample methodClass ]
		description: [ ''Example provider and method classes must be different. Call anExample asCachedExampleWithResult instead'' ].
	self
		assert: [ anExample exists and: [ anExample method = self ] ]
		description: [ ''I can be called only with examples that represents me. Call anExample asCachedExampleWithResult instead'' ].
	^ anExample asExampleWithResult'>
	^ self shouldNotImplement
]

{ #category : #accessing }
GsNMethod >> gtExamples [
	<gsCode: '^ self gtExample
		ifNotNil: [ :example | { example } ]
		ifNil: [ #() ]'>
	^ self shouldNotImplement
]

{ #category : #accessing }
GsNMethod >> gtExamplesFactory [
	<gsCode: '^ self methodClass instanceSide gtExamplesFactory'>
	^ self shouldNotImplement
]

{ #category : #testing }
GsNMethod >> isGTExampleMethod [
	<gsCode: '^ (self pragmas anySatisfy: [ :each | each isGTExamplePragma ])
		and: [ self numArgs = 0 ]'>
	^ self shouldNotImplement
]

{ #category : #accessing }
GsNMethod >> methodClass [
	<gsCode: '^ self inClass'>
	^ self shouldNotImplement
]
