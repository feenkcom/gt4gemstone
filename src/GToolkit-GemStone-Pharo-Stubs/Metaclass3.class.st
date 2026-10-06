"
I am a Pharo-side declaration for GemStone's Metaclass3. My gsCode: methods provide GemStone-specific class-side compatibility required by the gtExample framework.
"
Class {
	#name : #Metaclass3,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Stubs'
}

{ #category : #accessing }
Metaclass3 >> classSide [
	<gsCode: '^ self isMeta
		ifTrue: [ self ]
		ifFalse: [ self class ]'>
	^ self shouldNotImplement
]

{ #category : #accessing }
Metaclass3 >> gtExamples [
	<gsCode: '^ self gtExamplesFactory gtExamplesContained'>
	^ self shouldNotImplement
]

{ #category : #accessing }
Metaclass3 >> gtExamplesFactory [
	<gsCode: '^ self gtExamplesFactoryClass new
		sourceClass: self;
		yourself'>
	^ self shouldNotImplement
]

{ #category : #accessing }
Metaclass3 >> gtExamplesFactoryClass [
	<gsCode: '^ GtExampleFactory'>
	^ self shouldNotImplement
]

{ #category : #accessing }
Metaclass3 >> gtExamplesSubjects [
	"I return the list of subjects for examples defined on the instance side."
	<gsCode: '^ #()'>
	^ self shouldNotImplement
]

{ #category : #testing }
Metaclass3 >> includesBehavior: aBehavior [
	<gsCode: '^ self == aBehavior or: [ self allSuperclasses includes: aBehavior ]'>
	^ self shouldNotImplement
]

{ #category : #accessing }
Metaclass3 >> instanceSide [
	<gsCode: '^ self isMeta
		ifTrue: [ self thisClass ]
		ifFalse: [ self ]'>
	^ self shouldNotImplement
]

{ #category : #testing }
Metaclass3 >> isInstanceSide [
	<gsCode: '^ self isMeta not'>
	^ self shouldNotImplement
]

{ #category : #accessing }
Metaclass3 >> methods [
	<gsCode: '^ self selectors collect: [ :each | self compiledMethodAt: each ]'>
	^ self shouldNotImplement
]
