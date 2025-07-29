Class {
	#name : #GtGemStoneSnippetCoderViewModel,
	#superclass : #GtGemStoneSourceCoderViewModel,
	#instVars : [
		'hasAsyncExecution',
		'sessionLocator',
		'pharoBindings'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #callbacks }
GtGemStoneSnippetCoderViewModel >> actOnAsyncExecutionFinished [
	self markAsyncExecutionStartedCompleted.
	self notifyAsyncExecutionCompleted.
	
	self enableExecutionAction
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> asynchronusExecutionStrategy [
	^ GtGemStoneSnippetAsynchronousExecutionStrategy new
]

{ #category : #actions }
GtGemStoneSnippetCoderViewModel >> disableExecutionAction [
	self mainActions
		select: [ :each | each isGemStoneExecutionAction ]
		thenDo: [ :each |each disableAction ].
	
	self announce: GtTextualCoderViewModelMainActionsChanged new.
]

{ #category : #actions }
GtGemStoneSnippetCoderViewModel >> enableExecutionAction [
	self mainActions
		select: [ :each | each isGemStoneExecutionAction ]
		thenDo: [ :each | each enableAction ].
	
	self announce: GtTextualCoderViewModelMainActionsChanged new.
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> evaluationContext [
	^ super evaluationContext
		session: self session;
		pharoBindings: pharoBindings
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

{ #category : #testing }
GtGemStoneSnippetCoderViewModel >> hasRunningSession [
	^ sessionLocator 
		existingSessionDo: [ :aSession |
			aSession isRunning ]
		ifNone: [ false ]
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
GtGemStoneSnippetCoderViewModel >> pharoBindings [
	^ pharoBindings
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> pharoBindings: anObject [
	pharoBindings := anObject
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> session [
	^ sessionLocator asGemStoneSession
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> sessionLocator [
	^ sessionLocator
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> sessionLocator: anObject [
	sessionLocator := anObject
]

{ #category : #'as yet unclassified' }
GtGemStoneSnippetCoderViewModel >> updatWithAsyncExecution: aPromiseResolution [
	self markAsyncExecutionStarted.
	self notifyAsyncExecutionStarted.
	self disableExecutionAction.
	
	aPromiseResolution announcer weak
		when: GtGemStoneAsyncPromiseResolutionFinishedAnnouncement
		send: #actOnAsyncExecutionFinished
		to: self. 
		
	aPromiseResolution isResolvingCompleted ifTrue: [
		"Make sure we always update the state of this coder after the async
		computation finished. We might hand the termination of the async 
		computation twice if we both register the announcement and the
		computation finished immediately after."
		self actOnAsyncExecutionFinished ]
]
