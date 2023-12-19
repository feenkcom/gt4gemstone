Class {
	#name : #GtGemStoneContextSpecification,
	#superclass : #GtGemStoneMethodSpecification,
	#instVars : [
		'isForBlock'
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
		yourself
]

{ #category : #initialization }
GtGemStoneContextSpecification >> initializeForGsCallFrame: aGsCallFrame [ 
	self initializeForGsMethod: aGsCallFrame homeMethod.
	self initializeProviderBehaviorFromFrame: aGsCallFrame.
	
	isForBlock := aGsCallFrame isForBlock
]

{ #category : #initialization }
GtGemStoneContextSpecification >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	isForBlock := aDictionary at: 'isForBlock'.
]

{ #category : #initialization }
GtGemStoneContextSpecification >> initializeProviderBehaviorFromFrame: aGsCallFrame [ 
	| receiverClass |
	receiverClass := aGsCallFrame receiverClass.
	aGsCallFrame receiverClass ~= receiverClass ifTrue: [
		explicitProviderBehaviourDetails := GtGemStoneClassBasicDetails 
			forClass: receiverClass ]
]

{ #category : #accessing }
GtGemStoneContextSpecification >> isForBlock [
	^ isForBlock ifNil: [ false ]
]
