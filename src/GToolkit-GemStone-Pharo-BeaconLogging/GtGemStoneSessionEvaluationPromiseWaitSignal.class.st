Class {
	#name : #GtGemStoneSessionEvaluationPromiseWaitSignal,
	#superclass : #GtGemStoneSessionEvaluationSignal,
	#traits : 'TGtBeaconSignalStartEndType',
	#classTraits : 'TGtBeaconSignalStartEndType classTrait',
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #emitting }
GtGemStoneSessionEvaluationPromiseWaitSignal class >> emitEndForGtScriptEvaluation: aGtRsrScriptEvaluation [
	^ (self forGtEvaluation: aGtRsrScriptEvaluation) 
		markAsEndSignal;
		emit
]

{ #category : #emitting }
GtGemStoneSessionEvaluationPromiseWaitSignal class >> emitStartForGtScriptEvaluation: aGtRsrScriptEvaluation [
	^ (self forGtEvaluation: aGtRsrScriptEvaluation) 
		markAsStartSignal;
		emit
]

{ #category : #accessing }
GtGemStoneSessionEvaluationPromiseWaitSignal class >> eventType [
	^ GtGemStoneSessionEvaluationPromiseWaitEvent
]

{ #category : #'instance creation' }
GtGemStoneSessionEvaluationPromiseWaitSignal class >> forGtEvaluation: aGtRsrScriptEvaluation [
	^ self new 
		initializeForGtEvaluation: aGtRsrScriptEvaluation
]
