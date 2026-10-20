Class {
	#name : #GtRemoteGemStoneContextVariablesDebuggerExamples,
	#superclass : #GtRemoteGemStoneDebuggerStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - method with args' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> methodWithArgs_00_haltAtStart [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession scripter |

	gemstoneSession := self runningServer.
	scripter := self
		scripterWithDebuggerOn: [
			gemstoneSession evaluateBlockAndWait: [
				nil halt. GtRemotePhlowDebuggerStepTestObject new doMethodWithArgs: 3 extra: 7 ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: nil inBlock: true;
		play.

	^ scripter
]

{ #category : #'examples - method with args' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> methodWithArgs_01_enterMethod [
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self methodWithArgs_00_haltAtStart.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		clickOnStepIntoButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMethodWithArgs:extra:' inBlock: false;
		play.

	^ scripter
]

{ #category : #'examples - method with args' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> methodWithArgs_02_stepToHalt [
	"After stepping to the halt inside doMethodWithArgs:extra:, verify variable names and values.
	GemStone stores the computed temp in .t1 rather than in the named temp slot."
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self methodWithArgs_01_enterMethod.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMethodWithArgs:extra:' inBlock: false;
		assertVariableNames: #(#self #receiver '.t1' #anotherValue #aValue #temp #slotA #slotB);
		assertVariable: #aValue equals: '3';
		assertVariable: #anotherValue equals: '7';
		assertVariable: '.t1' equals: '10';
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> nestedBlocks_00_haltInInnerBlock [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession scripter |

	gemstoneSession := self runningServer.
	scripter := self
		scripterWithDebuggerOn: [
			gemstoneSession evaluateBlockAndWait: [
				GtRemotePhlowDebuggerStepTestObject new doNestedBlocksWithVariables ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doNestedBlocksWithVariables' inBlock: true;
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> nestedBlocks_01_checkInnerBlockVariables [
	"Verifies that the innermost block frame shows the correct variables
	from both the inner and outer block scopes."
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self nestedBlocks_00_haltInInnerBlock.

	scripter gemStoneDebugger
		assertNoDuplicateSessionVariableNames;
		assertVariableNames: #(#receiver #b #innerVar #midVar);
		assertVariable: #b equals: '3';
		assertVariable: #innerVar equals: '18';
		assertVariable: #midVar equals: '15';
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> nestedBlocks_02_checkOuterBlockVariables [
	"Frame 2 (outer block) should show a different set of variables
	than frame 1 (inner block), confirming each frame has its own scope."
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self nestedBlocks_01_checkInnerBlockVariables.

	scripter gemStoneDebugger
		assertSessionVariableNamesAtFrameIndex: 2 equals: #(#receiver '.t1' #a #midVar #outerVar);
		assertSessionVariableAtFrameIndex: 2 name: #a equals: '5';
		assertSessionVariableAtFrameIndex: 2 name: #midVar equals: '15';
		assertSessionVariableAtFrameIndex: 2 name: #outerVar equals: '10';
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> nestedBlocks_03_scrollAndExpandDoNotUpdateVariables [
	"Scrolling to and expanding a frame does not update the Variables pane.
	Only clicking inside the expanded coder triggers the variable update."
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self nestedBlocks_01_checkInnerBlockVariables.

	scripter gemStoneDebugger
		scrollToFrameAtTopIndex: 2;
		expandCoderAtTopIndex: 2;
		assertVisualVariableNames: #(#receiver #b #innerVar #midVar);
		play.

	scripter gemStoneDebugger
		clickInsideCoderAtTopIndex: 2;
		assertVisualVariableNames: #(#receiver '.t1' #a #midVar #outerVar);
		play.

	^ scripter
]

{ #category : #'examples - nested blocks' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> nestedBlocks_04_selectFrameUpdatesVariables [
	"selectFrameAtTopIndex: expands and clicks in one step,
	updating the Variables pane to the selected frame."
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self nestedBlocks_01_checkInnerBlockVariables.

	scripter gemStoneDebugger
		selectFrameAtTopIndex: 2;
		assertVariableNames: #(#receiver '.t1' #a #midVar #outerVar);
		assertVariable: #a equals: '5';
		assertVariable: #midVar equals: '15';
		assertVariable: #outerVar equals: '10';
		play.

	^ scripter
]

{ #category : #'examples - object slots' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> objectSlots_00_haltInMethod [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession scripter |

	gemstoneSession := self runningServer.
	scripter := self
		scripterWithDebuggerInPagerOn: [
			gemstoneSession evaluateBlockAndWait: [
				GtRemotePhlowDebuggerStepTestObject new doMethodWithSlots ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMethodWithSlots' inBlock: false;
		play.

	^ scripter
]

{ #category : #'examples - object slots' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> objectSlots_01_checkSlotVariables [
	"Verifies that object instance variables (slotA, slotB) appear in the variables list."
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self objectSlots_00_haltInMethod.

	scripter gemStoneDebugger
		assertVariableNames: #(#self #receiver #slotA #slotB);
		assertVariable: #slotA equals: 'hello';
		assertVariable: #slotB equals: '42';
		play.

	^ scripter
]

{ #category : #'examples - object slots' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> objectSlots_02_doubleClickOpensObject [
	"Double-clicking a variable in the Variables pane opens an inspector
	in the second pager pane with the correct remote object."
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self objectSlots_01_checkSlotVariables.

	scripter gemStoneDebugger
		doubleClickOnVariableNamed: #self;
		play.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertInspectedObjectOfType: GtGsBareProxy;
		assertInspectedObjectValueFor: [ :obj | obj remoteClass ]
			equals: [ 'GtRemotePhlowDebuggerStepTestObject' ];
		play.

	^ scripter
]

{ #category : #'examples - shared temp' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> sharedTemp_00_haltInBlock [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession scripter |

	gemstoneSession := self runningServer.
	scripter := self
		scripterWithDebuggerOn: [
			gemstoneSession evaluateBlockAndWait: [
				GtRemotePhlowDebuggerStepTestObject new doBlockWithSharedTemp ] ]
		withException: GtRsrEvaluationException.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doBlockWithSharedTemp' inBlock: true;
		play.

	^ scripter
]

{ #category : #'examples - shared temp' }
GtRemoteGemStoneContextVariablesDebuggerExamples >> sharedTemp_01_checkVariablesNotDuplicated [
	"Verifies the deduplication fix: localA appears only once despite being
	shared with a nested block via VariableContext."
	<gtExample>
	<after: #stopServer>
	| scripter |

	scripter := self sharedTemp_00_haltInBlock.

	scripter gemStoneDebugger
		assertNoDuplicateSessionVariableNames;
		assertVariableNames: #(#receiver '.t1' #arg #localA #outerVar);
		assertVariable: #arg equals: '10';
		assertVariable: #localA equals: '52';
		assertVariable: #outerVar equals: '42';
		play.

	^ scripter
]
