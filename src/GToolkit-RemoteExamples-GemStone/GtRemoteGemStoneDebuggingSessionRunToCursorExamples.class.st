"
Examples testing run-to-cursor operations on GemStone debugging sessions.
"
Class {
	#name : #GtRemoteGemStoneDebuggingSessionRunToCursorExamples,
	#superclass : #GtRemoteGemStoneDebuggingSessionStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - longComputation' }
GtRemoteGemStoneDebuggingSessionRunToCursorExamples >> longComputation_runToMultiplePoints [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession frames |

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

	self runToCursorSourceOffset: 175 in: debuggingSession.

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
