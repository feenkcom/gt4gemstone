Class {
	#name : #GtGemstoneEvaluationComputedResult,
	#superclass : #GtGemstoneEvaluationResult,
	#instVars : [
		'computedResult'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtGemstoneEvaluationComputedResult >> computedResult [
	^ computedResult
]

{ #category : #accessing }
GtGemstoneEvaluationComputedResult >> computedResult: anObject [
	computedResult := anObject
]

{ #category : #'initialization ' }
GtGemstoneEvaluationComputedResult >> gtPharoProxyInitializeWithSession: aGemStoneSession [
	computedResult gtPharoProxyInitializeWithSession: aGemStoneSession
]

{ #category : #'initialization ' }
GtGemstoneEvaluationComputedResult >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	aDictionary 
		at: 'computedResult' 
		ifPresent: [ :anObject |
			computedResult := anObject ]
]

{ #category : #testing }
GtGemstoneEvaluationComputedResult >> isEvaluationComputedResult [
	^ true
]
