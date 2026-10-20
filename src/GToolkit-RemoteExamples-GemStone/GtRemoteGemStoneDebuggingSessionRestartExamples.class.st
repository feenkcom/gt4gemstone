"
Examples testing restart operations on GemStone debugging sessions.
"
Class {
	#name : #GtRemoteGemStoneDebuggingSessionRestartExamples,
	#superclass : #GtRemoteGemStoneDebuggingSessionStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionRestartExamples >> doLoop_01_enterBlockAndAdvance [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession frames |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doLoop ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doLoop' in: debuggingSession.

	3 timesRepeat: [ self stepThroughIn: debuggingSession ].

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: true.
	self
		assertFrames: frames atIndex: 1
		highlightedText: '+ 1'
		atProgramCounterRange: (42 to: 44)
		atProgramCounterMarkers: #(42 46).

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionRestartExamples >> doLoop_02_restartBlock [
	"Restart from within a block resets to block entry."
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self doLoop_01_enterBlockAndAdvance.

	self restartIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: true.
	self
		assertFrames: frames atIndex: 1
		highlightedText: ' :each |
		(each + 1 + 1) printString ]'
		atProgramCounterRange: (25 to: 63)
		atProgramCounterMarkers: #(25 42).

	^ debuggingSession
]

{ #category : #'examples - multipleMethodCalls' }
GtRemoteGemStoneDebuggingSessionRestartExamples >> multipleMethodCalls_01_enterAndAdvance [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession frames |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doMultipleMethodCalls ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doMultipleMethodCalls' in: debuggingSession.

	self stepOverIn: debuggingSession.
	self stepOverIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: ':= self helperMethod: 3'
		atProgramCounterRange: (37 to: 59)
		atProgramCounterMarkers: #(37 45).

	^ debuggingSession
]

{ #category : #'examples - multipleMethodCalls' }
GtRemoteGemStoneDebuggingSessionRestartExamples >> multipleMethodCalls_02_restart [
	"Restart resets execution to the method entry point."
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self multipleMethodCalls_01_enterAndAdvance.

	self restartIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'doMultipleMethodCalls
	| a b c |
	a := self helperMethod: 3.
	b := self helperMethod: a.
	c := self factorial: 4.
	^ a + b + c'
		atProgramCounterRange: (1 to: 126)
		atProgramCounterMarkers: #(1 37).

	^ debuggingSession
]

{ #category : #'examples - multipleMethodCalls' }
GtRemoteGemStoneDebuggingSessionRestartExamples >> multipleMethodCalls_03_stepAfterRestart [
	"After restart, stepping advances from the method entry again."
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self multipleMethodCalls_02_restart.

	self stepOverIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'helperMethod: 3'
		atProgramCounterRange: (45 to: 59)
		atProgramCounterMarkers: #(45 65).

	^ debuggingSession
]
