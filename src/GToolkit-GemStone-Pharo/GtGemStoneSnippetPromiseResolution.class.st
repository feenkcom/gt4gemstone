Class {
	#name : #GtGemStoneSnippetPromiseResolution,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'resolutionProcess',
		'snippetPromise',
		'startTimestamp',
		'endTimestamp',
		'state',
		'fulfilledAction'
	],
	#category : #'GToolkit-GemStone-Pharo-Promises'
}

{ #category : #accessing }
GtGemStoneSnippetPromiseResolution >> announcer [
	^ announcer
]

{ #category : #testing }
GtGemStoneSnippetPromiseResolution >> canStopExecution [
	^ self isResolvingRunning and: [
		snippetPromise canStopExecution ]
]

{ #category : #accessing }
GtGemStoneSnippetPromiseResolution >> duration [ 
	^ (startTimestamp notNil and: [
		endTimestamp notNil ]) 
			ifTrue: [ endTimestamp - startTimestamp] 
			ifFalse: [ nil ]
]

{ #category : #accessing }
GtGemStoneSnippetPromiseResolution >> endTimestamp [
	^ endTimestamp
]

{ #category : #executing }
GtGemStoneSnippetPromiseResolution >> ensureExecuting [
	self hasProcess ifTrue: [ ^ self ].
	
	resolutionProcess := [
		state := #Running.
		startTimestamp := DateAndTime now.
		[
			| computedResult |
			
			self notifyResolutionStarted.
			computedResult := snippetPromise value.
			
			state := snippetPromise isBroken 
				ifTrue: [ #Cancelled ] 
				ifFalse: [ #Completed ].
		] ensure: [
			endTimestamp := DateAndTime now.
			(state = #Running) ifTrue: [ 
				state := #Terminated.
				snippetPromise break: nil ].
			
			self notifyResolutionCompleted ].
	] forkNamed: 'GtGemStoneSnippetPromiseExecution resolution process'.
]

{ #category : #accessing }
GtGemStoneSnippetPromiseResolution >> gemStoneSession [
	^ snippetPromise gemStoneSession
]

{ #category : #'gt - inspector' }
GtGemStoneSnippetPromiseResolution >> gtDefaultInspectorTool [
	^(GtPhlowCompositeTool new)
		addTool: (GtGemStoneAsyncEvaluationPhlowTool new 
			promiseResolution: self);
		addTool: super gtDefaultInspectorTool
]

{ #category : #testing }
GtGemStoneSnippetPromiseResolution >> hasProcess [
	^ resolutionProcess notNil
]

{ #category : #testing }
GtGemStoneSnippetPromiseResolution >> hasValidResult [
	^ snippetPromise notNil and: [
		snippetPromise hasValidResult ]
]

{ #category : #initialization }
GtGemStoneSnippetPromiseResolution >> initialize [
	super initialize.
	
	announcer := Announcer new.
	state := #'Not Started'
]

{ #category : #actions }
GtGemStoneSnippetPromiseResolution >> interruptEvaluation [
	snippetPromise interruptEvaluation
]

{ #category : #testing }
GtGemStoneSnippetPromiseResolution >> isResolutionProcessDone [
	^ resolutionProcess isTerminated or: [ 
		resolutionProcess isTerminating ] 
]

{ #category : #testing }
GtGemStoneSnippetPromiseResolution >> isResolvingCompleted [
	^ self hasProcess and: [ 
		self isResolutionProcessDone ]
]

{ #category : #testing }
GtGemStoneSnippetPromiseResolution >> isResolvingPending [
	^ self hasProcess not
]

{ #category : #testing }
GtGemStoneSnippetPromiseResolution >> isResolvingRunning [
	^ self hasProcess and: [ 
		self isResolutionProcessDone not ]
]

{ #category : #notifications }
GtGemStoneSnippetPromiseResolution >> notifyResolutionCompleted [
	announcer announce: GtGemStoneSnippetPromiseResolutionCompletedAnnouncement new
]

{ #category : #notifications }
GtGemStoneSnippetPromiseResolution >> notifyResolutionStarted [
	announcer announce: GtGemStoneSnippetPromiseResolutionStartedAnnouncement new
]

{ #category : #accessing }
GtGemStoneSnippetPromiseResolution >> resolvedValue [
	^ snippetPromise resolvedValue
]

{ #category : #actions }
GtGemStoneSnippetPromiseResolution >> resumeEvaluation [
	snippetPromise resumeEvaluation
]

{ #category : #accessing }
GtGemStoneSnippetPromiseResolution >> sessionDescription [
	^ snippetPromise sessionDescription
]

{ #category : #accessing }
GtGemStoneSnippetPromiseResolution >> snippetPromise [
	^ snippetPromise
]

{ #category : #accessing }
GtGemStoneSnippetPromiseResolution >> snippetPromise: aGtGemStoneSnippetPromise [

	snippetPromise := aGtGemStoneSnippetPromise.
]

{ #category : #accessing }
GtGemStoneSnippetPromiseResolution >> startTimestamp [
	^ startTimestamp
]

{ #category : #accessing }
GtGemStoneSnippetPromiseResolution >> state [
	^ state
]

{ #category : #actions }
GtGemStoneSnippetPromiseResolution >> stopEvaluation [
	snippetPromise stopEvaluation
]
