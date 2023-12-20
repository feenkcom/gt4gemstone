Class {
	#name : #GtGemStoneCallFrameIdentity,
	#superclass : #Object,
	#instVars : [
		'className',
		'methodSelector',
		'ipOffset'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneCallFrameIdentity class >> className: aClassName methodSelector: aMethodSelector ipOffset: anInteger [
	^ self new 
		initializeForClassName: aClassName 
		methodSelector: aMethodSelector 
		ipOffset: anInteger
]

{ #category : #comparing }
GtGemStoneCallFrameIdentity >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	
	^ self targetClassName = anObject targetClassName and: [ 
		 self methodSelector = anObject methodSelector and: [ 
			self programCounter = anObject programCounter ] ]
]

{ #category : #comparing }
GtGemStoneCallFrameIdentity >> hash [
	^ (self targetClassName hash
		bitXor: self methodSelector hash)
		bitXor: self programCounter hash
]

{ #category : #initialization }
GtGemStoneCallFrameIdentity >> initializeForClassName: aClassName methodSelector: aMethodSelector ipOffset: anInteger [ 
	className := aClassName.
	methodSelector := aMethodSelector.
	ipOffset := anInteger.
]

{ #category : #accessing }
GtGemStoneCallFrameIdentity >> methodSelector [
	^ methodSelector
]

{ #category : #printing }
GtGemStoneCallFrameIdentity >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream
			nextPutAll: self targetClassName;
			nextPutAll: '>>#';
			nextPutAll: self methodSelector;
			nextPutAll: ' [';
			nextPutAll: self programCounter asString;
			nextPutAll: ']' ]
]

{ #category : #accessing }
GtGemStoneCallFrameIdentity >> programCounter [
	^ ipOffset
]

{ #category : #accessing }
GtGemStoneCallFrameIdentity >> targetClassName [
	^ className
]
