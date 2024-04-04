Class {
	#name : #GtGemStoneSessionEvaluationDeliverySignal,
	#superclass : #GtGemStoneSessionEvaluationSignal,
	#traits : 'TGtBeaconSignalStartEndType',
	#classTraits : 'TGtBeaconSignalStartEndType classTrait',
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #emitting }
GtGemStoneSessionEvaluationDeliverySignal class >> emitEndForGtScriptEvaluation: aGtRsrScriptEvaluation [
	^ (self forGtEvaluation: aGtRsrScriptEvaluation) 
		markAsEndSignal;
		emit
]

{ #category : #emitting }
GtGemStoneSessionEvaluationDeliverySignal class >> emitStartForGtScriptEvaluation: aGtRsrScriptEvaluation [
	^ (self forGtEvaluation: aGtRsrScriptEvaluation) 
		markAsStartSignal;
		emit
]

{ #category : #accessing }
GtGemStoneSessionEvaluationDeliverySignal class >> eventType [
	^ GtGemStoneSessionEvaluationDeliveryEvent
]

{ #category : #'instance creation' }
GtGemStoneSessionEvaluationDeliverySignal class >> forGtEvaluation: aGtRsrScriptEvaluation [
	^ self new 
		initializeForGtEvaluation: aGtRsrScriptEvaluation
]

{ #category : #printing }
GtGemStoneSessionEvaluationDeliverySignal >> printOneLineContentsOn: aStream [
	aStream print: eventType
]
