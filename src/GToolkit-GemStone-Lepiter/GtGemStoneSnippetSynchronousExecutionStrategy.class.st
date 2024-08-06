Class {
	#name : #GtGemStoneSnippetSynchronousExecutionStrategy,
	#superclass : #GtGemStoneSnippetExecutionStrategy,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #execution }
GtGemStoneSnippetSynchronousExecutionStrategy >> evaluate: remoteScript inSession: gemstoneSession context: aGtSourceCoderEvaluationContext remoteBindings: remoteBindings pharoBindings: pharoBindings onFailDo: anEvaluationFailBlock coderModel: aCoderModel [
	| result |

	result := gemstoneSession 
		evaluateAndWait: remoteScript 
		for: aGtSourceCoderEvaluationContext receiverObject asGtProxyObject
		bindings: remoteBindings.
	result associationsDo: [ :binding |
		(pharoBindings bindingOf: binding key asSymbol) 
			value: (binding value asGtBareProxyObject) ].

	^ (result
		at: 'snippetResult'
		ifPresent: [ :obj | 
			aGtSourceCoderEvaluationContext serializationStrategy
				ifNil: [ obj ]
				ifNotNil: [ :strategy | obj
					proxyPerform: #yourself serializationStrategy: strategy ] ]
		ifAbsent: anEvaluationFailBlock) asGtBareProxyObject
]
