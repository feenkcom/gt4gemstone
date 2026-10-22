"
Examples testing step-over operations on the GemStone debugger through the full UI path (scripter + debugger element).
"
Class {
	#name : #GtRemoteGemStoneDebuggerStepOverExamples,
	#superclass : #GtRemoteGemStoneDebuggerStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - call method with halt' }
GtRemoteGemStoneDebuggerStepOverExamples >> callMethodWithHalt_00_haltAtStart [
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
				nil halt. GtRemotePhlowDebuggerStepTestObject new doCallMethodWithHalt ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: nil inBlock: true;
		play.

	^ scripter
]

{ #category : #'examples - call method with halt' }
GtRemoteGemStoneDebuggerStepOverExamples >> callMethodWithHalt_01_enterMethod [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self callMethodWithHalt_00_haltAtStart.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		clickOnStepIntoButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doCallMethodWithHalt' inBlock: false;
		play.

	^ scripter
]

{ #category : #'examples - call method with halt' }
GtRemoteGemStoneDebuggerStepOverExamples >> callMethodWithHalt_02_stepOverToHaltingCall [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self callMethodWithHalt_01_enterMethod.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doCallMethodWithHalt' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'methodThatHalts'
			atProgramCounterRange: (71 to: 85)
			atProgramCounterMarkers: #(71 89);
		assertVariable: #a equals: '7';
		play.

	^ scripter
]

{ #category : #'examples - call method with halt' }
GtRemoteGemStoneDebuggerStepOverExamples >> callMethodWithHalt_03_stepOverHitsHalt [
	"Stepping over a method call that contains a halt stops at the halt, not past the call."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self callMethodWithHalt_02_stepOverToHaltingCall.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'methodThatHalts' inBlock: false;
		assertNoDuplicateSessionVariableNames;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'halt'
			atProgramCounterRange: (22 to: 25)
			atProgramCounterMarkers: #(22 29);
		assertInCodersListVisuallyHighlightedString: 'halt' atTopIndex: 1;
		assertSessionFrameAtTopIndex: 2 isSelector: 'doCallMethodWithHalt' inBlock: false;
		assertSessionFrameAtTopIndex: 2
			highlightedText: 'methodThatHalts'
			atProgramCounterRange: (71 to: 85)
			atProgramCounterMarkers: #(71 89);
		assertSessionVariableAtFrameIndex: 2 name: #a equals: '7';
		expandCoderAtTopIndex: 2;
		assertInCodersListVisuallyHighlightedString: 'methodThatHalts' atTopIndex: 2;
		play.

	^ scripter
]

{ #category : #'examples - call method with halt' }
GtRemoteGemStoneDebuggerStepOverExamples >> callMethodWithHalt_04_selectCallerAndStepOverFromHalt [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self callMethodWithHalt_02_stepOverToHaltingCall.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'methodThatHalts' inBlock: false;
		play.

	scripter gemStoneDebugger
		selectFrameAtTopIndex: 2;
		play.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doCallMethodWithHalt' inBlock: false;
		assertNoDuplicateSessionVariableNames;
		assertVariable: #a equals: '7';
		assertVariable: #b equals: '42';
		play.

	^ scripter
]

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggerStepOverExamples >> doLoop_02_stepOverLoop [
	"Step over executes the entire loop without entering the block."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self doLoop_01_enterMethod.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLoop' inBlock: false;
		assertNoDuplicateSessionVariableNames;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'do: [ :each |
		(each + 1 + 1) printString ]'
			atProgramCounterRange: (20 to: 63)
			atProgramCounterMarkers: #(20 63);
		assertInCodersListVisuallyHighlightedString: 'do: [ :each |
		(each + 1 + 1) printString ]' atTopIndex: 1;
		play.

	^ scripter
]

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggerStepOverExamples >> doLoop_03_exitMethod [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self doLoop_02_stepOverLoop.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 notSelector: 'doLoop';
		play.

	^ scripter
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggerStepOverExamples >> multipleMethodCalls_02_stepOverFirstSend [
	"Step over advances to the first message send without entering helperMethod:."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self multipleMethodCalls_01_enterMethod.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'helperMethod: 3'
			atProgramCounterRange: (45 to: 59)
			atProgramCounterMarkers: #(45 65);
		assertInCodersListVisuallyHighlightedString: 'helperMethod: 3' atTopIndex: 1;
		play.

	^ scripter
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggerStepOverExamples >> multipleMethodCalls_03_stepOverToSecondSend [
	"Step over past the first assignment reaches the second method send."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self multipleMethodCalls_02_stepOverFirstSend.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false;
		assertNoDuplicateSessionVariableNames;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'helperMethod: a'
			atProgramCounterRange: (73 to: 87)
			atProgramCounterMarkers: #(73 93);
		assertVariable: #a equals: '7';
		assertInCodersListVisuallyHighlightedString: 'helperMethod: a' atTopIndex: 1;
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggerStepOverExamples >> nestedBlocks_01_stepThroughThenStepOver [
	"Step through enters the outer block; step over then skips
	the inner doSomething: call without entering it."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self nestedBlocks_01_enterMethod.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doNestedBlocks' inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '+ 1'
			atProgramCounterRange: (82 to: 84)
			atProgramCounterMarkers: #(82 94);
		play.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doNestedBlocks' inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '+ 10'
			atProgramCounterRange: (155 to: 158)
			atProgramCounterMarkers: #(155 159);
		assertInCodersListVisuallyHighlightedString: '+ 10' atTopIndex: 1;
		play.

	^ scripter
]
