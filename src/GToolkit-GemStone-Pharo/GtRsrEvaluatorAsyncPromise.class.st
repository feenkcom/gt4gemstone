Class {
	#name : #GtRsrEvaluatorAsyncPromise,
	#superclass : #Object,
	#instVars : [
		'gtRsrEvaluatorPromise',
		'value',
		'executionContext',
		'state',
		'gemStoneSession',
		'serializationStrategy',
		'evaluationMutex'
	],
	#category : #'GToolkit-GemStone-Pharo-Promises'
}

{ #category : #accessing }
GtRsrEvaluatorAsyncPromise >> basicDeserializeResult: aResult [
	^ (self class environment 
		at: serializationStrategy) new 
			deserialize: aResult.
]

{ #category : #resolving }
GtRsrEvaluatorAsyncPromise >> break: aReason [ 
	value := aReason.
	state := #Broken.
]

{ #category : #resolving }
GtRsrEvaluatorAsyncPromise >> breakWithEvaluationResult: evaluationResult [ 
	self break: evaluationResult computedResult.
]

{ #category : #testing }
GtRsrEvaluatorAsyncPromise >> canStopExecution [
	^ executionContext notNil and: [
		self isResolved not ]
]

{ #category : #utils }
GtRsrEvaluatorAsyncPromise >> createEvaluationResultFromData: aDictionaryOrObject [ 
	"Instantiate an evaluation result object from the given object."

	^ GtGemstoneEvaluationResult 
		createEvaluationResultFromData: aDictionaryOrObject 
]

{ #category : #resolving }
GtRsrEvaluatorAsyncPromise >> fulfill: anObject [
	"Fulfill the receiver"

	value := anObject.
	state := #Fulfilled
]

{ #category : #resolving }
GtRsrEvaluatorAsyncPromise >> fulfillWithEvaluationResult: evaluationResult [ 
	| computedResult |
	computedResult := evaluationResult computedResult.
	
	self fullfilWithComputedResult: computedResult
]

{ #category : #resolving }
GtRsrEvaluatorAsyncPromise >> fullfilWithComputedResult: computedResult [ 
	| deserializedResult |
	deserializedResult := self 
		basicDeserializeResult: computedResult.
		
	self fulfill: deserializedResult
]

{ #category : #accessing }
GtRsrEvaluatorAsyncPromise >> gemStoneSession [
	^ gemStoneSession
]

{ #category : #accessing }
GtRsrEvaluatorAsyncPromise >> gemStoneSession: aGemStoneSession [
	gemStoneSession := aGemStoneSession
]

{ #category : #accessing }
GtRsrEvaluatorAsyncPromise >> gtRsrEvaluatorPromise [
	^ gtRsrEvaluatorPromise
]

{ #category : #accessing }
GtRsrEvaluatorAsyncPromise >> gtRsrEvaluatorPromise: anEvaluatorPromise [
	gtRsrEvaluatorPromise := anEvaluatorPromise
]

{ #category : #testing }
GtRsrEvaluatorAsyncPromise >> hasEvaluationContext [
	^ executionContext notNil
]

{ #category : #testing }
GtRsrEvaluatorAsyncPromise >> hasValidResult [
	^ self isFulfilled
]

{ #category : #initialization }
GtRsrEvaluatorAsyncPromise >> initialize [
	super initialize.
	
	value := self.
	evaluationMutex := Mutex new.
	state := #PendingResolution.
]

{ #category : #actions }
GtRsrEvaluatorAsyncPromise >> interruptEvaluation [
	self assert: [ executionContext notNil ].
	
	^ executionContext interruptAsyncComputation
]

{ #category : #testing }
GtRsrEvaluatorAsyncPromise >> isBroken [
	"Report if the receiver is currently broken"

	^state == #Broken
]

{ #category : #testing }
GtRsrEvaluatorAsyncPromise >> isForAsyncExecution [
	^ true 
]

{ #category : #testing }
GtRsrEvaluatorAsyncPromise >> isFulfilled [
	"Report is the receiver is currently fulfilled"

	^state == #Fulfilled
]

{ #category : #testing }
GtRsrEvaluatorAsyncPromise >> isResolved [
	"Report if the receiver is currently resolved."

	^self isFulfilled or: [self isBroken]
]

{ #category : #accessing }
GtRsrEvaluatorAsyncPromise >> resolvedValue [
	self assert: [ value ~~ self ].
	
	^ value
]

{ #category : #resolving }
GtRsrEvaluatorAsyncPromise >> resolveWithEvaluationResult: evaluationResult [ 
	evaluationResult isEvaluationCancelledResult 
		ifTrue: [ self breakWithEvaluationResult: evaluationResult ]
		ifFalse: [ self fulfillWithEvaluationResult: evaluationResult ]
]

{ #category : #actions }
GtRsrEvaluatorAsyncPromise >> resumeEvaluation [
	| resumedEvaluationResultData |
	self assert: [ executionContext notNil ].
	
	resumedEvaluationResultData := executionContext resumeAsyncComputation.
	
	self assert: (GtGemstoneEvaluationResumedResult 
		isSerializedDataForCurrentClass: resumedEvaluationResultData).
	^ GtGemstoneEvaluationResult 
		createEvaluationResultFromData: resumedEvaluationResultData.
]

{ #category : #private }
GtRsrEvaluatorAsyncPromise >> retrieveEvaluationResultFromContext: anEvaluationContext [
	| rawEvaluationResultData evaluationResult |
	rawEvaluationResultData := anEvaluationContext wait.
	
	evaluationResult := self 
		createEvaluationResultFromData: rawEvaluationResultData.
	self gemStoneSession ifNotNil: [ :aGemStoneSession |
		evaluationResult gtPharoProxyInitializeWithSession: aGemStoneSession ].
	 
	evaluationResult hasEvaluationException ifTrue: [ 
		evaluationResult := evaluationResult signalGemStoneDebuggerFromPromise: self.
		self gemStoneSession ifNotNil: [ :aGemStoneSession |
			evaluationResult gtPharoProxyInitializeWithSession: aGemStoneSession ] ].
			
	^ evaluationResult
]

{ #category : #actions }
GtRsrEvaluatorAsyncPromise >> serializationStrategy: aSerializationStrategy [ 
	serializationStrategy := aSerializationStrategy 
]

{ #category : #accessing }
GtRsrEvaluatorAsyncPromise >> sessionDescription [
	^ gemStoneSession 
		ifNil: [  '<missing session>']
		ifNotNil: [ :aSession |
			 aSession name, '  ', aSession statusDescription ]
]

{ #category : #actions }
GtRsrEvaluatorAsyncPromise >> stopEvaluation [
	| retryCount |
	
	"If the user attempts to stop execution while we are waiting for the execution context, wait a bit ang give the remote execution a chance to start. We cannot stop the remote execution unless we have a proxy to the execution context."
	retryCount := 5.
	[ executionContext isNil and: [ retryCount > 0 ] ] whileTrue: [
		100 milliseconds wait.
		retryCount := retryCount -1.
	].
	
	executionContext ifNil: [
		Error signal: 'Failed to stop the remote execution. Could not get a proxy to the evaluation context for the remote execution. Try and stop the execution again' ].
	
	^ executionContext terminateAsyncComputation
]

{ #category : #accessing }
GtRsrEvaluatorAsyncPromise >> value [

	value == self ifTrue: [ 
		evaluationMutex critical: [ self wait ] ].
	^ value
]

{ #category : #private }
GtRsrEvaluatorAsyncPromise >> wait [
	| evaluationResult |
	
	executionContext := gtRsrEvaluatorPromise value.
	
	[
		evaluationResult := self 
			retrieveEvaluationResultFromContext: executionContext.
	] doWhileTrue: [ 
		evaluationResult isResumedExecutionResult  ].
	
	self resolveWithEvaluationResult: evaluationResult.
	
	^ value
]
