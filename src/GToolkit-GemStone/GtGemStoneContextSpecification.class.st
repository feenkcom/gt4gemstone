Class {
	#name : #GtGemStoneContextSpecification,
	#superclass : #GtGemStoneMethodSpecification,
	#instVars : [
		'isForBlock',
		'ipOffset',
		'frameIdentifier',
		'programCounterMarkers',
		'callerProgramCounterMarkers'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneContextSpecification class >> forGsCallFrame: aGsCallFrame [
	^ self new 
		initializeForGsCallFrame: aGsCallFrame 
]

{ #category : #serialization }
GtGemStoneContextSpecification >> asDictionaryForExport [

	^ super asDictionaryForExport
		at: #isForBlock put: isForBlock;
		at: #ipOffset put: ipOffset;
		at: #frameIdentifier put: frameIdentifier asDictionaryForExport;
		at: #programCounterMarkers put: programCounterMarkers;
		at: #callerProgramCounterMarkers put: callerProgramCounterMarkers;
		yourself
]

{ #category : #accessing }
GtGemStoneContextSpecification >> callerProgramCounterMarkers [
	^ callerProgramCounterMarkers
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
	programCounterMarkers := aGsCallFrame programCounterMarkers.
	callerProgramCounterMarkers := aGsCallFrame callerProgramCounterMarkers.
]

{ #category : #serialization }
GtGemStoneContextSpecification >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.

	isForBlock := aDictionary at: #isForBlock.
	ipOffset := aDictionary at: #ipOffset ifAbsent: [ nil ].
	programCounterMarkers := aDictionary at: #programCounterMarkers ifAbsent: [ nil ].
	callerProgramCounterMarkers := aDictionary at: #callerProgramCounterMarkers ifAbsent: [ nil ].

	(aDictionary includesKey: #frameIdentifier) ifTrue: [
		frameIdentifier := GtGemStoneCallFrameIdentifier
			fromJSONDictionary: (aDictionary at: #frameIdentifier) ]
]

{ #category : #initialization }
GtGemStoneContextSpecification >> initializeProviderBehaviorFromFrame: aGsCallFrame [ 
	| selfObjectClass |
	selfObjectClass := aGsCallFrame selfObjectClass.
	aGsCallFrame methodClass ~= selfObjectClass ifTrue: [
		explicitReceiverBehaviourDetails := GtGemStoneClassBasicDetails 
			forClass: selfObjectClass ]
]

{ #category : #accessing }
GtGemStoneContextSpecification >> ipOffset [
	^ ipOffset
]

{ #category : #accessing }
GtGemStoneContextSpecification >> isForBlock [
	^ isForBlock ifNil: [ false ]
]

{ #category : #accessing }
GtGemStoneContextSpecification >> programCounterMarkers [
	^ programCounterMarkers
]
