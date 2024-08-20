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

{ #category : #accessing }
GtGemStoneSnippetPromise >> coderEvaluationContext [
	^ coderEvaluationContext
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> coderEvaluationContext: anObject [
	coderEvaluationContext := anObject
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

{ #category : #accessing }
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

{ #category : #accessing }
GtGemStoneSnippetPromise >> stopEvaluation [

	^ executionContext terminate
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> value [

	value == self ifTrue: [ 
		mutex critical: [ self wait ] ].
	^ value
]

{ #category : #private }
GtGemStoneSnippetPromise >> wait [
	| result |
	
	executionContext := gtRsrEvaluatorPromise value.
	result := executionContext wait.

	"We get here in case we terminate the remote process running the async computation and signal the semaphore on which the computation runs. A different way to implement this would be to do a low-level call and get back a result object indicating that the process was terminated. "
	result ifNil: [ 
		value := nil.
		^ self ].
	
	result associationsDo: [ :binding |
		(snippetCoderModel pharoBindings bindingOf: binding key asSymbol) 
			value: (binding value asGtBareProxyObject) ].

	value := (result
		at: 'snippetResult'
		ifPresent: [ :obj | 
			coderEvaluationContext serializationStrategy
				ifNil: [ obj ]
				ifNotNil: [ :strategy | obj
					proxyPerform: #yourself serializationStrategy: strategy ] ]
		ifAbsent: [ self error: 'no result' ]) asGtBareProxyObject.
]
