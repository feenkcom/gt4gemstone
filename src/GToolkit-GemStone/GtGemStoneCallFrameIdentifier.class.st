Class {
	#name : #GtGemStoneCallFrameIdentifier,
	#superclass : #Object,
	#instVars : [
		'identityIndex'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneCallFrameIdentifier class >> forIndex: anIndex [
	^ self new 
		initializeForIndex: anIndex
]

{ #category : #'instance creation' }
GtGemStoneCallFrameIdentifier class >> initialIdentifier [
	^ self forIndex: 0
]

{ #category : #comparing }
GtGemStoneCallFrameIdentifier >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	
	^ self identityIndex = anObject identityIndex
]

{ #category : #comparing }
GtGemStoneCallFrameIdentifier >> hash [
	^ self identityIndex hash
]

{ #category : #accessing }
GtGemStoneCallFrameIdentifier >> identityIndex [
	^ identityIndex
]

{ #category : #initialization }
GtGemStoneCallFrameIdentifier >> initializeForIndex: anIndex [
	identityIndex := anIndex
]

{ #category : #accessing }
GtGemStoneCallFrameIdentifier >> nextIdentifier [
	^ self class forIndex: self identityIndex + 1
]

{ #category : #printing }
GtGemStoneCallFrameIdentifier >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream
			nextPutAll: self identityIndex ]
]
