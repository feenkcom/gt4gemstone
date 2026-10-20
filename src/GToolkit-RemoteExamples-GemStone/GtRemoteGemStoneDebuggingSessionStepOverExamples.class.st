"
Examples testing step-over operations on GemStone debugging sessions.
"
Class {
	#name : #GtRemoteGemStoneDebuggingSessionStepOverExamples,
	#superclass : #GtRemoteGemStoneDebuggingSessionStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - call method with halt' }
GtRemoteGemStoneDebuggingSessionStepOverExamples >> callMethodWithHalt_01_enterMethod [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doCallMethodWithHalt ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doCallMethodWithHalt' in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doCallMethodWithHalt' inBlock: false.

	^ debuggingSession
]

{ #category : #'examples - call method with halt' }
GtRemoteGemStoneDebuggingSessionStepOverExamples >> callMethodWithHalt_02_stepOverToHaltingCall [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self callMethodWithHalt_01_enterMethod.

	self stepOverIn: debuggingSession.
	self stepOverIn: debuggingSession.
	self stepOverIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doCallMethodWithHalt' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'methodThatHalts'
		atProgramCounterRange: (71 to: 85)
		atProgramCounterMarkers: #(71 89).
	self assertFrames: frames atIndex: 1 variable: #a equals: '7'.

	^ debuggingSession
]

{ #category : #'examples - call method with halt' }
GtRemoteGemStoneDebuggingSessionStepOverExamples >> callMethodWithHalt_03_stepOverHitsHalt [
	"Stepping over a method call that contains a halt stops at the halt, not past the call."
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self callMethodWithHalt_02_stepOverToHaltingCall.

	self stepOverIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'methodThatHalts' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'halt'
		atProgramCounterRange: (93 to: 96)
		atProgramCounterMarkers: #(93 100).

	self assertFrames: frames atIndex: 2 isSelector: 'doCallMethodWithHalt' inBlock: false.
	self
		assertFrames: frames atIndex: 2
		highlightedText: 'methodThatHalts'
		atProgramCounterRange: (71 to: 85)
		atProgramCounterMarkers: #(71 89).
	self assertFrames: frames atIndex: 2 variable: #a equals: '7'.

	^ debuggingSession
]

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggingSessionStepOverExamples >> doLoop_01_enterMethod [
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

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'doLoop
	(1 to: 10) do: [ :each |
		(each + 1 + 1) printString ]'
		atProgramCounterRange: (1 to: 63)
		atProgramCounterMarkers: #(1 12).

	^ debuggingSession
]

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggingSessionStepOverExamples >> doLoop_02_stepOverLoop [
	"Step over executes the entire loop without entering the block."
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self doLoop_01_enterMethod.

	self stepOverIn: debuggingSession.
	self stepOverIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'do: [ :each |
		(each + 1 + 1) printString ]'
		atProgramCounterRange: (20 to: 63)
		atProgramCounterMarkers: #(20 63).

	^ debuggingSession
]

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggingSessionStepOverExamples >> doLoop_03_exitMethod [
	<gtExample>
	<after: #stopServer>
	| debuggingSession |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self doLoop_02_stepOverLoop.

	self stepOverIn: debuggingSession.
	self stepOverIn: debuggingSession.

	self
		assert: debuggingSession remoteContext methodSelector ~= 'doLoop'
		description: 'Should have exited doLoop'.

	^ debuggingSession
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggingSessionStepOverExamples >> multipleMethodCalls_01_enterMethod [
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

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false.

	^ debuggingSession
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggingSessionStepOverExamples >> multipleMethodCalls_02_stepOverFirstSend [
	"Step over advances to the first message send without entering helperMethod:."
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self multipleMethodCalls_01_enterMethod.

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

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggingSessionStepOverExamples >> multipleMethodCalls_03_stepOverToSecondSend [
	"Step over past the first assignment reaches the second method send."
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self multipleMethodCalls_02_stepOverFirstSend.

	self stepOverIn: debuggingSession.
	self stepOverIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'helperMethod: a'
		atProgramCounterRange: (73 to: 87)
		atProgramCounterMarkers: #(73 93).
	self assertFrames: frames atIndex: 1 variable: #a equals: '7'.

	^ debuggingSession
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggingSessionStepOverExamples >> multipleMethodCalls_04_exitMethod [
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame stepCount maxSteps |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self multipleMethodCalls_03_stepOverToSecondSend.

	stepCount := 0.
	maxSteps := 20.
	[ topFrame := debuggingSession remoteContext.
	  (topFrame methodSelector = 'doMultipleMethodCalls') and: [ stepCount < maxSteps ] ]
		whileTrue: [
			self stepOverIn: debuggingSession.
			stepCount := stepCount + 1 ].

	self
		assert: debuggingSession remoteContext methodSelector ~= 'doMultipleMethodCalls'
		description: 'Should have exited doMultipleMethodCalls'.
	self assert: stepCount < maxSteps.

	^ debuggingSession
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggingSessionStepOverExamples >> nestedBlocks_01_stepThroughThenStepOver [
	"Step through enters the outer block; step over then skips
	the inner doSomething: call without entering it."
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

	3 timesRepeat: [ self stepThroughIn: debuggingSession ].

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doNestedBlocks' inBlock: true.
	self
		assertFrames: frames atIndex: 1
		highlightedText: '+ 1'
		atProgramCounterRange: (82 to: 84)
		atProgramCounterMarkers: #(82 94).

	3 timesRepeat: [ self stepOverIn: debuggingSession ].

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doNestedBlocks' inBlock: true.
	self
		assertFrames: frames atIndex: 1
		highlightedText: '+ 10'
		atProgramCounterRange: (155 to: 158)
		atProgramCounterMarkers: #(155 159).

	^ debuggingSession
]
