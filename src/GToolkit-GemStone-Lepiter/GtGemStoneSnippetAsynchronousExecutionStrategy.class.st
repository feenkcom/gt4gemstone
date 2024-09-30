Class {
	#name : #GtGemStoneSnippetAsynchronousExecutionStrategy,
	#superclass : #GtGemStoneSnippetExecutionStrategy,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #testing }
GtGemStoneSnippetAsynchronousExecutionStrategy >> canRunComputationInSession: aGemStoneSession [
	^ aGemStoneSession hasRegisteredAsyncExecution not
]

{ #category : #execution }
GtGemStoneSnippetAsynchronousExecutionStrategy >> evaluate: remoteScript inSession: gemstoneSession context: aGtSourceCoderEvaluationContext remoteBindings: remoteBindings pharoBindings: pharoBindings onFailDo: anEvaluationFailBlock coderModel: aCoderModel [
	| asyncPromise snippetPromiseWrapper promiseResolution |

	asyncPromise := gemstoneSession 
		evaluateAsync: remoteScript 
		for: aGtSourceCoderEvaluationContext receiverObject asGtProxyObject
		bindings: remoteBindings.
		
	snippetPromiseWrapper := GtGemStoneSnippetAsyncPromiseWrapper new
		gtRsrAsycPromise: asyncPromise;
		serializationStrategy: aGtSourceCoderEvaluationContext serializationStrategy;
		pharoBindings: pharoBindings;
		evaluationFailBlock:  anEvaluationFailBlock.
		
	promiseResolution := GtGemStoneAsyncPromiseResolution new 
		asyncPromise: snippetPromiseWrapper;
		ensureExecuting;
		yourself.
	"Not the ideal place to do this, but should work for now"
	gemstoneSession addAsyncExecution: (GtGemStoneAsyncExecution new
		asyncPromise: asyncPromise;
		promiseResolution: promiseResolution).
		
	^ promiseResolution
]
