Class {
	#name : #GtGemStoneSnippetPromise,
	#superclass : #Object,
	#instVars : [
		'gtRsrEvaluatorPromise',
		'value',
		'executionContext',
		'mutex',
		'state',
		'gemStoneSession',
		'serializationStrategy'
	],
	#category : #'GToolkit-GemStone-Pharo-Promises'
}

{ #category : #accessing }
GtGemStoneSnippetPromise >> basicDeserializeResult: aResult [
	^ (self class environment 
		at: serializationStrategy) new 
			deserialize: aResult.
]

{ #category : #resolving }
GtGemStoneSnippetPromise >> break: aReason [ 
	value := aReason.
	state := #Broken.
]

{ #category : #resolving }
GtGemStoneSnippetPromise >> breakWithEvaluationResult: evaluationResult [ 
	self break: evaluationResult.
]

{ #category : #testing }
GtGemStoneSnippetPromise >> canStopExecution [
	^ executionContext notNil and: [
		self isResolved not ]
]

{ #category : #utils }
GtGemStoneSnippetPromise >> createEvaluationResultFromData: aDictionaryOrObject [ 
	"Instantiate an evaluation result object from the given object."

	^ GtGemstoneEvaluationResult 
		createEvaluationResultFromData: aDictionaryOrObject 
]

{ #category : #resolving }
GtGemStoneSnippetPromise >> fulfill: anObject [
	"Fulfill the receiver"

	value := anObject.
	state := #Fulfilled
]

{ #category : #resolving }
GtGemStoneSnippetPromise >> fulfillWithEvaluationResult: evaluationResult [ 
	| computedResult |
	computedResult := evaluationResult computedResult.
	
	self fullfilWithComputedResult: computedResult
]

{ #category : #resolving }
GtGemStoneSnippetPromise >> fullfilWithComputedResult: computedResult [ 
	| deserializedResult |
	deserializedResult := self 
		basicDeserializeResult: computedResult.
		
	self fulfill: deserializedResult
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> gemStoneSession [
	^ gemStoneSession
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> gemStoneSession: aGemStoneSession [
	gemStoneSession := aGemStoneSession
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> gtRsrEvaluatorPromise [
	^ gtRsrEvaluatorPromise
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> gtRsrEvaluatorPromise: anEvaluatorPromise [
	gtRsrEvaluatorPromise := anEvaluatorPromise
]

{ #category : #testing }
GtGemStoneSnippetPromise >> hasEvaluationContext [
	^ executionContext notNil
]

{ #category : #testing }
GtGemStoneSnippetPromise >> hasValidResult [
	^ self isFulfilled
]

{ #category : #initialization }
GtGemStoneSnippetPromise >> initialize [
	super initialize.
	
	value := self.
	mutex := Mutex new.
	state := #PendingResolution.
]

{ #category : #actions }
GtGemStoneSnippetPromise >> interruptEvaluation [
	self assert: [ executionContext notNil ].
	
	^ executionContext interruptAsyncComputation
]

{ #category : #testing }
GtGemStoneSnippetPromise >> isBroken [
	"Report if the receiver is currently broken"

	^state == #Broken
]

{ #category : #testing }
GtGemStoneSnippetPromise >> isForAsyncExecution [
	^ true 
]

{ #category : #testing }
GtGemStoneSnippetPromise >> isFulfilled [
	"Report is the receiver is currently fulfilled"

	^state == #Fulfilled
]

{ #category : #testing }
GtGemStoneSnippetPromise >> isResolved [
	"Report if the receiver is currently resolved."

	^self isFulfilled or: [self isBroken]
]

{ #category : #resolving }
GtGemStoneSnippetPromise >> resolveWithEvaluationResult: evaluationResult [ 
	evaluationResult isEvaluationCancelledResult 
		ifTrue: [ self breakWithEvaluationResult: evaluationResult ]
		ifFalse: [ self fulfillWithEvaluationResult: evaluationResult ]
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> resolvedValue [
	self assert: [ value ~~ self ].
	
	^ value
]

{ #category : #actions }
GtGemStoneSnippetPromise >> resumeEvaluation [
	| resumedEvaluationResultData |
	self assert: [ executionContext notNil ].
	
	resumedEvaluationResultData := executionContext resumeAsyncComputation.
	
	self assert: (GtGemstoneEvaluationResumedResult 
		isSerializedDataForCurrentClass: resumedEvaluationResultData).
	^ GtGemstoneEvaluationResult 
		createEvaluationResultFromData: resumedEvaluationResultData.
]

{ #category : #private }
GtGemStoneSnippetPromise >> retrieveEvaluationResultFromContext: anEvaluationContext [
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
GtGemStoneSnippetPromise >> serializationStrategy: aSerializationStrategy [ 
	serializationStrategy := aSerializationStrategy 
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> sessionDescription [
	^ gemStoneSession 
		ifNil: [  '<missing session>']
		ifNotNil: [ :aSession |
			 aSession name, '  ', aSession statusDescription ]
]

{ #category : #actions }
GtGemStoneSnippetPromise >> stopEvaluation [
	self assert: [ executionContext notNil ].
	
	^ executionContext terminateAsyncComputation
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> value [

	value == self ifTrue: [ 
		mutex critical: [ self wait ] ].
	^ value
]

{ #category : #private }
GtGemStoneSnippetPromise >> wait [
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
