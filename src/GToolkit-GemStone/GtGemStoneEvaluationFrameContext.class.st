Class {
	#name : #GtGemStoneEvaluationFrameContext,
	#superclass : #Object,
	#instVars : [
		'frameIdentifier',
		'evaluationContext'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneEvaluationFrameContext class >> frameIdentifier: aFrameIdentifier evaluationContext: anEvaluationContext [
	^ self new 
		initializeWithFrameIdentifier: aFrameIdentifier 
		evaluationContext: anEvaluationContext
]

{ #category : #accessing }
GtGemStoneEvaluationFrameContext >> evaluationContext [
	^ evaluationContext
]

{ #category : #accessing }
GtGemStoneEvaluationFrameContext >> frameIdentifier [
	^ frameIdentifier
]

{ #category : #initialization }
GtGemStoneEvaluationFrameContext >> initializeWithFrameIdentifier: aFrameIdentifier evaluationContext: anEvaluationContext [
	frameIdentifier := aFrameIdentifier.
	evaluationContext := anEvaluationContext.
]
