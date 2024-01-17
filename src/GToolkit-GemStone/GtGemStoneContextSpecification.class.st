Class {
	#name : #GtGemStoneContextSpecification,
	#superclass : #GtGemStoneMethodSpecification,
	#instVars : [
		'isForBlock',
		'ipOffset',
		'frameIdentifier',
		'programCounterMarkers'
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
		at: #programCounterMarkers put: programCounterMarkers;
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
	programCounterMarkers := aGsCallFrame programCounterMarkers. 
]

{ #category : #initialization }
GtGemStoneContextSpecification >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	isForBlock := aDictionary at: #isForBlock.
	ipOffset := aDictionary at: #ipOffset ifAbsent: [ nil ].
	programCounterMarkers := aDictionary at: #programCounterMarkers ifAbsent: [ nil ].
	
	(aDictionary includesKey: #frameIdentifier) ifTrue: [
		frameIdentifier := GtGemStoneCallFrameIdentifier 
			fromJSONDictionary: (aDictionary at: #frameIdentifier) ]
]

{ #category : #initialization }
GtGemStoneContextSpecification >> initializeProviderBehaviorFromFrame: aGsCallFrame [ 
	| selfObjectClass |
	selfObjectClass := aGsCallFrame selfObjectClass.
	aGsCallFrame methodClass ~= selfObjectClass ifTrue: [
		explicitProviderBehaviourDetails := GtGemStoneClassBasicDetails 
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
