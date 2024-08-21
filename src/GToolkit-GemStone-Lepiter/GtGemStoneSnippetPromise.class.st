Class {
	#name : #GtGemStoneSnippetPromise,
	#superclass : #Object,
	#instVars : [
		'gtRsrEvaluatorPromise',
		'snippetCoderModel',
		'coderEvaluationContext',
		'value',
		'executionContext',
		'mutex',
		'state'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

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

{ #category : #accessing }
GtGemStoneSnippetPromise >> coderEvaluationContext [
	^ coderEvaluationContext
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> coderEvaluationContext: anObject [
	coderEvaluationContext := anObject
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
	computedResult := gtRsrEvaluatorPromise 
		basicDeserializeResult: evaluationResult computedResult.
		
	self fullfilWithComputedResult: computedResult
]

{ #category : #resolving }
GtGemStoneSnippetPromise >> fullfilWithComputedResult: computedResult [ 
	computedResult associationsDo: [ :binding |
		(snippetCoderModel pharoBindings bindingOf: binding key asSymbol) 
			value: (binding value asGtBareProxyObject) ].

	self fulfill: (computedResult
		at: 'snippetResult'
		ifPresent: [ :obj | 
			coderEvaluationContext serializationStrategy
				ifNil: [ obj ]
				ifNotNil: [ :strategy | obj
					proxyPerform: #yourself serializationStrategy: strategy ] ]
		ifAbsent: [ self error: 'no result' ]) asGtBareProxyObject.
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> gemStoneSession [
	^ gtRsrEvaluatorPromise gtSession
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> gtRsrEvaluatorPromise [
	^ gtRsrEvaluatorPromise
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> gtRsrEvaluatorPromise: anObject [
	gtRsrEvaluatorPromise := anObject
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

{ #category : #testing }
GtGemStoneSnippetPromise >> isBroken [
	"Report if the receiver is currently broken"

	^state == #Broken
]

{ #category : #testing }
GtGemStoneSnippetPromise >> isFulfilled [
	"Report is the receiver is currently fulfilled"

	^state == #Fulfilled
]

{ #category : #testing }
GtGemStoneSnippetPromise >> isGtEvaluationException [

	^ gtRsrEvaluatorPromise isGtEvaluationException
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

{ #category : #accessing }
GtGemStoneSnippetPromise >> sessionDescription [
	^ gtRsrEvaluatorPromise sessionDescription
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> snippetCoderModel [
	^ snippetCoderModel
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> snippetCoderModel: anObject [
	snippetCoderModel := anObject
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
	| rawEvaluationResultData evaluationResult |
	
	executionContext := gtRsrEvaluatorPromise value.
	rawEvaluationResultData := executionContext wait.
	
	evaluationResult := self createEvaluationResultFromData: rawEvaluationResultData.
	self gemStoneSession ifNotNil: [ :aGemStoneSession |
		evaluationResult gtPharoProxyInitializeWithSession: aGemStoneSession ].
	 
	evaluationResult hasEvaluationException ifTrue: [ 
		evaluationResult := evaluationResult signalGemStoneDebugger.
		self gemStoneSession ifNotNil: [ :aGemStoneSession |
			evaluationResult gtPharoProxyInitializeWithSession: aGemStoneSession ] ].
	
	self resolveWithEvaluationResult: evaluationResult
]
