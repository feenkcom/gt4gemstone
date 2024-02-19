Class {
	#name : #GtGemStoneSessionEvaluationSignal,
	#superclass : #GtGemStoneSessionSignal,
	#instVars : [
		'evaluationId'
	],
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #initialization }
GtGemStoneSessionEvaluationSignal >> initializeForGtEvaluation: aGtRsrEvaluation [
	self initializeForGtGemStoneSession: aGtRsrEvaluation gtSession.
	
	evaluationId := aGtRsrEvaluation identityHash.
]
