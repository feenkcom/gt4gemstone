Class {
	#name : #GtRemoteGemStoneStackFilterExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator + TGtScripterDebuggerExamples',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait + TGtScripterDebuggerExamples classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'helpers - assertions' }
GtRemoteGemStoneStackFilterExamples >> assertFrames: frames atIndex: anIndex isSelector: aSelector inBlock: aBoolean [

	self assert: (frames at: anIndex) methodSelector equals: aSelector.
	self assert: (frames at: anIndex) inBlock equals: aBoolean
]

{ #category : #'helpers - assertions' }
GtRemoteGemStoneStackFilterExamples >> assertFrames: frames atIndex: anIndex variable: aName equals: aValueString [
	| frame vars match |

	frame := frames at: anIndex.
	vars := frame safeVariablesAssociationsBasedOnIndex.
	match := vars detect: [ :each | each first = aName ] ifNone: [ nil ].
	self
		assert: match notNil
		description: 'Variable ', aName, ' not found'.
	self assert: match second equals: aValueString
]

{ #category : #'examples - stepping in handler' }
GtRemoteGemStoneStackFilterExamples >> callMethodInHandler_01_haltInHandler [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self
		debuggingSessionForBlock: [
			GtRemotePhlowDebuggerStepTestObject new doCallMethodInHandler ]
		session: self runningServer.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'doCallMethodInHandler' inBlock: true.

	^ debuggingSession
]

{ #category : #'examples - stepping in handler' }
GtRemoteGemStoneStackFilterExamples >> callMethodInHandler_02_stepOverFromHalt [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self callMethodInHandler_01_haltInHandler.

	self stepOverIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'doCallMethodInHandler' inBlock: true.

	^ debuggingSession
]

{ #category : #'examples - stepping in handler' }
GtRemoteGemStoneStackFilterExamples >> callMethodInHandler_03_stepIntoHelperMethod [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self callMethodInHandler_02_stepOverFromHalt.

	self stepIntoIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'helperMethod:' inBlock: false.
	self assertFrames: frames atIndex: 1
		variable: #aValue equals: '3'.

	^ debuggingSession
]

{ #category : #'examples - stepping in handler' }
GtRemoteGemStoneStackFilterExamples >> callMethodInHandler_04_returnFromHelperToHandler [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self callMethodInHandler_03_stepIntoHelperMethod.

	4 timesRepeat: [ self stepOverIn: debuggingSession ].

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'doCallMethodInHandler' inBlock: true.

	^ debuggingSession
]

{ #category : #'examples - exception handler stepping' }
GtRemoteGemStoneStackFilterExamples >> callMethodInHandler_05_stepOutOfHandlerReachesExecuteHandler [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self callMethodInHandler_04_returnFromHelperToHandler.

	self stepOverIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assert: frames first methodSelector equals: '_executeHandler:'.
	self assert: frames first inBlock equals: false.

	^ debuggingSession
]

{ #category : #'examples - scripter - stepping in handler' }
GtRemoteGemStoneStackFilterExamples >> callMethodInHandler_06_debuggerStepOverAndStepInto [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	gemstoneSession := self runningServer.
	scripter := self
		scripterWithDebuggerOn: [
			gemstoneSession evaluateBlockAndWait: [
				GtRemotePhlowDebuggerStepTestObject new doCallMethodInHandler ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1
			isSelector: 'doCallMethodInHandler'
			inBlock: true;
		play.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1
			isSelector: 'doCallMethodInHandler'
			inBlock: true;
		play.

	scripter gemStoneDebugger
		clickOnStepIntoButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1
			isSelector: 'helperMethod:'
			inBlock: false;
		play.

	^ scripter
]

{ #category : #helpers }
GtRemoteGemStoneStackFilterExamples >> debuggerOn: aBlock withException: anExceptionClass [
	| aDebugSession |

	aDebugSession := self debugSessionOn: aBlock withException: anExceptionClass.
	^ (GtMoldableDebugger on: aDebugSession) beDetailedLevel
]

{ #category : #helpers }
GtRemoteGemStoneStackFilterExamples >> debuggingSessionForBlock: aBlock session: aGemstoneSession [
	| debuggingSession |

	debuggingSession := self
		forkedDebugSessionOn: [ aGemstoneSession evaluateBlockAndWait: aBlock ]
		withException: GtRsrEvaluationException.
	debuggingSession := GtGemStoneExpandableDebuggerElement
		spanNewSessionFrom: debuggingSession.
	debuggingSession synchronizeCallStack.
	^ debuggingSession
]

{ #category : #'examples - stepping in ensure' }
GtRemoteGemStoneStackFilterExamples >> ensureWithMethodCalls_01_haltInEnsure [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self
		debuggingSessionForBlock: [
			GtRemotePhlowDebuggerStepTestObject new doEnsureWithMethodCalls ]
		session: self runningServer.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'doEnsureWithMethodCalls' inBlock: true.

	^ debuggingSession
]

{ #category : #'examples - stepping in ensure' }
GtRemoteGemStoneStackFilterExamples >> ensureWithMethodCalls_02_stepOverFromHalt [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self ensureWithMethodCalls_01_haltInEnsure.

	self stepOverIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'doEnsureWithMethodCalls' inBlock: true.

	^ debuggingSession
]

{ #category : #'examples - stepping in ensure' }
GtRemoteGemStoneStackFilterExamples >> ensureWithMethodCalls_03_stepIntoHelperInEnsure [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self ensureWithMethodCalls_02_stepOverFromHalt.

	self stepIntoIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'helperMethod:' inBlock: false.
	self assertFrames: frames atIndex: 1
		variable: #aValue equals: '5'.

	^ debuggingSession
]

{ #category : #helpers }
GtRemoteGemStoneStackFilterExamples >> filterForDebuggingSession: aDebuggingSession [
	| debugger filter |

	debugger := aDebuggingSession debuggerClient.
	debugger stackFrames.
	filter := GtGemStoneStackFrameFilter new.
	filter filter: debugger allStackFrames.
	^ filter
]

{ #category : #'examples - filter - exception handler' }
GtRemoteGemStoneStackFilterExamples >> haltInDoubleNestedHandler_01_filterStack [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self
		debuggingSessionForBlock: [
			GtRemotePhlowDebuggerStepTestObject new doHaltInDoubleNestedHandler ]
		session: self runningServer.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'doHaltInDoubleNestedHandler' inBlock: true.

	^ debuggingSession
]

{ #category : #'examples - filter - exception handler' }
GtRemoteGemStoneStackFilterExamples >> haltInDoubleNestedHandler_02_filterObjectDetails [
	<gtExample>
	<after: #stopServer>
	| debuggingSession filter allFrames executeHandlerCount |

	debuggingSession := self haltInDoubleNestedHandler_01_filterStack.
	filter := self filterForDebuggingSession: debuggingSession.
	allFrames := filter allFrames.

	executeHandlerCount := allFrames count: [ :f | f selector = '_executeHandler:' ].
	self assert: executeHandlerCount >= 2.

	self assert: filter executeHandlerBarrierIndex > 0.

	^ filter
]

{ #category : #'examples - scripter - exception handler' }
GtRemoteGemStoneStackFilterExamples >> haltInDoubleNestedHandler_03_debuggerOpensOnCorrectFrame [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession scripter |

	gemstoneSession := self runningServer.
	scripter := self
		scripterWithDebuggerOn: [
			gemstoneSession evaluateBlockAndWait: [
				GtRemotePhlowDebuggerStepTestObject new doHaltInDoubleNestedHandler ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1
			isSelector: 'doHaltInDoubleNestedHandler'
			inBlock: true;
		play.

	^ scripter
]

{ #category : #'examples - filter - ensure' }
GtRemoteGemStoneStackFilterExamples >> haltInEnsureBlock_01_filterStack [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self
		debuggingSessionForBlock: [
			GtRemotePhlowDebuggerStepTestObject new doHaltInEnsureBlock ]
		session: self runningServer.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'doHaltInEnsureBlock' inBlock: true.

	^ debuggingSession
]

{ #category : #'examples - scripter - ensure' }
GtRemoteGemStoneStackFilterExamples >> haltInEnsureBlock_03_debuggerOpensOnCorrectFrame [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession scripter |

	gemstoneSession := self runningServer.
	scripter := self
		scripterWithDebuggerOn: [
			gemstoneSession evaluateBlockAndWait: [
				GtRemotePhlowDebuggerStepTestObject new doHaltInEnsureBlock ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1
			isSelector: 'doHaltInEnsureBlock'
			inBlock: true;
		play.

	^ scripter
]

{ #category : #'examples - filter - exception handler' }
GtRemoteGemStoneStackFilterExamples >> haltInExceptionHandler_01_filterStack [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self
		debuggingSessionForBlock: [
			GtRemotePhlowDebuggerStepTestObject new doHaltInExceptionHandler ]
		session: self runningServer.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'doHaltInExceptionHandler' inBlock: true.

	^ debuggingSession
]

{ #category : #'examples - exception handler filter' }
GtRemoteGemStoneStackFilterExamples >> haltInExceptionHandler_02_filterObjectDetails [
	<gtExample>
	<after: #stopServer>
	| debuggingSession filter |

	debuggingSession := self haltInExceptionHandler_01_filterStack.
	filter := self filterForDebuggingSession: debuggingSession.

	self assert: filter executeHandlerBarrierIndex > 0.
	self assert: filter firstRelevantFrameOrdinal > 1.
	self assert: filter filteredFrames first selector
		equals: (debuggingSession remoteStackFrames at: 1) methodSelector.

	^ filter
]

{ #category : #'examples - scripter - exception handler' }
GtRemoteGemStoneStackFilterExamples >> haltInExceptionHandler_03_debuggerOpensOnCorrectFrame [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession scripter |

	gemstoneSession := self runningServer.
	scripter := self
		scripterWithDebuggerOn: [
			gemstoneSession evaluateBlockAndWait: [
				GtRemotePhlowDebuggerStepTestObject new doHaltInExceptionHandler ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1
			isSelector: 'doHaltInExceptionHandler'
			inBlock: true;
		play.

	^ scripter
]

{ #category : #'examples - filter - exception handler' }
GtRemoteGemStoneStackFilterExamples >> haltInTripleNestedHandler_01_filterStack [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self
		debuggingSessionForBlock: [
			GtRemotePhlowDebuggerStepTestObject new doHaltInTripleNestedHandler ]
		session: self runningServer.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'doHaltInTripleNestedHandler' inBlock: true.

	^ debuggingSession
]

{ #category : #'examples - triple nested handler' }
GtRemoteGemStoneStackFilterExamples >> haltInTripleNestedHandler_02_filterObjectDetails [
	<gtExample>
	<after: #stopServer>
	| debuggingSession filter allFrames barrierCount |

	debuggingSession := self haltInTripleNestedHandler_01_filterStack.
	filter := self filterForDebuggingSession: debuggingSession.
	allFrames := filter allFrames.

	barrierCount := (1 to: allFrames size) count: [ :i |
		filter isExecuteHandlerBarrierAt: i ].
	self assert: barrierCount equals: 3.

	self assert: filter executeHandlerBarrierIndex > 0.
	self assert: (filter isExecuteHandlerBarrierAt: filter executeHandlerBarrierIndex).

	^ filter
]

{ #category : #'examples - scripter - exception handler' }
GtRemoteGemStoneStackFilterExamples >> haltInTripleNestedHandler_03_debuggerOpensOnCorrectFrame [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession scripter |

	gemstoneSession := self runningServer.
	scripter := self
		scripterWithDebuggerOn: [
			gemstoneSession evaluateBlockAndWait: [
				GtRemotePhlowDebuggerStepTestObject new doHaltInTripleNestedHandler ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1
			isSelector: 'doHaltInTripleNestedHandler'
			inBlock: true;
		play.

	^ scripter
]

{ #category : #'examples - stepping in handler - multiple calls' }
GtRemoteGemStoneStackFilterExamples >> multipleCallsInHandler_01_haltInHandler [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self
		debuggingSessionForBlock: [
			GtRemotePhlowDebuggerStepTestObject new doMultipleCallsInHandler ]
		session: self runningServer.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'doMultipleCallsInHandler' inBlock: true.

	^ debuggingSession
]

{ #category : #'examples - stepping in handler - multiple calls' }
GtRemoteGemStoneStackFilterExamples >> multipleCallsInHandler_02_stepOverAndIntoHelper [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self multipleCallsInHandler_01_haltInHandler.

	self stepOverIn: debuggingSession.
	self stepIntoIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'helperMethod:' inBlock: false.
	self assertFrames: frames atIndex: 1
		variable: #aValue equals: '3'.

	^ debuggingSession
]

{ #category : #'examples - exception handler stepping' }
GtRemoteGemStoneStackFilterExamples >> multipleCallsInHandler_03_returnFromHelperToHandler [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self multipleCallsInHandler_02_stepOverAndIntoHelper.

	4 timesRepeat: [ self stepOverIn: debuggingSession ].

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1
		isSelector: 'doMultipleCallsInHandler' inBlock: true.

	^ debuggingSession
]

{ #category : #'examples - exception handler stepping' }
GtRemoteGemStoneStackFilterExamples >> multipleCallsInHandler_04_stepOutOfHandlerReachesExecuteHandler [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	debuggingSession := self multipleCallsInHandler_03_returnFromHelperToHandler.

	self stepOverIn: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assert: frames first methodSelector equals: '_executeHandler:'.

	^ debuggingSession
]

{ #category : #'examples - filter - normal halt' }
GtRemoteGemStoneStackFilterExamples >> normalHalt_01_filterStack [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames |

	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. 42 ]
		session: self runningServer.

	frames := debuggingSession remoteStackFrames.
	self assert: (frames at: 1) inBlock equals: true.

	^ debuggingSession
]

{ #category : #'examples - normal halt filter' }
GtRemoteGemStoneStackFilterExamples >> normalHalt_02_filterObjectHasNoBarrier [
	<gtExample>
	<after: #stopServer>
	| debuggingSession filter |

	debuggingSession := self normalHalt_01_filterStack.
	filter := self filterForDebuggingSession: debuggingSession.

	self assert: filter executeHandlerBarrierIndex equals: 0.
	self assert: filter firstRelevantFrameOrdinal > 1.

	^ filter
]

{ #category : #helpers }
GtRemoteGemStoneStackFilterExamples >> scripterWithDebuggerOn: aBlock withException: anExceptionClass [
	| debuggerElement scripter |

	debuggerElement := self debuggerOn: aBlock withException: anExceptionClass.
	scripter := BlScripter new.
	scripter element: debuggerElement.
	scripter model: debuggerElement debugSession.
	^ scripter
]

{ #category : #helpers }
GtRemoteGemStoneStackFilterExamples >> stepIntoIn: aDebuggingSession [

	aDebuggingSession gsStepIntoFrameIdentifier:
		aDebuggingSession remoteContext frameIdentifier.
	aDebuggingSession synchronizeCallStack
]

{ #category : #helpers }
GtRemoteGemStoneStackFilterExamples >> stepOverIn: aDebuggingSession [

	aDebuggingSession gsStepOverFrameIdentifier:
		aDebuggingSession remoteContext frameIdentifier.
	aDebuggingSession synchronizeCallStack
]
