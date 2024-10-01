Class {
	#name : #GtRsrScriptEvaluation,
	#superclass : #GtRsrEvaluation,
	#instVars : [
		'script',
		'frameIdentifier'
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

	"The first two checks are a hack until the server is updated to match"
	serialisationStrategy = #GtRsrLegacySerializationStrategy ifTrue:
		[ ^ self evaluateLegacy ].
	serialisationStrategy = #GtRsrProxyOnlySerializationStrategy ifTrue:
		[ ^ self evaluateProxyOnly ].

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

{ #category : #'private - evaluating' }
GtRsrScriptEvaluation >> evaluateLegacy [

	^ gtSession evaluator evaluateLegacyScript: self
]

{ #category : #'private - evaluating' }
GtRsrScriptEvaluation >> evaluateProxyOnly [

	^ gtSession evaluator evaluateProxyOnlyScript: self
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
GtRsrScriptEvaluation >> frameIdentifier [
	^ frameIdentifier
]

{ #category : #accessing }
GtRsrScriptEvaluation >> frameIdentifier: anObject [
	frameIdentifier := anObject
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
