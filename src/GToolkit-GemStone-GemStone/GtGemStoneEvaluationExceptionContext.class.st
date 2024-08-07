Class {
	#name : 'GtGemStoneEvaluationExceptionContext',
	#superclass : 'GtGemStoneEvaluationContext',
	#instVars : [
		'previousEvaluationContext'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : 'initialization' }
GtGemStoneEvaluationExceptionContext >> initializeFromContext: aGtGemStoneEvaluationContext [
	super initializeFromContext: aGtGemStoneEvaluationContext.

	previousEvaluationContext := aGtGemStoneEvaluationContext.
]

{ #category : 'accessing' }
GtGemStoneEvaluationExceptionContext >> previousEvaluationContext [
	^previousEvaluationContext
]

{ #category : 'accessing' }
GtGemStoneEvaluationExceptionContext >> previousEvaluationContext: object [
	previousEvaluationContext := object
]

{ #category : 'api - debug' }
GtGemStoneEvaluationExceptionContext >> resume [

	self assertNotSignalled.

	process resume.
	semaphore wait.
	result := previousEvaluationContext result.
	^ result
]
