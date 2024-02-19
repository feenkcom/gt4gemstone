Class {
	#name : #GtGemStoneSessionEvaluationExecutionEndSignal,
	#superclass : #GtGemStoneSessionEvaluationExecutionSignal,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #emitting }
GtGemStoneSessionEvaluationExecutionEndSignal class >> emitForGtEvaluation: aGtRsrScriptEvaluation [
	^ (self forGtEvaluation: aGtRsrScriptEvaluation) 
		emit
]

{ #category : #'instance creation' }
GtGemStoneSessionEvaluationExecutionEndSignal class >> forGtEvaluation: aGtRsrScriptEvaluation [
	^ self new 
		initializeForGtEvaluation: aGtRsrScriptEvaluation
]

{ #category : #testing }
GtGemStoneSessionEvaluationExecutionEndSignal >> isEndSignalType [
	^ true
]
