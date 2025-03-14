Class {
	#name : #GtGemStoneSnippetExecutionStrategy,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #testing }
GtGemStoneSnippetExecutionStrategy >> canRunComputationInSession: aGemStoneSession [
	self subclassResponsibility
]

{ #category : #utils }
GtGemStoneSnippetExecutionStrategy >> updateWithRemoteComputationResult: aComputedResult pharoBindings: pharoBindings [ 

	aComputedResult associationsDo: [ :binding |
		(pharoBindings bindingOf: binding key asSymbol) 
			value: (binding value asGtBareProxyObject) ].
]

{ #category : #utils }
GtGemStoneSnippetExecutionStrategy >> updateWithRemoteComputationResult: aComputedResult pharoBindings: pharoBindings  serializationStrategy: aSerializationStrategy onFailDo: anEvaluationFailBlock [

	self updateWithRemoteComputationResult: aComputedResult pharoBindings: pharoBindings .

	^ (aComputedResult
		at: #snippetResult
		ifPresent: [ :obj | 
			aSerializationStrategy
				ifNil: [ obj ]
				ifNotNil: [ :strategy | obj
					proxyPerform: #yourself serializationStrategy: strategy ] ]
		ifAbsent: anEvaluationFailBlock) asGtBareProxyObject
]
