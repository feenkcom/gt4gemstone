"
Examples testing step-through operations on GemStone debugging sessions. Verifies that step through correctly advances through loop iterations.
"
Class {
	#name : #GtRemoteGemStoneDebuggingSessionStepThroughExamples,
	#superclass : #GtRemoteGemStoneDebuggingSessionStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_01_enterMethod [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession |
	
	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [ 
			GtRemotePhlowDebuggerStepTestObject new halt; doLoop ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'doLoop' in: debuggingSession.

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_02_enterBlock [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self doLoop_01_enterMethod.

	3 timesRepeat: [ self stepThroughIn: debuggingSession ].

	frames := debuggingSession remoteStackFrames.
	self assertFrame: frames first isSelector: 'doLoop' inBlock: true.
	self assertFrame: frames second isSelector: 'to:by:do:' inBlock: false.
	self assertFrame: frames third isSelector: 'do:' inBlock: false.
	self assertFrame: frames fourth isSelector: 'doLoop' inBlock: false.

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
		debuggingSessionForBlock: [ GtRemotePhlowDebuggerStepTestObject new halt; doMultipleMethodCalls ]
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
		debuggingSessionForBlock: [ GtRemotePhlowDebuggerStepTestObject new halt; doNestedBlocks ]
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
