Class {
	#name : #GtGemStoneSnippetSynchronousExecutionStrategy,
	#superclass : #GtGemStoneSnippetExecutionStrategy,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #testing }
GtGemStoneSnippetSynchronousExecutionStrategy >> canRunComputationInSession: aGemStoneSession [
	^ aGemStoneSession hasRunningAsyncExecution not
]

{ #category : #execution }
GtGemStoneSnippetSynchronousExecutionStrategy >> evaluate: remoteScript inSession: gemstoneSession context: aGtSourceCoderEvaluationContext remoteBindings: remoteBindings pharoBindings: pharoBindings onFailDo: anEvaluationFailBlock coderModel: aCoderModel [
	| result |

	result := gemstoneSession 
		evaluateAndWait: remoteScript 
		for: aGtSourceCoderEvaluationContext receiverObject asGtProxyObject
		bindings: remoteBindings.
		
	^ self 
		updateWithRemoteComputationResult: result 
		pharoBindings: pharoBindings  
		serializationStrategy: aGtSourceCoderEvaluationContext serializationStrategy 
		onFailDo: anEvaluationFailBlock.
]
