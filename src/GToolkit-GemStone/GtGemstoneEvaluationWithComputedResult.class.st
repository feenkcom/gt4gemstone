Class {
	#name : #GtGemstoneEvaluationWithComputedResult,
	#superclass : #GtGemstoneEvaluationResult,
	#instVars : [
		'computedResult'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtGemstoneEvaluationWithComputedResult >> computedResult [
	^ computedResult
]

{ #category : #accessing }
GtGemstoneEvaluationWithComputedResult >> computedResult: anObject [
	computedResult := anObject
]

{ #category : #'initialization ' }
GtGemstoneEvaluationWithComputedResult >> gtPharoProxyInitializeWithSession: aGemStoneSession [
	computedResult gtPharoProxyInitializeWithSession: aGemStoneSession
]

{ #category : #'initialization ' }
GtGemstoneEvaluationWithComputedResult >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	aDictionary 
		at: 'computedResult' 
		ifPresent: [ :anObject |
			computedResult := anObject ]
]
