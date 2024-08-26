Class {
	#name : #GtGemStoneSnippetAsynchronousExecutionStrategy,
	#superclass : #GtGemStoneSnippetExecutionStrategy,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #execution }
GtGemStoneSnippetAsynchronousExecutionStrategy >> evaluate: remoteScript inSession: gemstoneSession context: aGtSourceCoderEvaluationContext remoteBindings: remoteBindings pharoBindings: pharoBindings onFailDo: anEvaluationFailBlock coderModel: aCoderModel [
	| gtRsrEvaluatorPromiseWithContext snippetPromise |

	gtRsrEvaluatorPromiseWithContext := gemstoneSession 
		evaluateAsync: remoteScript 
		for: aGtSourceCoderEvaluationContext receiverObject asGtProxyObject
		bindings: remoteBindings.

	snippetPromise := GtGemStoneSnippetPromise new 
		snippetCoderModel: aCoderModel;
		serializationStrategy: aGtSourceCoderEvaluationContext serializationStrategy;
		gtRsrEvaluatorPromise: gtRsrEvaluatorPromiseWithContext.
		
	^ GtGemStoneSnippetPromiseResolution new 
		snippetPromise: snippetPromise
]
