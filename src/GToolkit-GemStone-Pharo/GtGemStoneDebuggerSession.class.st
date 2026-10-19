Class {
	#name : #GtGemStoneDebuggerSession,
	#superclass : #GtDebugSession,
	#instVars : [
		'initialStackFrames'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStoneDebuggerSession >> breakpoints [ 
	<return: #Dictionary>

	^ self debuggerClient breakpoints
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> currentFrameVariable: variableName atIndex: anInteger frameIndentifier: aFrameIndentifier [

	^ self debuggerProxy
		proxyPerformReturnProxy: #variableIndex:atFrameIdentifierIndex: 
		withArguments: { anInteger. aFrameIndentifier identityIndex. }
		autoCommit: false.
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> currentFrameVariable: variableName atIndex: anInteger frameLevel: ordinalInteger [

	self remoteApiVersion < GtGemStoneSemanticVersionNumber oneZeroZero  
		ifTrue: [ 
			^ self 
				oldCurrentFrameVariable: variableName 
				atIndex: anInteger 
				frameLevel: ordinalInteger ].

	^ self debuggerProxy
		proxyPerformReturnProxy: #variableIndex:atFrameLevel:
		withArguments: { anInteger. ordinalInteger. }
		autoCommit: false.
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerSession >> debuggerClient [
	"Answer the debugger, which is specific to the exception type"

	^ self exception debuggerClient

]

{ #category : #'private - accessing' }
GtGemStoneDebuggerSession >> debuggerProxy [

	^ self exception debuggerProxy
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerSession >> exception [
	"Answer the exception that triggered the debug session."

	^ exception ifNil: [ 
		exception := self interruptedContext receiver exception ]
]

{ #category : #'remote actions - stepping' }
GtGemStoneDebuggerSession >> gsPerformStep: aMethodSelector onFrameIdentifier: aFrameIdentifier [
	[ self debuggerProxy
		proxyPerform: aMethodSelector
		withArguments: { aFrameIdentifier identityIndex }
		autoCommit: false ]
			on: GtRsrEvaluationException
			do: [ :ex | self error: 'Unexpected debugger error'. ].
	
	self resetState.
]

{ #category : #'remote actions - stepping' }
GtGemStoneDebuggerSession >> gsRestartFrameIdentifier: aFrameIdentifier [
	self 
		gsPerformStep: #restartFrameIdentifierIndex:
		onFrameIdentifier: aFrameIdentifier
]

{ #category : #'remote actions - stepping' }
GtGemStoneDebuggerSession >> gsResume [

	self debuggerClient gsResume.
]

{ #category : #'remote actions - stepping' }
GtGemStoneDebuggerSession >> gsStepIntoFrameIdentifier: aFrameIdentifier [
	self 
		gsPerformStep: #stepIntoFrameIdentifierIndex:
		onFrameIdentifier: aFrameIdentifier
]

{ #category : #'remote actions - stepping' }
GtGemStoneDebuggerSession >> gsStepOverFrameIdentifier: aFrameIdentifier [
	self 
		gsPerformStep: #stepOverFrameIdentifierIndex:
		onFrameIdentifier: aFrameIdentifier.
]

{ #category : #'remote actions - stepping' }
GtGemStoneDebuggerSession >> gsStepThroughFrameIdentifier: aFrameIdentifier [
	self 
		gsPerformStep: #stepThroughFrameIdentifierIndex:
		onFrameIdentifier: aFrameIdentifier.
]

{ #category : #views }
GtGemStoneDebuggerSession >> gtViewGemStoneAllStackFramesFor: aView [
	<gtView>
	^ aView forward
		title: 'Remote stack (all)';
		priority: 10.5;
		object: [ exception ];
		view: #gtViewGemStoneAllStackFramesFor:
]

{ #category : #views }
GtGemStoneDebuggerSession >> gtViewGemStoneStackFramesFor: aView [
	<gtView>
	^ aView forward
		title: 'Remote stack';
		priority: 10;
		object: [ exception ];
		view: #gtViewGemStoneStackFramesFor:
]

{ #category : #views }
GtGemStoneDebuggerSession >> gtViewRemoteStackExceptionFor: aView [
	<gtView>
	^ aView forward
		title: 'Remote Stack Specification';
		priority: 20;
		object: [ exception ];
		view: #gtViewRemoteStackFor:
]

{ #category : #'gt - extensions' }
GtGemStoneDebuggerSession >> gtViewStackDiffFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Stack diff';
		priority: 25;
		items: [
			| currentFrames initial diff |
			initial := self initialStackFrames.
			currentFrames := self remoteStackFrames.
			diff := currentFrames collect: [ :frame |
				| initialFrame |
				initialFrame := initial
					detect: [ :f | f frameIdentifier = frame frameIdentifier ]
					ifNone: [ nil ].
				{ frame. initialFrame } ] ];
		column: '#' text: [ :pair | pair first frameIdentifier identityIndex ] width: 40;
		column: 'Frame' text: [ :pair |
			String streamContents: [ :s |
				pair first printMethodDescriptionOn: s ] ] width: 250;
		column: 'Initial IP' text: [ :pair |
			pair second
				ifNotNil: [ :f | f ipOffset printString ]
				ifNil: [ 'new' ] ] width: 80;
		column: 'Current IP' text: [ :pair |
			pair first ipOffset printString ] width: 80;
		column: 'Changed' text: [ :pair |
			pair second
				ifNotNil: [ :f |
					f ipOffset = pair first ipOffset
						ifTrue: [ '' ]
						ifFalse: [ f ipOffset printString, ' -> ', pair first ipOffset printString ] ]
				ifNil: [ '' ] ] width: 120;
		column: 'Initial highlight' text: [ :pair |
			pair second
				ifNotNil: [ :f |
					f currentProgramCounterMarkers
						ifNotNil: [ :m |
							(f frameSpecification sourceString
								copyFrom: m first
								to: (m second min: f frameSpecification sourceString size)) ]
						ifNil: [ '' ] ]
				ifNil: [ '' ] ];
		column: 'Current highlight' text: [ :pair |
			pair first currentProgramCounterMarkers
				ifNotNil: [ :m |
					(pair first frameSpecification sourceString
						copyFrom: m first
						to: (m second min: pair first frameSpecification sourceString size)) ]
				ifNil: [ '' ] ];
		send: [ :pair | pair first ]
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> initialStackFrames [
	^ initialStackFrames ifNil: [
		initialStackFrames := self remoteStackFrames collect: [ :frame |
			frame copy ] ]
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> modules [ 
	"There are never loaded modules in the postmortem debugger"
	<return: #Dictionary>

	^ Dictionary new
]

{ #category : #'backward compatibility' }
GtGemStoneDebuggerSession >> oldCurrentFrameVariable: variableName atIndex: anInteger frameLevel: ordinalInteger [

	self 
		assert: self remoteApiVersion isZero
		description: 'Attempt to use debugger API v0 call on later version'.

	^ self debuggerProxy
		proxyPerformReturnProxy: #variable:atFrameLevel:
		withArguments: { variableName. ordinalInteger. }
		autoCommit: false.
]

{ #category : #'accessing - metadata' }
GtGemStoneDebuggerSession >> remoteApiVersion [
	^ self remoteMetadata apiVersion
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> remoteContext [
	^ self remoteStackFrames first
]

{ #category : #'accessing - metadata' }
GtGemStoneDebuggerSession >> remoteMetadata [
	^ self exception debuggerState remoteMetadata
]

{ #category : #'accessing - metadata' }
GtGemStoneDebuggerSession >> remoteSchemaVersion [
	^ self remoteMetadata schemaVersion
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> remoteStackFrames [
	^ self debuggerClient stackFrames
]

{ #category : #actions }
GtGemStoneDebuggerSession >> resetState [
	self debuggerClient resetState
]

{ #category : #actions }
GtGemStoneDebuggerSession >> synchronizeCallStack [
	self debuggerClient synchronizeCallStack
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> terminate [
	[ 
		(interruptedContext isNotNil and: [ 
			self exception isTerminated not ])
				ifTrue: [ 
					[ 
						self debuggerProxy isProxyObjectActive ifTrue: [
							self debuggerProxy 
								proxyPerform: #terminateProcess 
								autoCommit: false ]
					]
						on: GtRsrEvaluationException
						do: [ :ex | ex isTerminated ifFalse: [ ex pass ] ] ] 
	]
		ensure: [ super terminate ]
]
