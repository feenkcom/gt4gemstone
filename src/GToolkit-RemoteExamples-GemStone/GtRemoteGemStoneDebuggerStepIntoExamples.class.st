"
Examples testing step-into operations on the GemStone debugger through the full UI path (scripter + debugger element).
"
Class {
	#name : #GtRemoteGemStoneDebuggerStepIntoExamples,
	#superclass : #GtRemoteGemStoneDebuggerStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtRemoteGemStoneDebuggerStepIntoExamples >> doLoop_02_enterBlock [
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self doLoop_01_enterMethod.

	scripter gemStoneDebugger
		clickOnStepIntoButton;
		clickOnStepOverButton;
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepIntoButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLoop' inBlock: true;
		assertSessionFrameAtTopIndex: 2 isSelector: 'to:by:do:' inBlock: false;
		assertSessionFrameAtTopIndex: 3 isSelector: 'do:' inBlock: false;
		assertSessionFrameAtTopIndex: 4 isSelector: 'doLoop' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: ':each |
		(each + 1 + 1) printString ]'
			atProgramCounterRange: (25 to: 63)
			atProgramCounterMarkers: #(25 42);
		assertSessionFrameAtTopIndex: 2
			highlightedText: 'value: i'
			atProgramCounterRange: (1140 to: 1147)
			atProgramCounterMarkers: #(1140 1149);
		assertSessionFrameAtTopIndex: 3
			highlightedText: 'to: to by: by do: aBlock'
			atProgramCounterRange: (130 to: 153)
			atProgramCounterMarkers: #(130 156);
		assertSessionFrameAtTopIndex: 4
			highlightedText: 'do: [ :each |
		(each + 1 + 1) printString ]'
			atProgramCounterRange: (20 to: 63)
			atProgramCounterMarkers: #(20 63);
		play.

	scripter gemStoneDebugger
		assertInCodersListVisuallyHighlightedString: ' :each |
		(each + 1 + 1) printString ]' atTopIndex: 1;
		play.

	^ scripter
]

{ #category : #'examples - multipleMethodCalls' }
GtRemoteGemStoneDebuggerStepIntoExamples >> multipleMethodCalls_01_stepIntoHelperMethod [
	"Step into enters the called method."
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self multipleMethodCalls_01_enterMethod.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepIntoButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'helperMethod:' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'helperMethod: aValue
	^ aValue * 2 + 1'
			atProgramCounterRange: (1 to: 38)
			atProgramCounterMarkers: #(1 23);
		assertVariable: #aValue equals: '3';
		assertInCodersListVisuallyHighlightedString: 'helperMethod: aValue
	^ aValue * 2 + 1' atTopIndex: 1;
		play.

	^ scripter
]

{ #category : #'examples - multipleMethodCalls' }
GtRemoteGemStoneDebuggerStepIntoExamples >> multipleMethodCalls_02_callerPreservesHighlight [
	"The caller frame preserves its highlight at the call site."
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self multipleMethodCalls_01_stepIntoHelperMethod.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 2 isSelector: 'doMultipleMethodCalls' inBlock: false;
		assertSessionFrameAtTopIndex: 2
			highlightedText: 'helperMethod: 3'
			atProgramCounterRange: (45 to: 59)
			atProgramCounterMarkers: #(45 65);
		play.

	scripter gemStoneDebugger
		scrollToFrameAtTopIndex: 2;
		expandCoderAtTopIndex: 2;
		assertInCodersListVisuallyHighlightedString: 'helperMethod: 3' atTopIndex: 2;
		play.

	^ scripter
]
