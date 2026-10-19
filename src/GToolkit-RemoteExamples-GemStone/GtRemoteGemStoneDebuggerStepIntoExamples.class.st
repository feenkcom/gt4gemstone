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
