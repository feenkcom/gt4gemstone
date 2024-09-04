Class {
	#name : #GtGemStoneSnippetCoderViewModel,
	#superclass : #GtGemStoneSourceCoderViewModel,
	#instVars : [
		'session',
		'hasAsyncExecution'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #callbacks }
GtGemStoneSnippetCoderViewModel >> actOnAsyncExecutionCompleted [
	self markAsyncExecutionStartedCompleted.
	self notifyAsyncExecutionCompleted.
	
	self enableExecutionAction
]

{ #category : #actions }
GtGemStoneSnippetCoderViewModel >> disableExecutionAction [
	| executionActions |
	
	executionActions := self mainActions
		select: [ :each | each isGemStoneExecutionAction ].
	executionActions do: [ :each |
		each disableAction ].
	
	self announce: GtTextualCoderViewModelMainActionsChanged new.
]

{ #category : #actions }
GtGemStoneSnippetCoderViewModel >> enableExecutionAction [
	| executionActions |
	
	executionActions := self mainActions
		select: [ :each | each isGemStoneExecutionAction ].
	executionActions do: [ :each |
		each enableAction ].
	
	self announce: GtTextualCoderViewModelMainActionsChanged new.
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> evaluationContext [
	^ super evaluationContext
		executionStrategy: executionStrategy;
		session: session.
]

{ #category : #testing }
GtGemStoneSnippetCoderViewModel >> hasAsyncExecution [
	^ hasAsyncExecution ifNil: [ false ]
]

{ #category : #testing }
GtGemStoneSnippetCoderViewModel >> hasDeclaredGlobalNamed: aVariableName [
	^ false
]

{ #category : #testing }
GtGemStoneSnippetCoderViewModel >> hasDeclaredVariableNamed: aVariableName [
	^ false
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> localBehavior [
	^ self selfObject 
		ifNil: [ super localBehavior ] 
		ifNotNil: [ :anObject |
			"It is possible to add GemStone snippets when inspecting local objects."
			(anObject asGtProxyObject isKindOf: GtRsrProxyServiceClient)
			 	ifTrue: [ anObject asGtProxyObject remoteClass 
					ifNil: [ super localBehavior]
					ifNotNil: [ :aClassName |
					aClassName asClassIfAbsent: [ super localBehavior ] ] ]
				ifFalse: [ anObject class ] ]
]

{ #category : #configuration }
GtGemStoneSnippetCoderViewModel >> markAsyncExecutionStarted [
	hasAsyncExecution := true.
]

{ #category : #configuration }
GtGemStoneSnippetCoderViewModel >> markAsyncExecutionStartedCompleted [
	hasAsyncExecution := false
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> newCompletionStrategy [
	| strategy |
	strategy := super newCompletionStrategy
		isMethod: false;
		hasImplicitVariables: true;
		yourself.
	^ strategy
]

{ #category : #notifications }
GtGemStoneSnippetCoderViewModel >> notifyAsyncExecutionCompleted [
	self announce: GtGemStoneCoderAsyncExecutionCompletedAnnouncement
]

{ #category : #notifications }
GtGemStoneSnippetCoderViewModel >> notifyAsyncExecutionStarted [
	self announce: GtGemStoneCoderAsyncExecutionStartedAnnouncement
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> session: aGtSession [

	session := aGtSession
]

{ #category : #'as yet unclassified' }
GtGemStoneSnippetCoderViewModel >> updatWithAsyncExecution: aPromiseResolution [
	self markAsyncExecutionStarted.
	self notifyAsyncExecutionStarted.
	
	self disableExecutionAction.
	
	aPromiseResolution announcer weak
		when: GtGemStoneAsyncPromiseResolutionCompletedAnnouncement
		send: #actOnAsyncExecutionCompleted
		to: self. 
		
	aPromiseResolution isResolvingCompleted ifTrue: [
		"Make sure we always update the state of this coder after the async
		computation finished. We might hand the termination of the async 
		computation twice if we both register the announcement and the
		computation finished immediately after."
		self actOnAsyncExecutionCompleted ]
]
