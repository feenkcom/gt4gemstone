"
Examples testing run-to-cursor operations on GemStone debugging sessions.
"
Class {
	#name : #GtRemoteGemStoneDebuggingSessionRunToCursorExamples,
	#superclass : #GtRemoteGemStoneDebuggingSessionStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggingSessionRunToCursorExamples >> doLoop_runToCursorBackwardInLoopBody [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doLoop ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doLoop' in: debuggingSession.

	self runToCursorSourceOffset: 51 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: true.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'printString'
		atProgramCounterRange: (51 to: 61)
		atProgramCounterMarkers: #(51 62).

	self runToCursorSourceOffset: 42 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: true.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'printString'
		atProgramCounterRange: (51 to: 61)
		atProgramCounterMarkers: #(51 62).

	^ debuggingSession
]

{ #category : #'examples - long computation' }
GtRemoteGemStoneDebuggingSessionRunToCursorExamples >> longComputation_runToCursorBackward [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doLongComputation ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doLongComputation' in: debuggingSession.

	self runToCursorSourceOffset: 175 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLongComputation' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'add: a'
		atProgramCounterRange: (175 to: 180)
		atProgramCounterMarkers: #(175 191).

	self runToCursorSourceOffset: 78 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLongComputation' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'add: a'
		atProgramCounterRange: (175 to: 180)
		atProgramCounterMarkers: #(175 191).

	self runToCursorSourceOffset: 348 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLongComputation' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: ':= self factorial: d'
		atProgramCounterRange: (348 to: 367)
		atProgramCounterMarkers: #(348 356).

	^ debuggingSession
]

{ #category : #'examples - long computation' }
GtRemoteGemStoneDebuggingSessionRunToCursorExamples >> longComputation_runToCursorSamePosition [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doLongComputation ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doLongComputation' in: debuggingSession.

	self runToCursorSourceOffset: 175 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'add: a'
		atProgramCounterRange: (175 to: 180)
		atProgramCounterMarkers: #(175 191).

	self runToCursorSourceOffset: 175 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'add: a'
		atProgramCounterRange: (175 to: 180)
		atProgramCounterMarkers: #(175 191).

	self runToCursorSourceOffset: 348 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self
		assertFrames: frames atIndex: 1
		highlightedText: ':= self factorial: d'
		atProgramCounterRange: (348 to: 367)
		atProgramCounterMarkers: #(348 356).

	^ debuggingSession
]

{ #category : #'examples - long computation' }
GtRemoteGemStoneDebuggingSessionRunToCursorExamples >> longComputation_runToCursorWithVariableValues [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doLongComputation ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doLongComputation' in: debuggingSession.

	self runToCursorSourceOffset: 78 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 variable: #a equals: '1'.
	self assertFrames: frames atIndex: 1 variable: #b equals: '2'.
	self assertFrames: frames atIndex: 1 variable: #c equals: '3'.

	self runToCursorSourceOffset: 175 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 variable: #a equals: '1'.
	self assertFrames: frames atIndex: 1 variable: #b equals: '2'.
	self assertFrames: frames atIndex: 1 variable: #c equals: '3'.
	self assertFrames: frames atIndex: 1 variable: #d equals: '9'.
	self assertFrames: frames atIndex: 1 variable: #e equals: '362880'.
	self assertFrames: frames atIndex: 1 variable: #f equals: '6'.

	self runToCursorSourceOffset: 348 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 variable: #a equals: '7'.
	self assertFrames: frames atIndex: 1 variable: #b equals: '19'.
	self assertFrames: frames atIndex: 1 variable: #c equals: '26'.
	self assertFrames: frames atIndex: 1 variable: #d equals: '52'.

	^ debuggingSession
]

{ #category : #'examples - long computation' }
GtRemoteGemStoneDebuggingSessionRunToCursorExamples >> longComputation_runToMultiplePoints [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doLongComputation ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doLongComputation' in: debuggingSession.

	self runToCursorSourceOffset: 78 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLongComputation' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: ':= c * 3'
		atProgramCounterRange: (78 to: 85)
		atProgramCounterMarkers: #(78 83).
	self assertFrames: frames atIndex: 1 variable: #a equals: '1'.
	self assertFrames: frames atIndex: 1 variable: #b equals: '2'.
	self assertFrames: frames atIndex: 1 variable: #c equals: '3'.

	self runToCursorSourceOffset: 175 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLongComputation' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'add: a'
		atProgramCounterRange: (175 to: 180)
		atProgramCounterMarkers: #(175 191).
	self assertFrames: frames atIndex: 1 variable: #d equals: '9'.

	self runToCursorSourceOffset: 348 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLongComputation' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: ':= self factorial: d'
		atProgramCounterRange: (348 to: 367)
		atProgramCounterMarkers: #(348 356).

	self runToCursorSourceOffset: 488 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLongComputation' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: '^ result'
		atProgramCounterRange: (488 to: 495)
		atProgramCounterMarkers: #(488 495).

	^ debuggingSession
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggingSessionRunToCursorExamples >> nestedBlocks_runToCursor_innerAndOuter [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doNestedBlocks ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doNestedBlocks' in: debuggingSession.

	self runToCursorSourceOffset: 129 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doNestedBlocks' inBlock: true.
	self
		assertFrames: frames atIndex: 1
		highlightedText: '+ 2'
		atProgramCounterRange: (129 to: 131)
		atProgramCounterMarkers: #(129 132).

	self runToCursorSourceOffset: 155 in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doNestedBlocks' inBlock: true.
	self
		assertFrames: frames atIndex: 1
		highlightedText: '+ 10'
		atProgramCounterRange: (155 to: 158)
		atProgramCounterMarkers: #(155 159).

	^ debuggingSession
]
