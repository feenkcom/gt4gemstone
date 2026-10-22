"
Examples testing step-through operations on the GemStone debugger through the full UI path (scripter + debugger element).
"
Class {
	#name : #GtRemoteGemStoneDebuggerStepThroughExamples,
	#superclass : #GtRemoteGemStoneDebuggerStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggerStepThroughExamples >> doLoop_02_enterBlock [
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
			atProgramCounterMarkers: #(1140 1148);
		assertSessionFrameAtTopIndex: 3
			highlightedText: 'to: to by: by do: aBlock'
			atProgramCounterRange: (130 to: 153)
			atProgramCounterMarkers: #(130 156);
		assertSessionFrameAtTopIndex: 4
			highlightedText: 'do: [ :each |
		(each + 1 + 1) printString ]'
			atProgramCounterRange: (20 to: 63)
			atProgramCounterMarkers: #(20 63);
		assertVariable: #each equals: '1';
		play.

	scripter gemStoneDebugger
		assertInCodersListVisuallyHighlightedString: '+ 1' atTopIndex: 1;
		scrollToFrameAtTopIndex: 2;
		expandCoderAtTopIndex: 2;
		assertInCodersListVisuallyHighlightedString: 'value: i' atTopIndex: 2;
		scrollToFrameAtTopIndex: 3;
		expandCoderAtTopIndex: 3;
		assertInCodersListVisuallyHighlightedString: 'to: to by: by do: aBlock' atTopIndex: 3;
		scrollToFrameAtTopIndex: 4;
		expandCoderAtTopIndex: 4;
		assertInCodersListVisuallyHighlightedString: 'do: [ :each |
		(each + 1 + 1) printString ]' atTopIndex: 4;
		play.

	^ scripter
]

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggerStepThroughExamples >> doLoop_03_endFirstIteration [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self doLoop_02_enterBlock.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLoop' inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: ']'
			atProgramCounterRange: (62 to: 63)
			atProgramCounterMarkers: #(62 63);
		play.

	^ scripter
]

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggerStepThroughExamples >> doLoop_04_enterSecondIteration [
	"Verifies step through re-enters the loop block for a new iteration."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self doLoop_03_endFirstIteration.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLoop' inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '+ 1'
			atProgramCounterRange: (42 to: 44)
			atProgramCounterMarkers: #(42 46);
		assertVariable: #each equals: '2';
		assertInCodersListVisuallyHighlightedString: '+ 1' atTopIndex: 1;
		play.

	^ scripter
]

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggerStepThroughExamples >> doLoop_05_enterThirdIteration [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self doLoop_04_enterSecondIteration.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLoop' inBlock: true;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '+ 1'
			atProgramCounterRange: (42 to: 44)
			atProgramCounterMarkers: #(42 46);
		assertVariable: #each equals: '3';
		assertInCodersListVisuallyHighlightedString: '+ 1' atTopIndex: 1;
		play.

	^ scripter
]

{ #category : #'examples - do loop' }
GtRemoteGemStoneDebuggerStepThroughExamples >> doLoop_06_selectCallerAndStepThrough [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self doLoop_02_enterBlock.

	scripter gemStoneDebugger
		assertVariable: #each equals: '1';
		play.

	scripter gemStoneDebugger
		selectFrameAtTopIndex: 4;
		play.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLoop' inBlock: true;
		play.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doLoop' inBlock: true;
		assertVariable: #each equals: '2';
		play.

	^ scripter
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggerStepThroughExamples >> multipleMethodCalls_02_stepThroughStatements [
	"Verifies step through without blocks behaves as step over."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self multipleMethodCalls_01_enterMethod.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: 'helperMethod: a'
			atProgramCounterRange: (73 to: 87)
			atProgramCounterMarkers: #(73 93);
		assertVariable: #a equals: '7';
		play.

	^ scripter
]

{ #category : #'examples - multiple method calls' }
GtRemoteGemStoneDebuggerStepThroughExamples >> multipleMethodCalls_03_exitMethod [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self multipleMethodCalls_02_stepThroughStatements.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 notSelector: 'doMultipleMethodCalls';
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggerStepThroughExamples >> nestedBlocks_02_enterOuterBlock [
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
		assertSessionFrameAtTopIndex: 2 isSelector: 'doSomething:' inBlock: false;
		assertSessionFrameAtTopIndex: 3 isSelector: 'doNestedBlocks' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '+ 1'
			atProgramCounterRange: (82 to: 84)
			atProgramCounterMarkers: #(82 94);
		assertInCodersListVisuallyHighlightedString: '+ 1' atTopIndex: 1;
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggerStepThroughExamples >> nestedBlocks_03_enterInnerBlock [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self nestedBlocks_02_enterOuterBlock.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doNestedBlocks' inBlock: true;
		assertSessionFrameAtTopIndex: 3 isSelector: 'doNestedBlocks' inBlock: true;
		assertSessionFrameAtTopIndex: 5 isSelector: 'doNestedBlocks' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '+ 2'
			atProgramCounterRange: (129 to: 131)
			atProgramCounterMarkers: #(129 132);
		assertInCodersListVisuallyHighlightedString: '+ 2' atTopIndex: 1;
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggerStepThroughExamples >> nestedBlocks_04_returnToOuterBlock [
	"Verifies that after the inner block completes, step through
	returns to the outer block, not the home method."
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self nestedBlocks_03_enterInnerBlock.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doNestedBlocks' inBlock: true;
		assertSessionFrameAtTopIndex: 2 isSelector: 'doSomething:' inBlock: false;
		assertSessionFrameAtTopIndex: 3 isSelector: 'doNestedBlocks' inBlock: false;
		assertSessionFrameAtTopIndex: 1
			highlightedText: '+ 10'
			atProgramCounterRange: (155 to: 158)
			atProgramCounterMarkers: #(155 159);
		assertInCodersListVisuallyHighlightedString: '+ 10' atTopIndex: 1;
		play.

	scripter gemStoneDebugger
		scrollToFrameAtTopIndex: 2;
		expandCoderAtTopIndex: 2;
		assertInCodersListVisuallyHighlightedString: 'value' atTopIndex: 2;
		scrollToFrameAtTopIndex: 3;
		expandCoderAtTopIndex: 3;
		assertInCodersListVisuallyHighlightedString: 'doSomething: [
		result := result + 1.
		self doSomething: [
			result := result + 2 ].
		result := result + 10 ]' atTopIndex: 3;
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneDebuggerStepThroughExamples >> nestedBlocks_05_exitMethod [
	<gtExample>
	<after: #stopServer>
	| scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	scripter := self nestedBlocks_04_returnToOuterBlock.

	scripter gemStoneDebugger
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 notSelector: 'doNestedBlocks';
		play.

	^ scripter
]
