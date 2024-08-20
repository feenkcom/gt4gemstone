Class {
	#name : #GtGemstoneEvaluationWithInProgressResult,
	#superclass : #GtGemstoneEvaluationResult,
	#instVars : [
		'evaluationContext'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'as yet unclassified' }
GtGemstoneEvaluationWithInProgressResult >> computedResult [
	^ self evaluationContext
]

{ #category : #accessing }
GtGemstoneEvaluationWithInProgressResult >> evaluationContext [
	^ evaluationContext
]

{ #category : #accessing }
GtGemstoneEvaluationWithInProgressResult >> evaluationContext: aGemStoneEvaluationContext [
	evaluationContext := aGemStoneEvaluationContext
]

{ #category : #'initialization ' }
GtGemstoneEvaluationWithInProgressResult >> gtPharoProxyInitializeWithSession: aGemStoneSession [
	evaluationContext gtPharoProxyInitializeWithSession: aGemStoneSession
]

{ #category : #'initialization ' }
GtGemstoneEvaluationWithInProgressResult >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	aDictionary 
		at: 'evaluationContextProxy' 
		ifPresent: [ :anObject |
			evaluationContext := anObject ]
]
