"
Examples testing restart operations on the GemStone debugger through the full UI path (scripter + debugger element).
"
Class {
	#name : #GtRemoteGemStoneDebuggerRestartExamples,
	#superclass : #GtRemoteGemStoneDebuggerStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggerRestartExamples >> doLoop_01_enterBlockAndAdvance [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self doLoop_01_enterMethod.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLoop' inBlock: true;
		play.

	^ scripter
]

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggerRestartExamples >> doLoop_02_restartBlock [
	"Restart from within a block resets to block entry."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self doLoop_01_enterBlockAndAdvance.

	scripter gemStoneDebugger
		clickOnRestartButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLoop' inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: ' :each |
		(each + 1 + 1) printString ]'
			atProgramCounterRange: (25 to: 63)
			atProgramCounterMarkers: #(25 42);
		play.

	^ scripter
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggerRestartExamples >> multipleMethodCalls_01_enterAndAdvance [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self multipleMethodCalls_01_enterMethod.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false;
		play.

	^ scripter
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggerRestartExamples >> multipleMethodCalls_02_restart [
	"Restart resets execution to the method entry point."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self multipleMethodCalls_01_enterAndAdvance.

	scripter gemStoneDebugger
		clickOnRestartButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'doMultipleMethodCalls
	| a b c |
	a := self helperMethod: 3.
	b := self helperMethod: a.
	c := self factorial: 4.
	^ a + b + c'
			atProgramCounterRange: (1 to: 126)
			atProgramCounterMarkers: #(1 37);
		play.

	^ scripter
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggerRestartExamples >> multipleMethodCalls_03_stepAfterRestart [
	"After restart, stepping advances from the method entry again."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self multipleMethodCalls_02_restart.

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

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggerRestartExamples >> nestedBlocks_01_enterInnerBlock [
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
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doNestedBlocks' inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '+ 2'
			atProgramCounterRange: (129 to: 131)
			atProgramCounterMarkers: #(129 132);
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggerRestartExamples >> nestedBlocks_02_restartInnerBlock [
	"Restart from within a twice-nested block resets to inner block entry."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self nestedBlocks_01_enterInnerBlock.

	scripter gemStoneDebugger
		clickOnRestartButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doNestedBlocks' inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '[
			result := result + 2 ]'
			atProgramCounterRange: (107 to: 133)
			atProgramCounterMarkers: #(107 108);
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggerRestartExamples >> nestedBlocks_03_stepAfterRestart [
	"After restart, stepping advances from the inner block entry again."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self nestedBlocks_02_restartInnerBlock.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doNestedBlocks' inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '+ 2'
			atProgramCounterRange: (129 to: 131)
			atProgramCounterMarkers: #(129 132);
		play.

	^ scripter
]
