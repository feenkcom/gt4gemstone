Class {
	#name : #GtGemStoneSnippetPromise,
	#superclass : #Object,
	#instVars : [
		'gtRsrEvaluatorPromise',
		'snippetCoderModel',
		'coderEvaluationContext',
		'value',
		'executionContext'
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
GtGemStoneSnippetPromise >> gtRsrEvaluatorPromise [
	^ gtRsrEvaluatorPromise
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> gtRsrEvaluatorPromise: anObject [
	gtRsrEvaluatorPromise := anObject
]

{ #category : #ui }
GtGemStoneSnippetPromise >> gtViewResultFor: aView [
	<gtView>

	^ aView explicit
		title: 'Result';
		priority: 10;
		stencil: [ 
			GtGemStoneEvaluationMonitorElement new
				snippetPromise: self ].
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> initialize [

	super initialize.
	value := self.
]

{ #category : #accessing }
GtGemStoneSnippetPromise >> isGtEvaluationException [

	^ gtRsrEvaluatorPromise isGtEvaluationException
]

{ #category : #testing }
GtGemStoneSnippetPromise >> isResolved [

	^ gtRsrEvaluatorPromise isResolved
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

	value == self ifTrue: [ self wait ].
	^ value
]

{ #category : #private }
GtGemStoneSnippetPromise >> wait [
	| result |
	
	executionContext := gtRsrEvaluatorPromise value.
	result := executionContext wait.
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
		ifAbsent: [ self error: 'no result' ]) asGtBareProxyObject
]
