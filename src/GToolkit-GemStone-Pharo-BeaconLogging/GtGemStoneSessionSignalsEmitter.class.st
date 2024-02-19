Class {
	#name : #GtGemStoneSessionSignalsEmitter,
	#superclass : #GtBeaconSignalsEmitter,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Emitter'
}

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitEvaluationDeliveryEndFor: aGtRsrScriptEvaluation [
	self whenEnabled: [
		GtGemStoneSessionEvaluationDeliverySignal
			emitEndForGtScriptEvaluation: aGtRsrScriptEvaluation  ]
]

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitEvaluationDeliveryStartFor: aGtRsrScriptEvaluation [
	self whenEnabled: [
		GtGemStoneSessionEvaluationDeliverySignal
			emitStartForGtScriptEvaluation: aGtRsrScriptEvaluation  ]
]

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitEvaluationDeserializeResultEndFor: aGtRsrScriptEvaluation [
	self whenEnabled: [
		GtGemStoneSessionEvaluationDeserializeResultSignal
			emitEndForGtScriptEvaluation: aGtRsrScriptEvaluation  ]
]

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitEvaluationDeserializeResultStartFor: aGtRsrScriptEvaluation [
	self whenEnabled: [
		GtGemStoneSessionEvaluationDeserializeResultSignal
			emitStartForGtScriptEvaluation: aGtRsrScriptEvaluation  ]
]

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitEvaluationExecutionEndFor: aGtRsrScriptEvaluation [
	self whenEnabled: [
		GtGemStoneSessionEvaluationExecutionEndSignal
			emitForGtEvaluation: aGtRsrScriptEvaluation  ]
]

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitEvaluationPromiseWaitEndFor: aGtRsrScriptEvaluation [
	self whenEnabled: [
		GtGemStoneSessionEvaluationPromiseWaitSignal
			emitEndForGtScriptEvaluation: aGtRsrScriptEvaluation  ]
]

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitEvaluationPromiseWaitStartFor: aGtRsrScriptEvaluation [
	self whenEnabled: [
		GtGemStoneSessionEvaluationPromiseWaitSignal
			emitStartForGtScriptEvaluation: aGtRsrScriptEvaluation  ]
]

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitEvaluationResolveBindingsEndFor: aGtRsrScriptEvaluation [
	self whenEnabled: [
		GtGemStoneSessionEvaluationResolveBindingsSignal
			emitEndForGtScriptEvaluation: aGtRsrScriptEvaluation  ]
]

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitEvaluationResolveBindingsStartFor: aGtRsrScriptEvaluation [
	self whenEnabled: [
		GtGemStoneSessionEvaluationResolveBindingsSignal
			emitStartForGtScriptEvaluation: aGtRsrScriptEvaluation  ]
]

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitPerformEvaluationExecutionEndFor: aGtRsrScriptEvaluation [
	self emitEvaluationExecutionEndFor: aGtRsrScriptEvaluation
]

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitPerformEvaluationExecutionStartFor: aGtRsrScriptEvaluation [
	self whenEnabled: [
		GtJustContextStackSignal emit.
		GtGemStoneSessionEvaluationPerformExecutionStartSignal 
			emitForGtPerformEvaluation: aGtRsrScriptEvaluation  ]
]

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitScriptEvaluationExecutionEndFor: aGtRsrScriptEvaluation [
	self emitEvaluationExecutionEndFor: aGtRsrScriptEvaluation
]

{ #category : #logging }
GtGemStoneSessionSignalsEmitter >> emitScriptEvaluationExecutionStartFor: aGtRsrScriptEvaluation [
	self whenEnabled: [
		GtGemStoneSessionEvaluationScriptExecutionStartSignal
			emitForGtScriptEvaluation: aGtRsrScriptEvaluation  ]
]
