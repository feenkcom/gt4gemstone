Class {
	#name : #GtGemStoneProcessSpecification,
	#superclass : #GtGemStoneMethodsSpecification,
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneProcessSpecification class >> forGsCallStack: aCallStack [
	^ self new 
		initializeForGsCallStack: aCallStack
]

{ #category : #accessing }
GtGemStoneProcessSpecification >> callStackCoderSpecifications [
	^ self methodCoderSpecifications
]

{ #category : #accessing }
GtGemStoneProcessSpecification >> initializeForGsCallStack: aCallStack [
	methodCoderSpecifications := aCallStack callFrames 
		collect: [ :aGsCallFrame |
			GtGemStoneContextSpecification forGsCallFrame: aGsCallFrame ]
]

{ #category : #accessing }
GtGemStoneProcessSpecification >> instantiateCoderSpecificationFromJsonData: aCoderJsonData [ 
	^ GtGemStoneContextSpecification  fromJSONDictionary: aCoderJsonData
]
