"
Examples testing step-through operations on the GemStone debugger through the full UI path (scripter + debugger element).
"
Class {
	#name : #GtRemoteGemStoneDebuggerStepThroughExamples,
	#superclass : #GtRemoteGemStoneDebuggerStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggerStepThroughExamples >> doLoop_02_enterBlock [
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self doLoop_01_enterMethod.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLoop' inBlock: true;
		assertSessionFrameAtTopIndex: 2 isSelector: 'to:by:do:' inBlock: false;
		assertSessionFrameAtTopIndex: 3 isSelector: 'do:' inBlock: false;
		assertSessionFrameAtTopIndex: 4 isSelector: 'doLoop' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '+ 1'
			atProgramCounterRange: (42 to: 44)
			atProgramCounterMarkers: #(42 46);
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
		assertInCodersListVisuallyHighlightedString: '+ 1' atTopIndex: 1;
		assertInCodersListVisuallyHighlightedString: 'do: [ :each |
		(each + 1 + 1) printString ]' atTopIndex: 4;
		play.

	scripter gemStoneDebugger
		expandCoderAtTopIndex: 3;
		assertInCodersListVisuallyHighlightedString: 'to: to by: by do: aBlock' atTopIndex: 3;
		expandCoderAtTopIndex: 2;
		assertInCodersListVisuallyHighlightedString: 'value: i' atTopIndex: 2;
		play.

	^ scripter
]
