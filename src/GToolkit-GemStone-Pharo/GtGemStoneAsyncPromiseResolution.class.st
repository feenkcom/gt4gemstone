Class {
	#name : #GtGemStoneAsyncPromiseResolution,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'resolutionProcess',
		'startTimestamp',
		'endTimestamp',
		'state',
		'asyncPromise'
	],
	#category : #'GToolkit-GemStone-Pharo-Promises'
}

{ #category : #callbacks }
GtGemStoneAsyncPromiseResolution >> actOnResolutionFinished [
	self notifyResolutionCompleted .
	self gemStoneSession 
		removeAsyncExecutionForPromise: asyncPromise targetPromise
]

{ #category : #callbacks }
GtGemStoneAsyncPromiseResolution >> actOnResolutionStarted [
	self notifyResolutionStarted 
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> announcer [
	^ announcer
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> asyncPromise [
	^ asyncPromise
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> asyncPromise: anAsyncPromise [

	asyncPromise := anAsyncPromise.
]

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> canStopExecution [
	"For now allow the execution to be stopped even if we do not have an evaluation context"
	^ self isResolvingRunning and: [
		asyncPromise canStopExecution ]
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
			
			self actOnResolutionStarted.
			computedResult := asyncPromise value.
			
			state := asyncPromise isBroken 
				ifTrue: [ #Cancelled ] 
				ifFalse: [ #Completed ].
		] ensure: [
			endTimestamp := DateAndTime now.
			(state = #Running) ifTrue: [ 
				state := #Terminated.
				asyncPromise break: nil ].
			
			self actOnResolutionFinished ].
	] 
		forkAt: Processor userBackgroundPriority 
		named: 'GtGemStoneSnippetPromiseExecution resolution process'.
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> gemStoneSession [
	^ asyncPromise gemStoneSession
]

{ #category : #'gt - inspector' }
GtGemStoneAsyncPromiseResolution >> gtDefaultInspectorTool [
	^ GtPhlowExplicitCompositeTool new 
		toolStencil: [
			| compositeTool |
			compositeTool := GtPhlowCompositeTool new.
	
			self hasValidResult 
				ifTrue: [
					compositeTool addTools: (self resolvedValue 
						gtDefaultInspectorTool tools).
					"compositeTool
						addTool: (GtGemStoneAsyncEvaluationPhlowTool new 
							promiseResolution: self;
							disableContentReplace)."
					compositeTool 
						addTool: (super gtDefaultInspectorTool
							name: 'Execution';
							withLabelAndIconAptitude) ]
				ifFalse: [
					compositeTool
						addTool: (GtGemStoneAsyncEvaluationPhlowTool new 
							promiseResolution: self);
						addTool: super gtDefaultInspectorTool ].
		
			compositeTool ]
]

{ #category : #'gt - extensions' }
GtGemStoneAsyncPromiseResolution >> gtViewSummaryFor: aView [
	<gtView>
	
	^ aView columnedList 
		title: 'Summary';
		priority: 5;
		items: [ self summaryAttributes ];
		column: #Attribute text: [ :item | item first ];
		column: #Value text: [ :item | item second ];
		send: [ :item | item third ];
		actionUpdateButton
]

{ #category : #'gt - extensions' }
GtGemStoneAsyncPromiseResolution >> gtViewTranscriptFor: aView [
	<gtView>

	self gemStoneSession currentFeatures hasGemStoneTranscriptV1 
		ifFalse: [ ^ aView empty ].
	self gemStoneSession isRunning ifFalse: [ ^ aView empty ].
	
	^ aView forward
		title: 'Session Transcript';
		priority: 10;
		object: [ self gemStoneSession remoteTranscript ];
		view: #gtViewTranscriptFor:;
		actionButtonIcon: BrGlamorousIcons inspect 
			tooltip: 'Inspect transcript wrapper'
			action: [ :aButton  |
				aButton phlow 
					spawnObject: self gemStoneSession remoteTranscript ]
]

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> hasProcess [
	^ resolutionProcess notNil
]

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> hasValidResult [
	^ asyncPromise notNil and: [
		asyncPromise hasValidResult ]
]

{ #category : #initialization }
GtGemStoneAsyncPromiseResolution >> initialize [
	super initialize.
	
	announcer := Announcer new.
	state := #'Not Started'
]

{ #category : #actions }
GtGemStoneAsyncPromiseResolution >> interruptEvaluation [
	asyncPromise interruptEvaluation
]

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> isResolutionProcessDone [
	^ resolutionProcess isTerminated or: [ 
		resolutionProcess isTerminating ] 
]

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> isResolutionProcessSuspended [
	^ resolutionProcess isSuspended
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

{ #category : #testing }
GtGemStoneAsyncPromiseResolution >> isResolvingSuspended [
	^ self hasProcess and: [ 
		self isResolutionProcessSuspended ]
]

{ #category : #notifications }
GtGemStoneAsyncPromiseResolution >> notifyResolutionCompleted [
	announcer announce: GtGemStoneAsyncPromiseResolutionFinishedAnnouncement new
]

{ #category : #notifications }
GtGemStoneAsyncPromiseResolution >> notifyResolutionStarted [
	announcer announce: GtGemStoneAsyncPromiseResolutionStartedAnnouncement new
]

{ #category : #printing }
GtGemStoneAsyncPromiseResolution >> printOn: aStream [ 
	super printOn: aStream .
	
	aStream parenthesize: [
		aStream 
			<< self state;
			<< '; ';
			<< self sessionName ]
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> resolvedValue [
	^ asyncPromise resolvedValue
]

{ #category : #actions }
GtGemStoneAsyncPromiseResolution >> resumeEvaluation [
	asyncPromise resumeEvaluation
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> sessionDescription [
	^ asyncPromise sessionDescription
]

{ #category : #accessing }
GtGemStoneAsyncPromiseResolution >> sessionName [
	^ asyncPromise sessionName
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
	asyncPromise stopEvaluation
]

{ #category : #'gt - extensions' }
GtGemStoneAsyncPromiseResolution >> summaryAttributes [
	^ {
		{'Status' . self state . self state}.
		{'Start time' . 
			self startTimestamp 
				ifNil: ['-'] 
				ifNotNil: [ :aTimestamp | aTimestamp asTime ]. 
			self startTimestamp} .
		{'End time' . 
			self endTimestamp 
				ifNil: ['-'] 
				ifNotNil: [ :aTimestamp | aTimestamp asTime ]. . 
			self endTimestamp} .
		{'Duration' . 
			(self duration 
				ifNil: [ '-' ]
				ifNotNil: [ :aDuration | 
					aDuration humanReadablePrintString]). 
			self duration}.
		{'Session' . self sessionDescription. self gemStoneSession} }
]

{ #category : #actions }
GtGemStoneAsyncPromiseResolution >> terminateResolutionProcess [
	resolutionProcess terminate
]
