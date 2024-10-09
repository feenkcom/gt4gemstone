Class {
	#name : #GtRsrScriptEvaluation,
	#superclass : #GtRsrEvaluation,
	#instVars : [
		'script',
		'frameContext'
	],
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #evaluating }
GtRsrScriptEvaluation >> basicAsyncEvaluateWithSerialisation [
	"Evaluate the receiver on the supplied evaluator"

	^ gtSession evaluator evaluateAsyncScript: self 
]

{ #category : #evaluating }
GtRsrScriptEvaluation >> basicSyncEvaluateWithSerialisation [
	"Evaluate the receiver on the supplied evaluator"
	^ gtSession evaluator evaluateScript: self 
]

{ #category : #logging }
GtRsrScriptEvaluation >> emitEvaluationExecutionEndSignal [
	self gtSession logEmitter 
		emitScriptEvaluationExecutionEndFor:  self
]

{ #category : #logging }
GtRsrScriptEvaluation >> emitEvaluationExecutionStartSignal [
	self gtSession logEmitter 
		emitScriptEvaluationExecutionStartFor:  self
]

{ #category : #evaluating }
GtRsrScriptEvaluation >> executeBlockWithDeliveryLogging: aBlockClosure [
	| result |
	gtSession logEmitter
		emitEvaluationDeliveryStartFor: self.
		
	result := aBlockClosure value.
	
	gtSession logEmitter
		emitEvaluationDeliveryEndFor: self.
			
	^ result
]

{ #category : #accessing }
GtRsrScriptEvaluation >> frameContext [
	^ frameContext
]

{ #category : #accessing }
GtRsrScriptEvaluation >> frameContext: aFrameExecutionContext [
	frameContext := aFrameExecutionContext
]

{ #category : #evaluating }
GtRsrScriptEvaluation >> performEvaluateWithLogging: aBlockClosure [
	| evaluationResult |
	
	self emitEvaluationExecutionStartSignal.
	evaluationResult := aBlockClosure value.
	self emitEvaluationExecutionEndSignal.
	
	^ evaluationResult 
]

{ #category : #accessing }
GtRsrScriptEvaluation >> script [
	^ script
]

{ #category : #accessing }
GtRsrScriptEvaluation >> script: anObject [
	script := anObject
]
