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
