Class {
	#name : #GtGemStoneSessionEvaluationExecutionStartSignal,
	#superclass : #GtGemStoneSessionEvaluationExecutionSignal,
	#instVars : [
		'serialisationStrategyName',
		'autoCommit'
	],
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #accessing }
GtGemStoneSessionEvaluationExecutionStartSignal >> initializeForGtEvaluation: aGtRsrScriptEvaluation [
	super initializeForGtEvaluation: aGtRsrScriptEvaluation.
	
	serialisationStrategyName := aGtRsrScriptEvaluation serialisationStrategy.
	autoCommit := aGtRsrScriptEvaluation autoCommit.
]

{ #category : #testing }
GtGemStoneSessionEvaluationExecutionStartSignal >> isStartSignalType [
	^ true
]
