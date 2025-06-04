Class {
	#name : #GtGemStoneSemanticVersionNumber,
	#superclass : #Object,
	#instVars : [
		'major',
		'minor',
		'patch',
		'iceTag'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneSemanticVersionNumber class >> major: majorNumber minor: minorNumber patch: patchNumber [
	^ self new 
		initializeMajor: majorNumber
		minor: minorNumber
		patch: patchNumber
]

{ #category : #'instance creation' }
GtGemStoneSemanticVersionNumber class >> oneZeroZero [
	^ self major: 1 minor: 0 patch: 0
]

{ #category : #converting }
GtGemStoneSemanticVersionNumber class >> readFromString: aString [
	| tokens |
	tokens := (aString trimBoth trimLeft: [:char | char = $v]) findTokens: '.'.
	^ self 
		major: tokens first asInteger
		minor: tokens second asInteger
		patch: tokens third asInteger. 
]

{ #category : #'instance creation' }
GtGemStoneSemanticVersionNumber class >> v1_0_1098 [

	^ self major: 1 minor: 0 patch: 1098
]

{ #category : #'instance creation' }
GtGemStoneSemanticVersionNumber class >> v1_0_1501 [

	^ self major: 1 minor: 0 patch: 1501
]

{ #category : #'instance creation' }
GtGemStoneSemanticVersionNumber class >> v1_0_1502 [

	^ self major: 1 minor: 0 patch: 1502
]

{ #category : #accessing }
GtGemStoneSemanticVersionNumber class >> versionNumberRegexString [
	^ 'v[0-9]+\.[0-9]+\.[0-9]+'
]

{ #category : #'instance creation' }
GtGemStoneSemanticVersionNumber class >> zero [
	^ self major: 0 minor: 0 patch: 0
]

{ #category : #comparing }
GtGemStoneSemanticVersionNumber >> < aSemanticVersionNumber [
	self major < aSemanticVersionNumber major ifTrue: [ ^ true ].
		self major = aSemanticVersionNumber major ifTrue: [ 
			self minor < aSemanticVersionNumber minor ifTrue: [ ^ true ].
			self minor = aSemanticVersionNumber minor ifTrue: [ 
				self patch < aSemanticVersionNumber patch ifTrue: [ ^ true ]]].
	^ false.
]

{ #category : #comparing }
GtGemStoneSemanticVersionNumber >> <= aSemanticVersionNumber [
	"Answer whether the receiver is less than or equal to the given version number."
	^ (self > aSemanticVersionNumber) not
]

{ #category : #comparing }
GtGemStoneSemanticVersionNumber >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ self major = anObject major and: [ 
		 self minor = anObject minor and: [ 
			self patch = anObject patch ] ]
]

{ #category : #comparing }
GtGemStoneSemanticVersionNumber >> > aSemanticVersionNumber [ 
	"Answer whether the receiver is greater than the argument."

	^aSemanticVersionNumber < self
]

{ #category : #comparing }
GtGemStoneSemanticVersionNumber >> >= aSemanticVersionNumber [ 
	"Answer whether the receiver is greater than or equal to the argument."

	^ aSemanticVersionNumber <= self
]

{ #category : #comparing }
GtGemStoneSemanticVersionNumber >> hash [
	^ ((self species hash
		bitXor: self major hash)
		bitXor: self minor hash)
		bitXor: self patch hash
]

{ #category : #initialization }
GtGemStoneSemanticVersionNumber >> initializeMajor: aMajorNumber minor: aMinorNumber patch: aPatchNumber [
	 (aMajorNumber notNil and: [ aMinorNumber notNil and: [ aPatchNumber notNil ] ])
	 	ifFalse: [ 
	 		Error signal: 'The components of a semantic version cannot be null' ].
	(aMajorNumber >= 0 and: [ aMinorNumber >= 0 and: [ aPatchNumber >= 0 ] ])
		ifFalse: [ 
			Error signal: 'The components of a semantic version should not be negative' ].
	(major isNil and: [ minor isNil and: [ patch isNil ] ]) 
		ifFalse: [
			Error signal: 'Semantic version numbers are immutable' ].
	
	major := aMajorNumber.
	minor := aMinorNumber.
	patch := aPatchNumber.
]

{ #category : #testing }
GtGemStoneSemanticVersionNumber >> isZero [
	^ self = self class zero
]

{ #category : #accessing }
GtGemStoneSemanticVersionNumber >> major [
	^ major
]

{ #category : #accessing }
GtGemStoneSemanticVersionNumber >> minor [
	^ minor
]

{ #category : #accessing }
GtGemStoneSemanticVersionNumber >> patch [
	^ patch 
]

{ #category : #printing }
GtGemStoneSemanticVersionNumber >> printOn: aStream [
	super printOn: aStream.
	
	aStream 
		nextPut: $(;
		nextPutAll: self versionString;
		nextPut: $)
]

{ #category : #accessing }
GtGemStoneSemanticVersionNumber >> tag [
	^ iceTag
]

{ #category : #accessing }
GtGemStoneSemanticVersionNumber >> tag: anIceTag [
	iceTag := anIceTag 
]

{ #category : #accessing }
GtGemStoneSemanticVersionNumber >> versionString [
	^ String streamContents: [ :aStream |
		aStream 
			<< 'v';
			<< self major printString;
			<< '.';
			<< self minor printString;
			<< '.';
			<< self patch printString ]
]
