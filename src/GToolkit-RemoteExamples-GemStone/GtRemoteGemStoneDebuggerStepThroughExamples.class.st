"
Examples testing step-through operations on the GemStone debugger through the full UI path (scripter + debugger element).
"
Class {
	#name : #GtRemoteGemStoneDebuggerStepThroughExamples,
	#superclass : #GtRemoteGemStoneDebuggerStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
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
			atProgramCounterRange: (1 to: 1149)
			atProgramCounterMarkers: #(1 1149);
		assertSessionFrameAtTopIndex: 3
			highlightedText: '^ self'
			atProgramCounterRange: (156 to: 161)
			atProgramCounterMarkers: #(156 163);
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
		assertInCodersListVisuallyHighlightedString: '^ self' atTopIndex: 3;
		expandCoderAtTopIndex: 2;
		assertInCodersListHasHighlightAtTopIndex: 2;
		play.

	^ scripter
]
