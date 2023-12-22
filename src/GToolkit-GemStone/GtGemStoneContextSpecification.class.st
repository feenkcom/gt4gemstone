Class {
	#name : #GtGemStoneContextSpecification,
	#superclass : #GtGemStoneMethodSpecification,
	#instVars : [
		'isForBlock',
		'ipOffset',
		'frameIdentifier'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneContextSpecification class >> forGsCallFrame: aGsCallFrame [
	^ self new 
		initializeForGsCallFrame: aGsCallFrame 
]

{ #category : #converting }
GtGemStoneContextSpecification >> asDictionaryForExport [

	^ super asDictionaryForExport
		at: #isForBlock put: isForBlock;
		at: #ipOffset put: ipOffset;
		at: #frameIdentifier put: frameIdentifier asDictionaryForExport;
		yourself
]

{ #category : #accessing }
GtGemStoneContextSpecification >> frameIdentifier [
	^ frameIdentifier
]

{ #category : #initialization }
GtGemStoneContextSpecification >> initializeForGsCallFrame: aGsCallFrame [ 
	self initializeForGsMethod: aGsCallFrame homeMethod.
	self initializeProviderBehaviorFromFrame: aGsCallFrame.
	
	isForBlock := aGsCallFrame isForBlock.
	ipOffset := aGsCallFrame ipOffset.
	frameIdentifier := aGsCallFrame frameIdentifier. 
]

{ #category : #initialization }
GtGemStoneContextSpecification >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	isForBlock := aDictionary at: #isForBlock.
	ipOffset := aDictionary at: #ipOffset ifAbsent: [ nil ].
	(aDictionary includesKey: #frameIdentifier) ifTrue: [
		frameIdentifier := GtGemStoneCallFrameIdentifier 
			fromJSONDictionary: (aDictionary at: #frameIdentifier) ]
]

{ #category : #initialization }
GtGemStoneContextSpecification >> initializeProviderBehaviorFromFrame: aGsCallFrame [ 
	| receiverClass |
	receiverClass := aGsCallFrame receiverClass.
	aGsCallFrame methodClass ~= receiverClass ifTrue: [
		explicitProviderBehaviourDetails := GtGemStoneClassBasicDetails 
			forClass: receiverClass ]
]

{ #category : #accessing }
GtGemStoneContextSpecification >> ipOffset [
	^ ipOffset
]

{ #category : #accessing }
GtGemStoneContextSpecification >> isForBlock [
	^ isForBlock ifNil: [ false ]
]
