Class {
	#name : #GtGemStoneSessionEvaluationResolveBindingsSignal,
	#superclass : #GtGemStoneSessionEvaluationSignal,
	#traits : 'TGtBeaconSignalStartEndType',
	#classTraits : 'TGtBeaconSignalStartEndType classTrait',
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #emitting }
GtGemStoneSessionEvaluationResolveBindingsSignal class >> emitEndForGtScriptEvaluation: aGtRsrScriptEvaluation [
	^ (self forGtEvaluation: aGtRsrScriptEvaluation) 
		markAsEndSignal;
		emit
]

{ #category : #emitting }
GtGemStoneSessionEvaluationResolveBindingsSignal class >> emitStartForGtScriptEvaluation: aGtRsrScriptEvaluation [
	^ (self forGtEvaluation: aGtRsrScriptEvaluation) 
		markAsStartSignal;
		emit
]

{ #category : #accessing }
GtGemStoneSessionEvaluationResolveBindingsSignal class >> eventType [
	^ GtGemStoneSessionEvaluationResolveBindingsEvent
]

{ #category : #'instance creation' }
GtGemStoneSessionEvaluationResolveBindingsSignal class >> forGtEvaluation: aGtRsrScriptEvaluation [
	^ self new 
		initializeForGtEvaluation: aGtRsrScriptEvaluation
]
