Class {
	#name : 'GtGemStoneContextSpecification',
	#superclass : 'GtGemStoneMethodSpecification',
	#instVars : [
		'isForBlock'
	],
	#category : 'GToolkit-GemStone'
}

{ #category : 'instance creation' }
GtGemStoneContextSpecification class >> forGsCallFrame: aGsCallFrame [
	^ self new 
		initializeForGsCallFrame: aGsCallFrame 
]

{ #category : 'converting' }
GtGemStoneContextSpecification >> asDictionaryForExport [

	^ super asDictionaryForExport
		at: #isForBlock put: isForBlock;
		yourself
]

{ #category : 'initialization' }
GtGemStoneContextSpecification >> initializeForGsCallFrame: aGsCallFrame [ 
	self initializeForGsMethod: aGsCallFrame homeMethod.
	isForBlock := aGsCallFrame isForBlock
]

{ #category : 'initialization' }
GtGemStoneContextSpecification >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	isForBlock := (aDictionary at: 'isForBlock')
]

{ #category : 'accessing' }
GtGemStoneContextSpecification >> isForBlock [
	^ isForBlock ifNil: [ false ]
]
