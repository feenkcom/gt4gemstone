Class {
	#name : #GtGemStoneSnippetPromiseResolution,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'resolutionProcess',
		'snippetPromise',
		'startTimestamp',
		'endTimestamp',
		'state'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSnippetPromiseResolution >> announcer [
	^ announcer
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
			self notifyResolutionStarted.
		
			snippetPromise value.
			state := #Completed.
		] ensure: [
			endTimestamp := DateAndTime now.
			(state = #Running) 
				ifTrue: [ state := #Cancelled ].
			
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

{ #category : #initialization }
GtGemStoneSnippetPromiseResolution >> initialize [
	super initialize.
	
	announcer := Announcer new.
	state := #'Not Started'
]

{ #category : #accessing }
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

{ #category : #testing }
GtGemStoneSnippetPromiseResolution >> isValueResolved [
	^ snippetPromise notNil and: [
		snippetPromise isResolved ]
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
