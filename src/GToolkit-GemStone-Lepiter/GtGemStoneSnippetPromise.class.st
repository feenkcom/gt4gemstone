Class {
	#name : #GtGemStoneSnippetPromise,
	#superclass : #Object,
	#instVars : [
		'gtRsrEvaluatorPromise',
		'snippetCoderModel',
		'coderEvaluationContext',
		'value',
		'executionContext',
		'mutex'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

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
GtGemStoneSnippetPromise >> hasResult [
	^ value ~~ self
]

{ #category : #initialization }
GtGemStoneSnippetPromise >> initialize [
	super initialize.
	
	value := self.
	mutex := Mutex new.
]

{ #category : #testing }
GtGemStoneSnippetPromise >> isGtEvaluationException [

	^ gtRsrEvaluatorPromise isGtEvaluationException
]

{ #category : #testing }
GtGemStoneSnippetPromise >> isResolved [

	^ gtRsrEvaluatorPromise isResolved and: [
		value ~~ self ]
]

{ #category : #private }
GtGemStoneSnippetPromise >> resolveWithComputedResult: computedResult [ 
	computedResult associationsDo: [ :binding |
		(snippetCoderModel pharoBindings bindingOf: binding key asSymbol) 
			value: (binding value asGtBareProxyObject) ].

	value := (computedResult
		at: 'snippetResult'
		ifPresent: [ :obj | 
			coderEvaluationContext serializationStrategy
				ifNil: [ obj ]
				ifNotNil: [ :strategy | obj
					proxyPerform: #yourself serializationStrategy: strategy ] ]
		ifAbsent: [ self error: 'no result' ]) asGtBareProxyObject.
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
	| rawEvaluationResultData evaluationResult computedResult |
	
	executionContext := gtRsrEvaluatorPromise value.
	rawEvaluationResultData := executionContext wait.
	
	evaluationResult := self createEvaluationResultFromData: rawEvaluationResultData.
	self gemStoneSession ifNotNil: [ :aGemStoneSession |
		evaluationResult gtPharoProxyInitializeWithSession: aGemStoneSession ].
	 
	evaluationResult hasEvaluationException ifTrue: [ 
		evaluationResult := evaluationResult signalGemStoneDebugger.
		self gemStoneSession ifNotNil: [ :aGemStoneSession |
			evaluationResult gtPharoProxyInitializeWithSession: aGemStoneSession ]. ].
	
	computedResult := evaluationResult computedResult.
	computedResult := gtRsrEvaluatorPromise 
		basicDeserializeResult: evaluationResult computedResult.
	
	self resolveWithComputedResult: computedResult
]
