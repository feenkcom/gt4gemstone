Class {
	#name : #GtGemStoneSnippetAsynchronousExecutionStrategy,
	#superclass : #GtGemStoneSnippetExecutionStrategy,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #execution }
GtGemStoneSnippetAsynchronousExecutionStrategy >> evaluate: remoteScript inSession: gemstoneSession context: aGtSourceCoderEvaluationContext remoteBindings: remoteBindings pharoBindings: pharoBindings onFailDo: anEvaluationFailBlock coderModel: aCoderModel [
	| gtRsrEvaluatorPromiseWithContext |

	gtRsrEvaluatorPromiseWithContext := gemstoneSession 
		evaluateAsync: remoteScript 
		for: aGtSourceCoderEvaluationContext receiverObject asGtProxyObject
		bindings: remoteBindings.

	^ GtGemStoneSnippetPromiseResolution new 
		snippetPromise: (GtGemStoneSnippetPromise new 
			snippetCoderModel: aCoderModel;
			coderEvaluationContext: aGtSourceCoderEvaluationContext;
			gtRsrEvaluatorPromise: gtRsrEvaluatorPromiseWithContext)
]
