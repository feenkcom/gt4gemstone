Class {
	#name : #GtRemoteGemStoneDebuggingSessionStepIntoExamples,
	#superclass : #GtRemoteGemStoneDebuggingSessionStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggingSessionStepIntoExamples >> doLoop_02_enterBlock [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames stepCount topFrame found |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self doLoop_01_enterMethod.

	stepCount := 0.
	found := false.
	[ found not and: [ stepCount < 100 ] ] whileTrue: [
		topFrame := debuggingSession remoteContext.
		(topFrame methodSelector = 'doLoop' and: [ topFrame inBlock ])
			ifTrue: [ found := true ]
			ifFalse: [
				self stepIntoIn: debuggingSession.
				stepCount := stepCount + 1 ] ].

	self assert: found description: 'Should have entered the loop block within 100 steps'.
	self assert: stepCount >= 20.
	self assert: stepCount <= 50.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: true.
	self assertFrames: frames atIndex: 2 isSelector: 'to:by:do:' inBlock: false.
	self assertFrames: frames atIndex: 3 isSelector: 'do:' inBlock: false.
	self assertFrames: frames atIndex: 4 isSelector: 'doLoop' inBlock: false.

	self
		assertFrames: frames atIndex: 1
		highlightedText: ':each |
		(each + 1 + 1) printString ]'
		atProgramCounterRange: (25 to: 63)
		atProgramCounterMarkers: #(25 42).
	self
		assertFrames: frames atIndex: 2
		highlightedText: 'value: i'
		atProgramCounterRange: (1140 to: 1147)
		atProgramCounterMarkers: #(1140 1149).
	self
		assertFrames: frames atIndex: 3
		highlightedText: 'to: to by: by do: aBlock'
		atProgramCounterRange: (130 to: 153)
		atProgramCounterMarkers: #(130 156).
	self
		assertFrames: frames atIndex: 4
		highlightedText: 'do: [ :each |
		(each + 1 + 1) printString ]'
		atProgramCounterRange: (20 to: 63)
		atProgramCounterMarkers: #(20 63).

	^ debuggingSession
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggingSessionStepIntoExamples >> multipleMethodCalls_01_stepIntoHelperMethod [
	"Step into enters the called method."
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doMultipleMethodCalls ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doMultipleMethodCalls' in: debuggingSession.

	self stepOverIn: debuggingSession.
	self stepIntoIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'helperMethod:' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'helperMethod: aValue
	^ aValue * 2 + 1'
		atProgramCounterRange: (1 to: 38)
		atProgramCounterMarkers: #(1 23).
	self assertFrames: frames atIndex: 1 variable: #aValue equals: '3'.

	^ debuggingSession
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggingSessionStepIntoExamples >> multipleMethodCalls_02_callerPreservesHighlight [
	"The caller frame preserves its highlight at the call site."
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self multipleMethodCalls_01_stepIntoHelperMethod.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 2 isSelector: 'doMultipleMethodCalls' inBlock: false.
	self
		assertFrames: frames atIndex: 2
		highlightedText: 'helperMethod: 3'
		atProgramCounterRange: (45 to: 59)
		atProgramCounterMarkers: #(45 65).

	^ debuggingSession
]
