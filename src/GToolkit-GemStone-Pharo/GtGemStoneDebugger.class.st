Class {
	#name : #GtGemStoneDebugger,
	#superclass : #GtGemStonePostMortemDebugger,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'allStackFrames'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #announcer }
GtGemStoneDebugger >> allStackFrames [
	^ allStackFrames
]

{ #category : #private }
GtGemStoneDebugger >> announceStateChange [
	"Announce that the receiver's state has changed"
	
	self announcer announce: (GtGemStoneDebuggerStateChanged new debugger: self)
]

{ #category : #announcer }
GtGemStoneDebugger >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #accessing }
GtGemStoneDebugger >> debuggerProxy [

	^ exception debuggerProxy
]

{ #category : #private }
GtGemStoneDebugger >> filterUnrelatedStackFramesFrom: aCollectionOfStackFrames [
	| filter |

	filter := self stackFrameFilterOn: aCollectionOfStackFrames.
	^ filter filteredFrames
]

{ #category : #actions }
GtGemStoneDebugger >> gsRestartFrameIdentifier: aFrameIdentifier [

	[ self debuggerProxy
		proxyPerform: #restartFrameIdentifierIndex:
		withArguments: { aFrameIdentifier identityIndex }
		autoCommit: false ]
			on: GtRsrEvaluationException
			do: [ :ex | self error: 'Unexpected debugger error'. ].

	self resetState.
]

{ #category : #actions }
GtGemStoneDebugger >> gsResume [
	| computedResult result |
	
	computedResult := exception isForAsyncPromise 
		ifTrue: [ 
			self debuggerProxy
				proxyPerform: #resumeAsyncComputation
				autoCommit: false ]
		ifFalse: [ 
			self debuggerProxy
				proxyPerform: #resume
				autoCommit: false ].
				
	result := GtGemstoneEvaluationResult 
		createEvaluationResultFromData: computedResult.
	
	exception debugResult: result.
	exception hasDebugResult: true.
	
	self resetState.
]

{ #category : #actions }
GtGemStoneDebugger >> gsStepIntoFrameIdentifier: aFrameIdentifier [

	[ self debuggerProxy
		proxyPerform: #stepIntoFrameIdentifierIndex:
		withArguments: { aFrameIdentifier identityIndex }
		autoCommit: false ]
			on: GtRsrEvaluationException
			do: [ :ex | self error: 'Unexpected debugger error'. ].

	self resetState.
]

{ #category : #actions }
GtGemStoneDebugger >> gsStepOverFrameIdentifier: aFrameIdentifier [

	[ self debuggerProxy
		proxyPerform: #stepOverFrameIdentifierIndex:
		withArguments: { aFrameIdentifier identityIndex }
		autoCommit: false ]
			on: GtRsrEvaluationException
			do: [ :ex | self error: 'Unexpected debugger error'. ].

	self resetState.
]

{ #category : #actions }
GtGemStoneDebugger >> gsStepThroughFrameIdentifier: aFrameIdentifier [

	[ self debuggerProxy
		proxyPerform: #stepThroughFrameIdentifierIndex:
		withArguments: { aFrameIdentifier identityIndex }
		autoCommit: false ]
			on: GtRsrEvaluationException
			do: [ :ex | self error: 'Unexpected debugger error'. ].

	self resetState.
]

{ #category : #'gt - extensions' }
GtGemStoneDebugger >> gtViewAllStackFramesFor: aView [ 
	<gtView>
	
	allStackFrames  ifNil: [ ^ aView empty ].
	
	^ aView columnedList 
		title: 'All stack frames';
		priority: 20;
		items: [ allStackFrames ];
		column: 'Identifier' 
			text: [ :aStackFrame |
				aStackFrame frameIdentifier identityIndex ]
			width: 75;
		column: 'Method' text: [ :aStackFrame |
			aStackFrame printString ]
]

{ #category : #views }
GtGemStoneDebugger >> gtViewStackFilterFor: aView [
	<gtView>

	allStackFrames ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Stack filter';
		priority: 25;
		object: [ self stackFrameFilter ];
		view: #gtViewAllFramesFor:
]

{ #category : #'gt - extensions' }
GtGemStoneDebugger >> gtViewStackFramesFor: aView [ 
	<gtView>
	
	^ aView columnedList 
		title: 'Stack frames';
		priority: 10;
		items: [ self stackFrames ];
		column: 'Identifier' 
			text: [ :aStackFrame |
				aStackFrame frameIdentifier identityIndex ]
			width: 75;
		column: 'Method' text: [ :aStackFrame |
			aStackFrame printString ]
]

{ #category : #initialization }
GtGemStoneDebugger >> initialize [

	super initialize.
	announcer := Announcer new.
]

{ #category : #private }
GtGemStoneDebugger >> preserveNonTopFrameMarkersFrom: previousFrames [
	"When the user steps into a callee, the VM advances the caller's IP
	to the return address (the next step point after the send). This means
	sourceInfo computes markers for the return address, not the send site.
	For example, stepping into doLoop in [ nil halt. ... doLoop ] advances
	the block frame's IP from the doLoop send to the block-return ']',
	so the highlight jumps to ']' instead of staying on 'doLoop'.
	We fix this by preserving markers from when each frame was last
	the top frame (when its IP was at the actual execution point).
	For frames appearing for the first time (no previous match),
	we fall back to callerProgramCounterMarkers which uses
	_previousStepPointForIp: to recover the send site from the
	return address."

	previousFrames ifNil: [ ^ self ].
	stackFrames size <= 1 ifTrue: [ ^ self ].
	2 to: stackFrames size do: [ :index |
		| frame oldFrame |
		frame := stackFrames at: index.
		oldFrame := previousFrames
			detect: [ :old | old frameIdentifier = frame frameIdentifier ]
			ifNone: [ nil ].
		oldFrame
			ifNotNil: [
				frame updateProgramCounterMarkers: oldFrame programCounterMarkers ]
			ifNil: [
				frame callerProgramCounterMarkers ifNotNil: [ :markers |
					frame updateProgramCounterMarkers: markers ] ] ]
]

{ #category : #private }
GtGemStoneDebugger >> resetState [

	stackFrames := nil.
	exception resetState.
	self announceStateChange.
]

{ #category : #private }
GtGemStoneDebugger >> retrieveAllStackFrames [
	| previousStackFrame currentStackFrame |

	previousStackFrame := nil.
	currentStackFrame := nil.

	^ exception debuggerState callStackSpecification frameSpecifications
		collect: [ :aFrameSpecification |
			currentStackFrame := GtGemStoneStackFrame
				fromSpecification: aFrameSpecification
				forException: exception.
			previousStackFrame ifNotNil: [
				previousStackFrame sender: currentStackFrame ].
			previousStackFrame := currentStackFrame.
			currentStackFrame ].
]

{ #category : #private }
GtGemStoneDebugger >> stackFrameFilter [
	^ self stackFrameFilterOn: self allStackFrames.
]

{ #category : #private }
GtGemStoneDebugger >> stackFrameFilterOn: aCollectionOfStackFrames [
	| filter |

	filter := GtGemStoneStackFrameFilter new.
	self exception gtSession
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533
		do: [ filter ignoreFirstHandler ].
		
	filter filter: aCollectionOfStackFrames.
	^ filter
]

{ #category : #accessing }
GtGemStoneDebugger >> stackFrames [
	"Answer an ordered collection of stack frames.
	This is called many times by the debugger, so cache.
	For non-top frames, preserve previous markers so that return-address
	step points (which may coincide with block-return ']') do not
	replace the actual call-site highlighting."

	stackFrames ifNil: [
		| previousFrames |
		previousFrames := allStackFrames.
		allStackFrames := self retrieveAllStackFrames.
		stackFrames := self filterUnrelatedStackFramesFrom: allStackFrames.
		self preserveNonTopFrameMarkersFrom: previousFrames ].

	^ stackFrames
]

{ #category : #accessing }
GtGemStoneDebugger >> summaryString [

	^ exception debuggerState summary
]

{ #category : #actions }
GtGemStoneDebugger >> synchronizeCallStack [
	exception synchronizeCallStack
]
