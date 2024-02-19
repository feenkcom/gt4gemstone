Class {
	#name : #GtRsrPerformEvaluation,
	#superclass : #GtRsrEvaluation,
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #accessing }
GtRsrPerformEvaluation >> arguments [
	^ arguments
]

{ #category : #accessing }
GtRsrPerformEvaluation >> arguments: anObject [
	arguments := anObject
]

{ #category : #evaluating }
GtRsrPerformEvaluation >> basicEvaluateWithSerialisation [
	
	"The first two checks are a hack until the server is updated to match"
	serialisationStrategy = #GtRsrLegacySerializationStrategy ifTrue:
		[ ^ self evaluateLegacy ].
	serialisationStrategy = #GtRsrProxyOnlySerializationStrategy ifTrue:
		[ ^ self evaluateProxyOnly ].

	^ gtSession evaluator evaluatePerform: self 
]

{ #category : #logging }
GtRsrPerformEvaluation >> emitEvaluationExecutionEndSignal [
	self gtSession logEmitter 
		emitPerformEvaluationExecutionEndFor:  self
]

{ #category : #logging }
GtRsrPerformEvaluation >> emitEvaluationExecutionStartSignal [
	self gtSession logEmitter 
		emitPerformEvaluationExecutionStartFor:  self
]

{ #category : #evaluating }
GtRsrPerformEvaluation >> evaluateLegacy [

	^ gtSession evaluator evaluateLegacyPerform: self
]

{ #category : #evaluating }
GtRsrPerformEvaluation >> evaluateProxyOnly [

	^ gtSession evaluator evaluateProxyOnlyPerform: self
]

{ #category : #evaluating }
GtRsrPerformEvaluation >> executeBlockWithDeliveryLogging: aBlockClosure [
	| result |
	gtSession logEmitter
		emitEvaluationDeliveryStartFor: self.
		
	result := aBlockClosure value.
	
	gtSession logEmitter
		emitEvaluationDeliveryEndFor: self.
			
	^ result
]

{ #category : #initialize }
GtRsrPerformEvaluation >> initialize [

	super initialize.
	arguments := #().
]

{ #category : #evaluating }
GtRsrPerformEvaluation >> performEvaluateWithLogging: aBlockClosure [
	| evaluationResult |
	
	self emitEvaluationExecutionStartSignal.
	evaluationResult := aBlockClosure value.
	self emitEvaluationExecutionEndSignal.
	
	^ evaluationResult 
]

{ #category : #accessing }
GtRsrPerformEvaluation >> remoteSelf [

	^ receiver remoteSelf
]

{ #category : #accessing }
GtRsrPerformEvaluation >> selector [
	^ selector
]

{ #category : #accessing }
GtRsrPerformEvaluation >> selector: anObject [
	selector := anObject
]
