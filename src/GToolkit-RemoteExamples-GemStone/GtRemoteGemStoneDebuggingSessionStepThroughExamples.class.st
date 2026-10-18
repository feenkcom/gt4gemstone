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
		atProgramCounterRange: (1 to: 1149)
		atProgramCounterMarkers: #(1 1149).
	self
		assertFrames: frames atIndex: 3
		highlightedText: '^ self'
		atProgramCounterRange: (156 to: 161)
		atProgramCounterMarkers: #(156 163).
	self
		assertFrames: frames atIndex: 4
		highlightedText: 'do: [ :each |
		(each + 1 + 1) printString ]'
		atProgramCounterRange: (20 to: 63)
		atProgramCounterMarkers: #(20 63).

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_03_endFirstIteration [
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame |

	debuggingSession := self doLoop_02_enterBlock.

	3 timesRepeat: [ self stepThroughIn: debuggingSession ].

	topFrame := debuggingSession remoteContext.
	self assert: topFrame methodSelector equals: 'doLoop'.
	self assert: topFrame inBlock.

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_04_enterSecondIteration [
	"Verifies step through re-enters the loop block for a new iteration."
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame |

	debuggingSession := self doLoop_03_endFirstIteration.

	self stepThroughIn: debuggingSession.

	topFrame := debuggingSession remoteContext.
	self assert: topFrame methodSelector equals: 'doLoop'.
	self assert: topFrame inBlock.

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_05_enterThirdIteration [
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame |

	debuggingSession := self doLoop_04_enterSecondIteration.

	4 timesRepeat: [ self stepThroughIn: debuggingSession ].

	topFrame := debuggingSession remoteContext.
	self assert: topFrame methodSelector equals: 'doLoop'.
	self assert: topFrame inBlock.

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
	| debuggingSession topFrame |

	debuggingSession := self multipleMethodCalls_01_enterMethod.

	3 timesRepeat: [
		self stepThroughIn: debuggingSession.

		topFrame := debuggingSession remoteContext.
		self assert: topFrame methodSelector equals: 'doMultipleMethodCalls'.
		self assert: topFrame inBlock equals: false ].

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
	| debuggingSession topFrame |

	debuggingSession := self nestedBlocks_01_enterMethod.

	3 timesRepeat: [ self stepThroughIn: debuggingSession ].

	topFrame := debuggingSession remoteContext.
	self assert: topFrame methodSelector equals: 'doNestedBlocks'.
	self assert: topFrame inBlock.

	^ debuggingSession
]

{ #category : #'examples - nestedBlocks' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> nestedBlocks_03_enterInnerBlock [
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame |

	debuggingSession := self nestedBlocks_02_enterOuterBlock.

	3 timesRepeat: [ self stepThroughIn: debuggingSession ].

	topFrame := debuggingSession remoteContext.
	self assert: topFrame methodSelector equals: 'doNestedBlocks'.
	self assert: topFrame inBlock.

	^ debuggingSession
]

{ #category : #'examples - nestedBlocks' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> nestedBlocks_04_returnToOuterBlock [
	"Verifies that after the inner block completes, step through
	returns to the outer block (not the home method)."
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame |

	debuggingSession := self nestedBlocks_03_enterInnerBlock.

	3 timesRepeat: [ self stepThroughIn: debuggingSession ].

	topFrame := debuggingSession remoteContext.
	self assert: topFrame methodSelector equals: 'doNestedBlocks'.
	self assert: topFrame inBlock.

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
