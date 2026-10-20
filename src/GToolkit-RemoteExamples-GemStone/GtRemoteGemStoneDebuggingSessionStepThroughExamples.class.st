"
Examples testing step-through operations on GemStone debugging sessions. Verifies that step through correctly advances through loop iterations.
"
Class {
	#name : #GtRemoteGemStoneDebuggingSessionStepThroughExamples,
	#superclass : #GtRemoteGemStoneDebuggingSessionStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_02_enterBlock [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self doLoop_01_enterMethod.

	3 timesRepeat: [ self stepThroughIn: debuggingSession ].

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: true.
	self assertFrames: frames atIndex: 2 isSelector: 'to:by:do:' inBlock: false.
	self assertFrames: frames atIndex: 3 isSelector: 'do:' inBlock: false.
	self assertFrames: frames atIndex: 4 isSelector: 'doLoop' inBlock: false.

	self
		assertFrames: frames atIndex: 1
		highlightedText: '+ 1'
		atProgramCounterRange: (42 to: 44)
		atProgramCounterMarkers: #(42 46).
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
	self assertFrames: frames atIndex: 1 variable: #each equals: '1'.

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_03_endFirstIteration [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self doLoop_02_enterBlock.

	3 timesRepeat: [ self stepThroughIn: debuggingSession ].

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: true.

	self
		assertFrames: frames atIndex: 1
		highlightedText: ']'
		atProgramCounterRange: (62 to: 63)
		atProgramCounterMarkers: #(62 63).
	self
		assertFrames: frames atIndex: 2
		highlightedText: 'value: i'
		atProgramCounterRange: (1140 to: 1147)
		atProgramCounterMarkers: #(1140 1149).
	self
		assertFrames: frames atIndex: 4
		highlightedText: 'do: [ :each |
		(each + 1 + 1) printString ]'
		atProgramCounterRange: (20 to: 63)
		atProgramCounterMarkers: #(20 63).

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_04_enterSecondIteration [
	"Verifies step through re-enters the loop block for a new iteration."
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self doLoop_03_endFirstIteration.

	self stepThroughIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: true.

	self
		assertFrames: frames atIndex: 1
		highlightedText: '+ 1'
		atProgramCounterRange: (42 to: 44)
		atProgramCounterMarkers: #(42 46).
	self
		assertFrames: frames atIndex: 2
		highlightedText: 'value: i'
		atProgramCounterRange: (1140 to: 1147)
		atProgramCounterMarkers: #(1140 1149).
	self
		assertFrames: frames atIndex: 4
		highlightedText: 'do: [ :each |
		(each + 1 + 1) printString ]'
		atProgramCounterRange: (20 to: 63)
		atProgramCounterMarkers: #(20 63).
	self assertFrames: frames atIndex: 1 variable: #each equals: '2'.

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_05_enterThirdIteration [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self doLoop_04_enterSecondIteration.

	4 timesRepeat: [ self stepThroughIn: debuggingSession ].

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: true.

	self
		assertFrames: frames atIndex: 1
		highlightedText: '+ 1'
		atProgramCounterRange: (42 to: 44)
		atProgramCounterMarkers: #(42 46).
	self
		assertFrames: frames atIndex: 2
		highlightedText: 'value: i'
		atProgramCounterRange: (1140 to: 1147)
		atProgramCounterMarkers: #(1140 1149).
	self assertFrames: frames atIndex: 1 variable: #each equals: '3'.

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_06_exitMethod [
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame stepCount maxSteps |

	debuggingSession := self doLoop_05_enterThirdIteration.

	stepCount := 0.
	maxSteps := 100.
	[ topFrame := debuggingSession remoteContext.
	  (topFrame methodSelector = 'doLoop') and: [ stepCount < maxSteps ] ]
		whileTrue: [
			self stepThroughIn: debuggingSession.
			stepCount := stepCount + 1 ].

	topFrame := debuggingSession remoteContext.
	self
		assert: topFrame methodSelector ~= 'doLoop'
		description: 'Should have exited doLoop'.
	self assert: stepCount < maxSteps.

	^ debuggingSession
]

{ #category : #'examples - multipleMethodCalls' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> multipleMethodCalls_01_enterMethod [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doMultipleMethodCalls ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doMultipleMethodCalls' in: debuggingSession.

	^ debuggingSession
]

{ #category : #'examples - multipleMethodCalls' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> multipleMethodCalls_02_stepThroughStatements [
	"Verifies step through without blocks behaves as step over:
	each step advances to the next statement without entering called methods."
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self multipleMethodCalls_01_enterMethod.

	3 timesRepeat: [
		self stepThroughIn: debuggingSession.
		self assert: debuggingSession remoteContext methodSelector equals: 'doMultipleMethodCalls'.
		self assert: debuggingSession remoteContext inBlock equals: false ].

	frames := debuggingSession remoteStackFrames.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'helperMethod: a'
		atProgramCounterRange: (73 to: 87)
		atProgramCounterMarkers: #(73 93).
	self assertFrames: frames atIndex: 1 variable: #a equals: '7'.

	^ debuggingSession
]

{ #category : #'examples - multipleMethodCalls' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> multipleMethodCalls_03_exitMethod [
	<gtExample>
	<after: #stopServer>
	| debuggingSession |

	debuggingSession := self multipleMethodCalls_02_stepThroughStatements.

	7 timesRepeat: [ self stepThroughIn: debuggingSession ].

	self
		assert: debuggingSession remoteContext methodSelector ~= 'doMultipleMethodCalls'
		description: 'Should have exited doMultipleMethodCalls'.

	^ debuggingSession
]

{ #category : #'examples - nestedBlocks' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> nestedBlocks_01_enterMethod [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doNestedBlocks ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doNestedBlocks' in: debuggingSession.

	self assert: debuggingSession remoteContext methodSelector equals: 'doNestedBlocks'.

	^ debuggingSession
]

{ #category : #'examples - nestedBlocks' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> nestedBlocks_02_enterOuterBlock [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self nestedBlocks_01_enterMethod.

	3 timesRepeat: [ self stepThroughIn: debuggingSession ].

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doNestedBlocks' inBlock: true.
	self assertFrames: frames atIndex: 2 isSelector: 'doSomething:' inBlock: false.
	self assertFrames: frames atIndex: 3 isSelector: 'doNestedBlocks' inBlock: false.

	self
		assertFrames: frames atIndex: 1
		highlightedText: '+ 1'
		atProgramCounterRange: (82 to: 84)
		atProgramCounterMarkers: #(82 94).
	self
		assertFrames: frames atIndex: 2
		highlightedText: 'value'
		atProgramCounterRange: (31 to: 35)
		atProgramCounterMarkers: #(31 35).
	self
		assertFrames: frames atIndex: 3
		highlightedText: 'doSomething: [
		result := result + 1.
		self doSomething: [
			result := result + 2 ].
		result := result + 10 ]'
		atProgramCounterRange: (48 to: 160)
		atProgramCounterMarkers: #(48 164).

	^ debuggingSession
]

{ #category : #'examples - nestedBlocks' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> nestedBlocks_03_enterInnerBlock [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self nestedBlocks_02_enterOuterBlock.

	3 timesRepeat: [ self stepThroughIn: debuggingSession ].

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doNestedBlocks' inBlock: true.
	self assertFrames: frames atIndex: 2 isSelector: 'doSomething:' inBlock: false.
	self assertFrames: frames atIndex: 3 isSelector: 'doNestedBlocks' inBlock: true.
	self assertFrames: frames atIndex: 4 isSelector: 'doSomething:' inBlock: false.
	self assertFrames: frames atIndex: 5 isSelector: 'doNestedBlocks' inBlock: false.

	self
		assertFrames: frames atIndex: 1
		highlightedText: '+ 2'
		atProgramCounterRange: (129 to: 131)
		atProgramCounterMarkers: #(129 132).
	self
		assertFrames: frames atIndex: 3
		highlightedText: 'doSomething: [
			result := result + 2 ]'
		atProgramCounterRange: (94 to: 133)
		atProgramCounterMarkers: #(94 145).
	self
		assertFrames: frames atIndex: 5
		highlightedText: 'doSomething: [
		result := result + 1.
		self doSomething: [
			result := result + 2 ].
		result := result + 10 ]'
		atProgramCounterRange: (48 to: 160)
		atProgramCounterMarkers: #(48 164).

	^ debuggingSession
]

{ #category : #'examples - nestedBlocks' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> nestedBlocks_04_returnToOuterBlock [
	"Verifies that after the inner block completes, step through
	returns to the outer block, not the home method."
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self nestedBlocks_03_enterInnerBlock.

	3 timesRepeat: [ self stepThroughIn: debuggingSession ].

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doNestedBlocks' inBlock: true.
	self assertFrames: frames atIndex: 2 isSelector: 'doSomething:' inBlock: false.
	self assertFrames: frames atIndex: 3 isSelector: 'doNestedBlocks' inBlock: false.

	self
		assertFrames: frames atIndex: 1
		highlightedText: '+ 10'
		atProgramCounterRange: (155 to: 158)
		atProgramCounterMarkers: #(155 159).
	self
		assertFrames: frames atIndex: 2
		highlightedText: 'value'
		atProgramCounterRange: (31 to: 35)
		atProgramCounterMarkers: #(31 35).
	self
		assertFrames: frames atIndex: 3
		highlightedText: 'doSomething: [
		result := result + 1.
		self doSomething: [
			result := result + 2 ].
		result := result + 10 ]'
		atProgramCounterRange: (48 to: 160)
		atProgramCounterMarkers: #(48 164).

	^ debuggingSession
]

{ #category : #'examples - nestedBlocks' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> nestedBlocks_05_exitMethod [
	<gtExample>
	<after: #stopServer>
	| debuggingSession |

	debuggingSession := self nestedBlocks_04_returnToOuterBlock.

	4 timesRepeat: [ self stepThroughIn: debuggingSession ].

	self
		assert: debuggingSession remoteContext methodSelector ~= 'doNestedBlocks'
		description: 'Should have exited doNestedBlocks'.

	^ debuggingSession
]
