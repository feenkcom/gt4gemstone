Class {
	#name : #GtGemStoneAsyncPromiseResolution,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'resolutionProcess',
		'snippetPromise',
		'startTimestamp',
		'endTimestamp',
		'state'
	],
	#category : #'GToolkit-GemStone-Pharo-Promises'
}

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> announcer [
	^ announcer
]

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> canStopExecution [
	"For now allow the execution to be stopped even if we do not have an evaluation context"
	^ self isResolvingRunning and: [
		snippetPromise canStopExecution ]
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> duration [ 
	^ (startTimestamp notNil and: [
		endTimestamp notNil ]) 
			ifTrue: [ endTimestamp - startTimestamp] 
			ifFalse: [ nil ]
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> endTimestamp [
	^ endTimestamp
]

{ #category : #executing }
GtGemStoneAsyncPromiseResolution >> ensureExecuting [
	self hasProcess ifTrue: [ ^ self ].
	
	state := #Running.
	startTimestamp := DateAndTime now.
	resolutionProcess := [
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
GtGemStoneAsyncPromiseResolution >> gemStoneSession [
	^ snippetPromise gemStoneSession
]

{ #category : #'gt - inspector' }
GtGemStoneAsyncPromiseResolution >> gtDefaultInspectorTool [
	^(GtPhlowCompositeTool new)
		addTool: (GtGemStoneAsyncEvaluationPhlowTool new 
			promiseResolution: self);
		addTool: super gtDefaultInspectorTool
]

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> hasProcess [
	^ resolutionProcess notNil
]

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> hasValidResult [
	^ snippetPromise notNil and: [
		snippetPromise hasValidResult ]
]

{ #category : #initialization }
GtGemStoneAsyncPromiseResolution >> initialize [
	super initialize.
	
	announcer := Announcer new.
	state := #'Not Started'
]

{ #category : #actions }
GtGemStoneAsyncPromiseResolution >> interruptEvaluation [
	snippetPromise interruptEvaluation
]

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> isResolutionProcessDone [
	^ resolutionProcess isTerminated or: [ 
		resolutionProcess isTerminating ] 
]

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> isResolvingCompleted [
	^ self hasProcess and: [ 
		self isResolutionProcessDone ]
]

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> isResolvingPending [
	^ self hasProcess not
]

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> isResolvingRunning [
	^ self hasProcess and: [ 
		self isResolutionProcessDone not ]
]

{ #category : #notifications }
GtGemStoneAsyncPromiseResolution >> notifyResolutionCompleted [
	announcer announce: GtGemStoneAsyncPromiseResolutionCompletedAnnouncement new
]

{ #category : #notifications }
GtGemStoneAsyncPromiseResolution >> notifyResolutionStarted [
	announcer announce: GtGemStoneAsyncPromiseResolutionStartedAnnouncement new
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> resolvedValue [
	^ snippetPromise resolvedValue
]

{ #category : #actions }
GtGemStoneAsyncPromiseResolution >> resumeEvaluation [
	snippetPromise resumeEvaluation
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> sessionDescription [
	^ snippetPromise sessionDescription
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> sessionName [
	^ snippetPromise sessionName
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> snippetPromise [
	^ snippetPromise
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> snippetPromise: aGtGemStoneSnippetPromise [

	snippetPromise := aGtGemStoneSnippetPromise.
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> startTimestamp [
	^ startTimestamp
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> state [
	^ state
]

{ #category : #actions }
GtGemStoneAsyncPromiseResolution >> stopEvaluation [
	snippetPromise stopEvaluation
]

{ #category : #actions }
GtGemStoneAsyncPromiseResolution >> terminateResolutionProcess [
	resolutionProcess terminate
]
