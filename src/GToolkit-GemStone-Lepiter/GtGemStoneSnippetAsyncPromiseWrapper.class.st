Class {
	#name : #GtGemStoneSnippetAsyncPromiseWrapper,
	#superclass : #GtGemStoneAsyncPromiseWrapper,
	#instVars : [
		'pharoBindings'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSnippetAsyncPromiseWrapper >> pharoBindings: anObject [
	pharoBindings := anObject
]

{ #category : #private }
GtGemStoneSnippetAsyncPromiseWrapper >> wait [
	| computedResult |
	
	computedResult := gtRsrAsycPromise wait.
	gtRsrAsycPromise isFulfilled ifFalse: [ ^ false ].
	
	computedResult associationsDo: [ :binding |
		(pharoBindings bindingOf: binding key asSymbol) 
			value: (binding value asGtBareProxyObject) ].
			
	value := (computedResult
		at: #snippetResult
		ifPresent: [ :obj | 
			serializationStrategy
				ifNil: [ obj ]
				ifNotNil: [ :strategy | obj
					proxyPerform: #yourself serializationStrategy: strategy ] ]
		ifAbsent: evaluationFailBlock) asGtBareProxyObject.
	
	^ value
]
