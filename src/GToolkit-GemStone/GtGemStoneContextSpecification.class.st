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

{ #category : #initialization }
GtGemStoneContextSpecification >> initializeForGsCallFrame: aGsCallFrame [ 
	self initializeForGsMethod: aGsCallFrame homeMethod.
	isForBlock := aGsCallFrame isForBlock
]

{ #category : #initialization }
GtGemStoneContextSpecification >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	isForBlock := (aDictionary at: #isMeta)  
]

{ #category : #accessing }
GtGemStoneContextSpecification >> isForBlock [
	^ isForBlock
]
