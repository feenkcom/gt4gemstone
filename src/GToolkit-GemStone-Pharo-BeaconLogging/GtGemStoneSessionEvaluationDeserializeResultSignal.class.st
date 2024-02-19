Class {
	#name : #GtGemStoneSessionEvaluationDeserializeResultSignal,
	#superclass : #GtGemStoneSessionEvaluationSignal,
	#traits : 'TGtBeaconSignalStartEndType',
	#classTraits : 'TGtBeaconSignalStartEndType classTrait',
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #emitting }
GtGemStoneSessionEvaluationDeserializeResultSignal class >> emitEndForGtScriptEvaluation: aGtRsrScriptEvaluation [
	^ (self forGtEvaluation: aGtRsrScriptEvaluation) 
		markAsEndSignal;
		emit
]

{ #category : #emitting }
GtGemStoneSessionEvaluationDeserializeResultSignal class >> emitStartForGtScriptEvaluation: aGtRsrScriptEvaluation [
	^ (self forGtEvaluation: aGtRsrScriptEvaluation) 
		markAsStartSignal;
		emit
]

{ #category : #accessing }
GtGemStoneSessionEvaluationDeserializeResultSignal class >> eventType [
	^ GtGemStoneSessionEvaluationDeserializeResultEvent
]

{ #category : #'instance creation' }
GtGemStoneSessionEvaluationDeserializeResultSignal class >> forGtEvaluation: aGtRsrScriptEvaluation [
	^ self new 
		initializeForGtEvaluation: aGtRsrScriptEvaluation
]
