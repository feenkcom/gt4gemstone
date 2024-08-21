Class {
	#name : #GtGemstoneEvaluationExceptionResult,
	#superclass : #GtGemstoneEvaluationResult,
	#instVars : [
		'evaluationContext'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #testing }
GtGemstoneEvaluationExceptionResult >> canHandleSpecificDebugger [
	^ true
]

{ #category : #accessing }
GtGemstoneEvaluationExceptionResult >> computedResult [
	^ self evaluationContext
]

{ #category : #accessing }
GtGemstoneEvaluationExceptionResult >> evaluationContext [
	^ evaluationContext
]

{ #category : #accessing }
GtGemstoneEvaluationExceptionResult >> evaluationContext: aGemStoneEvaluationContext [
	evaluationContext := aGemStoneEvaluationContext
]

{ #category : #'initialization ' }
GtGemstoneEvaluationExceptionResult >> gtPharoProxyInitializeWithSession: aGemStoneSession [
	evaluationContext gtPharoProxyInitializeWithSession: aGemStoneSession
]

{ #category : #testing }
GtGemstoneEvaluationExceptionResult >> hasEvaluationException [
	^ true
]

{ #category : #'initialization ' }
GtGemstoneEvaluationExceptionResult >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	aDictionary 
		at: 'evaluationContextProxy' 
		ifPresent: [ :anObject |
			evaluationContext := anObject ]
]
