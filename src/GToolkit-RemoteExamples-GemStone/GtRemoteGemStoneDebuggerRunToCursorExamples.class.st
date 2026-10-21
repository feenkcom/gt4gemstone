"
Examples testing run-to-cursor operations through the full debugger UI path.
"
Class {
	#name : #GtRemoteGemStoneDebuggerRunToCursorExamples,
	#superclass : #GtRemoteGemStoneDebuggerStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggerRunToCursorExamples >> doLoop_runToCursor_printString [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self doLoop_01_enterMethod.

	scripter gemStoneDebugger
		moveCursorTo: 50 atTopIndex: 1;
		clickOnRunToCursorButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLoop' inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'printString'
			atProgramCounterRange: (51 to: 61)
			atProgramCounterMarkers: #(51 62);
		play.

	^ scripter
]

{ #category : #'examples - long computation' }
GtRemoteGemStoneDebuggerRunToCursorExamples >> longComputation_runToCursorBackward [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self longComputation_01_enterMethod.

	scripter gemStoneDebugger
		moveCursorTo: 174 atTopIndex: 1;
		clickOnRunToCursorButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLongComputation' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'add: a'
			atProgramCounterRange: (175 to: 180)
			atProgramCounterMarkers: #(175 191);
		play.

	scripter gemStoneDebugger
		moveCursorTo: 77 atTopIndex: 1;
		clickOnRunToCursorButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLongComputation' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'add: a'
			atProgramCounterRange: (175 to: 180)
			atProgramCounterMarkers: #(175 191);
		play.

	scripter gemStoneDebugger
		moveCursorTo: 347 atTopIndex: 1;
		clickOnRunToCursorButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLongComputation' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: ':= self factorial: d'
			atProgramCounterRange: (348 to: 367)
			atProgramCounterMarkers: #(348 356);
		play.

	^ scripter
]

{ #category : #'examples - long computation' }
GtRemoteGemStoneDebuggerRunToCursorExamples >> longComputation_runToMultiplePoints [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self longComputation_01_enterMethod.

	scripter gemStoneDebugger
		moveCursorTo: 77 atTopIndex: 1;
		clickOnRunToCursorButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLongComputation' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: ':= c * 3'
			atProgramCounterRange: (78 to: 85)
			atProgramCounterMarkers: #(78 83);
		play.

	scripter gemStoneDebugger
		moveCursorTo: 174 atTopIndex: 1;
		clickOnRunToCursorButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLongComputation' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'add: a'
			atProgramCounterRange: (175 to: 180)
			atProgramCounterMarkers: #(175 191);
		play.

	scripter gemStoneDebugger
		moveCursorTo: 347 atTopIndex: 1;
		clickOnRunToCursorButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLongComputation' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: ':= self factorial: d'
			atProgramCounterRange: (348 to: 367)
			atProgramCounterMarkers: #(348 356);
		play.

	scripter gemStoneDebugger
		moveCursorTo: 487 atTopIndex: 1;
		clickOnRunToCursorButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLongComputation' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '^ result'
			atProgramCounterRange: (488 to: 495)
			atProgramCounterMarkers: #(488 495);
		play.

	^ scripter
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggerRunToCursorExamples >> multipleMethodCalls_runToCursor_factorial [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self multipleMethodCalls_01_enterMethod.

	scripter gemStoneDebugger
		moveCursorTo: 100 atTopIndex: 1;
		clickOnRunToCursorButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'factorial: 4'
			atProgramCounterRange: (101 to: 112)
			atProgramCounterMarkers: #(101 116);
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggerRunToCursorExamples >> nestedBlocks_runToCursor_innerAndOuter [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self nestedBlocks_01_enterMethod.

	scripter gemStoneDebugger
		moveCursorTo: 128 atTopIndex: 1;
		clickOnRunToCursorButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doNestedBlocks' inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '+ 2'
			atProgramCounterRange: (129 to: 131)
			atProgramCounterMarkers: #(129 132);
		play.

	scripter gemStoneDebugger
		moveCursorTo: 154 atTopIndex: 1;
		clickOnRunToCursorButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doNestedBlocks' inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '+ 10'
			atProgramCounterRange: (155 to: 158)
			atProgramCounterMarkers: #(155 159);
		play.

	^ scripter
]
