Extension { #name : #GtPharoMethodCoderViewModel }

{ #category : #'*GToolkit-GemStone-Lepiter' }
GtPharoMethodCoderViewModel >> createGemStoneSnippetExecutionContext [
	^ GtGemStoneSnippetCoderEvaluationContext new
		instanceVariableNames: #();
		coder: self coderModel;
		requesterObject: (GtCoderViewModelRequester new coderViewModel: self);
		receiverObject: nil;
		pharoBindings: GtSharedVariablesBindings new
]

{ #category : #'*GToolkit-GemStone-Lepiter' }
GtPharoMethodCoderViewModel >> doItAndGoAsynchronousGemStone: aSelectionInterval inSession: aGemStoneSession [
	| gemStoneSnippetEvaluationContext |
	gemStoneSnippetEvaluationContext := self createGemStoneSnippetExecutionContext.
	gemStoneSnippetEvaluationContext session: aGemStoneSession.
	gemStoneSnippetEvaluationContext
		from: aSelectionInterval first
		to: aSelectionInterval last.
		
	^ self doItAndGoAsynchronousInGemStoneInContext: gemStoneSnippetEvaluationContext
]

{ #category : #'*GToolkit-GemStone-Lepiter' }
GtPharoMethodCoderViewModel >> doItAndGoAsynchronousInGemStoneInContext: aSnippetEvaluationContext [ 
	| executionResult |
	
	aSnippetEvaluationContext 
		executionStrategy: GtGemStoneSnippetAsynchronousExecutionStrategy new.
	executionResult := self coder 
		doItAndGoAsynchronousInGemStoneInContext: aSnippetEvaluationContext.
	
	executionResult isSyntaxError ifTrue: [
		"No update needed in case the result is a syntax error."
		^ executionResult ].
		
	"To implement"
	"self updatWithAsyncExecution: executionResult value."
	
	^ executionResult
]
