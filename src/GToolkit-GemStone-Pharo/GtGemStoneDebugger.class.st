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

{ #category : #actions }
GtGemStoneDebugger >> gsRestartFrameLevel: anInteger [

	[ self debuggerProxy
		proxyPerform: #restartFrameLevel:
		withArguments: { anInteger }
		autoCommit: false ]
			on: GtRsrEvaluationException
			do: [ :ex | self error: 'Unexpected debugger error'. ].
	self resetState.
]

{ #category : #actions }
GtGemStoneDebugger >> gsResume [
	| result |

	result := self debuggerProxy
		proxyPerform: #resume
		autoCommit: false.
	exception debugResult: result.
	exception hasDebugResult: true.
	self resetState.
]

{ #category : #actions }
GtGemStoneDebugger >> gsStepIntoFrameLevel: anInteger [

	[ self debuggerProxy
		proxyPerform: #stepIntoFrameLevel:
		withArguments: { anInteger. }
		autoCommit: false ]
			on: GtRsrEvaluationException
			do: [ :ex | self error: 'Unexpected debugger error'. ].
	self resetState.
]

{ #category : #actions }
GtGemStoneDebugger >> gsStepOverFrameLevel: anInteger [

	[ self debuggerProxy
		proxyPerform: #stepOverFrameLevel:
		withArguments: { anInteger. }
		autoCommit: false ]
			on: GtRsrEvaluationException
			do: [ :ex | self error: 'Unexpected debugger error'. ].
	self resetState.
]

{ #category : #actions }
GtGemStoneDebugger >> gsStepThroughFrameLevel: anInteger [

	[ self debuggerProxy
		proxyPerform: #stepThroughFrameLevel:
		withArguments: { anInteger. }
		autoCommit: false ]
			on: GtRsrEvaluationException
			do: [ :ex | self error: 'Unexpected debugger error'. ].
	self resetState.
]

{ #category : #accessing }
GtGemStoneDebugger >> gtViewStackFramesFor: aView [ 
	<gtView>
	
	^ aView columnedList 
		title: 'GemStone stack frames';
		items: [ self stackFrames ];
		column: 'Index' 
			text: [ :aStackFrame |
				aStackFrame ordinal ]
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
GtGemStoneDebugger >> resetState [

	stackFrames := nil.
	exception resetState.
	self announceStateChange.
]

{ #category : #accessing }
GtGemStoneDebugger >> stackFrames [
	"Answer a ordered collection of stack frames.
	This is called many times by the debugger, so cache"

	stackFrames ifNil: [ | defaultFrameOrdinal |
		allStackFrames := exception debuggerState callStack frameSpecifications
			collectWithIndex: [ :aFrameSpecification :index |
				GtGemStoneStackFrame new
					className: aFrameSpecification coderClassName;
					selector: aFrameSpecification selector;
					inBlock: aFrameSpecification isForBlock;
					frameSpecification: aFrameSpecification;
					exception: exception;
					ordinal: index ].
		defaultFrameOrdinal := self defaultFrameOrdinalFrom: allStackFrames.
		stackFrames := defaultFrameOrdinal > 1 ifTrue:
			[ allStackFrames copyFrom: defaultFrameOrdinal to: allStackFrames size ]
		ifFalse:
			[ allStackFrames ] ].
	^ stackFrames
]

{ #category : #accessing }
GtGemStoneDebugger >> summaryString [

	^ exception debuggerState summary
]
