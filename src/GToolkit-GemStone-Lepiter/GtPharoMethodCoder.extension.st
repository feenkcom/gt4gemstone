Extension { #name : #GtPharoMethodCoder }

{ #category : #'*GToolkit-GemStone-Lepiter' }
GtPharoMethodCoder >> doItAndGoAsynchronousInGemStoneInContext: aSnippetEvaluationContext [ 

	^ self 
		gemStoneEvaluate: [ :thisCoder | thisCoder currentSourceString ]
		decorated: [ :aSourceString | aSourceString ]
		inContext: aSnippetEvaluationContext
		thenDo: [ :anEvaluationResult | 
			self notifyEvaluatedWithResult: anEvaluationResult.
			self
				notifyObjectSpawnFromEvaluationResult: anEvaluationResult
				requesterObject: aSnippetEvaluationContext requesterObject ]
]

{ #category : #'*GToolkit-GemStone-Lepiter' }
GtPharoMethodCoder >> gemStoneEvaluate: aSourceStringOrBlock decorated: aSourceCodeDecorator inContext: aSourceCoderEvaluationContext thenDo: aThenBlock [
	"Evaluate a given source code"
	| aCompleteSourceString aSourceString aSourceInterval aResult aDecoratedSourceString |
	
	"we can not wrap everything in a critical: because if there is an exception while evaluating
	the source code the current running process will be suspended, meaning that the very next evaluation
	will indefinitely wait when trying to enter a critical section."
	self critical: [
		aCompleteSourceString := aSourceStringOrBlock isClosure
			ifTrue: [ aSourceStringOrBlock cull: self ]
			ifFalse: [ aSourceStringOrBlock ].

		aSourceString := aSourceCoderEvaluationContext sourceInterval computeSourceString: aCompleteSourceString.
		aSourceInterval := aSourceCoderEvaluationContext sourceInterval computeSourceInterval: aCompleteSourceString ].

	aDecoratedSourceString := aSourceCodeDecorator value: aSourceString.
	
	aSourceCoderEvaluationContext
		sourceString: aCompleteSourceString;
		evaluatedSourceString: aSourceString;
		evaluatedInterval: aSourceInterval.

	aResult := self evaluateBlock: [ 
		self
			gemStoneprimitiveEvaluate: aDecoratedSourceString
			inContext: aSourceCoderEvaluationContext
			onFailDo: [
				| aResultWithSyntaxError |

				aResultWithSyntaxError := GtSourceCoderEvaluationResultWithSyntaxError new
					evaluationContext: aSourceCoderEvaluationContext.
				aThenBlock cull: aResultWithSyntaxError.
				^ aResultWithSyntaxError ] ]
		onErrorDo: [ :aResultWithError |
			aResultWithError
				evaluationContext: aSourceCoderEvaluationContext ].

	aResult evaluationContext: aSourceCoderEvaluationContext.
	aThenBlock cull: aResult.
	^ aResult
]

{ #category : #'*GToolkit-GemStone-Lepiter' }
GtPharoMethodCoder >> gemStoneprimitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	"Evaluate the supplied script in GemStone."
	| snippetEvaluator |
	
	snippetEvaluator := GtGemStoneSnippetCoderEvaluator new
		coderModel: self.
	
	^ snippetEvaluator
			primitiveEvaluate: aSourceString 
			inContext: aGtSourceCoderEvaluationContext 
			onFailDo: anEvaluationFailBlock
]
