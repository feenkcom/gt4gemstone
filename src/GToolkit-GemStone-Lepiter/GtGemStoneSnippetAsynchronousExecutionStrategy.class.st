Class {
	#name : #GtGemStoneSnippetAsynchronousExecutionStrategy,
	#superclass : #GtGemStoneSnippetExecutionStrategy,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #execution }
GtGemStoneSnippetAsynchronousExecutionStrategy >> evaluate: remoteScript inSession: gemstoneSession context: aGtSourceCoderEvaluationContext remoteBindings: remoteBindings pharoBindings: pharoBindings onFailDo: anEvaluationFailBlock coderModel: aCoderModel [
	| asyncPromise snippetPromiseWrapper |

	asyncPromise := gemstoneSession 
		evaluateAsync: remoteScript 
		for: aGtSourceCoderEvaluationContext receiverObject asGtProxyObject
		bindings: remoteBindings.
		
	snippetPromiseWrapper := GtGemStoneSnippetAsyncPromiseWrapper new
		gtRsrAsycPromise: asyncPromise;
		serializationStrategy: aGtSourceCoderEvaluationContext serializationStrategy;
		snippetCoderModel: aCoderModel;
		evaluationFailBlock:  anEvaluationFailBlock.
		
	^ GtGemStoneAsyncPromiseResolution new 
		snippetPromise: snippetPromiseWrapper;
		ensureExecuting;
		yourself
]
