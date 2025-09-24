Class {
	#name : #GtGemstoneEvaluationInProgressResult,
	#superclass : #GtGemstoneEvaluationResult,
	#instVars : [
		'evaluationContext'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtGemstoneEvaluationInProgressResult >> computedResult [
	^ self evaluationContext
]

{ #category : #accessing }
GtGemstoneEvaluationInProgressResult >> evaluationContext [
	^ evaluationContext
]

{ #category : #accessing }
GtGemstoneEvaluationInProgressResult >> evaluationContext: aGemStoneEvaluationContext [
	evaluationContext := aGemStoneEvaluationContext
]

{ #category : #'initialization ' }
GtGemstoneEvaluationInProgressResult >> gtPharoProxyInitializeWithSession: aGemStoneSession [
	evaluationContext gtPharoProxyInitializeWithSession: aGemStoneSession
]

{ #category : #'initialization ' }
GtGemstoneEvaluationInProgressResult >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	aDictionary 
		at: 'evaluationContextProxy' 
		ifPresent: [ :anObject |
			evaluationContext := anObject ]
]
