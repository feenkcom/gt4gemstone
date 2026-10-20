"
Abstract superclass for examples testing GemStone debugger step operations through the full debugger UI path.
"
Class {
	#name : #GtRemoteGemStoneDebuggerStepExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator + TGtScripterDebuggerExamples',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait + TGtScripterDebuggerExamples classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemoteGemStoneDebuggerStepExamples class >> isAbstract [
	^ self == GtRemoteGemStoneDebuggerStepExamples
]

{ #category : #support }
GtRemoteGemStoneDebuggerStepExamples >> debuggerOn: aBlock withException: anExceptionClass [
	| aDebugSession |

	aDebugSession := self debugSessionOn: aBlock withException: anExceptionClass.
	^ (GtMoldableDebugger on: aDebugSession) beDetailedLevel
]

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggerStepExamples >> doLoop_00_haltAtStart [
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
				nil halt. GtRemotePhlowDebuggerStepTestObject new doLoop ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertInCodersListVisuallyHighlightedString: 'halt' atTopIndex: 1;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: nil inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'halt'
			atProgramCounterRange: (11 to: 14)
			atProgramCounterMarkers: #(11 53);
		play.

	^ scripter
]

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggerStepExamples >> doLoop_01_enterMethod [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self doLoop_00_haltAtStart.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		clickOnStepIntoButton;
		play.

	scripter gemStoneDebugger
		assertInCodersListVisuallyHighlightedString: 'doLoop
	(1 to: 10) do: [ :each |
		(each + 1 + 1) printString ]' atTopIndex: 1;
		assertInCodersListVisuallyHighlightedString: 'doLoop' atTopIndex: 2;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLoop' inBlock: false;
		assertSessionFrameAtTopIndex: 2 isSelector: nil inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'doLoop
	(1 to: 10) do: [ :each |
		(each + 1 + 1) printString ]'
			atProgramCounterRange: (1 to: 63)
			atProgramCounterMarkers: #(1 12);
		assertSessionFrameAtTopIndex: 2
			highlightedText: 'doLoop'
			atProgramCounterRange: (57 to: 62)
			atProgramCounterMarkers: #(57 63);
		play.

	^ scripter
]

{ #category : #'examples - long computation' }
GtRemoteGemStoneDebuggerStepExamples >> longComputation_00_haltAtStart [
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
				nil halt. GtRemotePhlowDebuggerStepTestObject new doLongComputation ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: nil inBlock: true;
		play.

	^ scripter
]

{ #category : #'examples - long computation' }
GtRemoteGemStoneDebuggerStepExamples >> longComputation_01_enterMethod [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self longComputation_00_haltAtStart.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		clickOnStepIntoButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLongComputation' inBlock: false;
		play.

	^ scripter
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggerStepExamples >> multipleMethodCalls_00_haltAtStart [
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
				nil halt. GtRemotePhlowDebuggerStepTestObject new doMultipleMethodCalls ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: nil inBlock: true;
		play.

	^ scripter
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggerStepExamples >> multipleMethodCalls_01_enterMethod [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self multipleMethodCalls_00_haltAtStart.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		clickOnStepIntoButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false;
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggerStepExamples >> nestedBlocks_00_haltAtStart [
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
				nil halt. GtRemotePhlowDebuggerStepTestObject new doNestedBlocks ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: nil inBlock: true;
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggerStepExamples >> nestedBlocks_01_enterMethod [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self nestedBlocks_00_haltAtStart.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		clickOnStepIntoButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doNestedBlocks' inBlock: false;
		play.

	^ scripter
]

{ #category : #support }
GtRemoteGemStoneDebuggerStepExamples >> scripterWithDebuggerInPagerOn: aBlock withException: anExceptionClass [
	| debuggerElement scripter |

	debuggerElement := self debuggerOn: aBlock withException: anExceptionClass.

	scripter := BlScripter new.
	scripter element: debuggerElement inPager.
	scripter model: debuggerElement debugSession.
	^ scripter
]

{ #category : #support }
GtRemoteGemStoneDebuggerStepExamples >> scripterWithDebuggerOn: aBlock withException: anExceptionClass [
	| debuggerElement scripter |

	debuggerElement := self debuggerOn: aBlock withException: anExceptionClass.

	scripter := BlScripter new.
	scripter element: debuggerElement.
	scripter model: debuggerElement debugSession.
	^ scripter
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggerStepExamples >> stepIntoMethodNamed: aMethodName in: aDebuggingSession [
	[ aDebuggingSession remoteStackFrames noneSatisfy: [ :f |
		f methodSelector = aMethodName ] ] whileTrue: [
			aDebuggingSession gsStepIntoFrameIdentifier:
				aDebuggingSession remoteContext frameIdentifier.
			aDebuggingSession synchronizeCallStack ]
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggerStepExamples >> stepThroughIn: aDebuggingSession [
	aDebuggingSession gsStepThroughFrameIdentifier:
		aDebuggingSession remoteContext frameIdentifier.
	aDebuggingSession synchronizeCallStack
]
