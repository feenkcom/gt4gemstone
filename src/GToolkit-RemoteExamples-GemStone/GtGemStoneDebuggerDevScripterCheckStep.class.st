Class {
	#name : #GtGemStoneDebuggerDevScripterCheckStep,
	#superclass : #GtBasicDebuggerDevScripterCheckStep,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #assertions }
GtGemStoneDebuggerDevScripterCheckStep >> assertInCodersListHasHighlightAtTopIndex: anIndex [
	self assert
		label: 'Assert highlight exists in coder at index ', anIndex asString;
		value: [ :aCoderElement |
			| found |
			found := false.
			aCoderElement textualCoderViewModel styledText
				attributeRunsDo: [ :from :to :attrs |
					attrs do: [ :each |
						((each isKindOf: BlTextHighlightAttribute) and: [
							each id = GtSourceCoderViewModel debuggerTextHighlightId ])
							ifTrue: [ found := true ] ] ].
			found ]
		equals: true;
		// (GtExpandableContextMethodCoderId indexed: anIndex)
]

{ #category : #'assertions - visual' }
GtGemStoneDebuggerDevScripterCheckStep >> assertInCodersListVisuallyHighlightedString: aString atTopIndex: anIndex [
	super
		assertInCodersListVisuallyHighlightedString: aString withUnixLineEndings
		atTopIndex: anIndex
]

{ #category : #'assertions - variables' }
GtGemStoneDebuggerDevScripterCheckStep >> assertNoDuplicateSessionVariableNames [
	self assert
		label: 'Assert no duplicate session variable names';
		value: [ :debuggerEl |
			| names |
			names := (debuggerEl currentCallFrame safeVariablesAssociationsBasedOnIndex
				collect: [ :each | each first ]) asArray.
			names size = names asSet size ]
		equals: true;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #assertions }
GtGemStoneDebuggerDevScripterCheckStep >> assertSessionFrameAtTopIndex: anIndex atProgramCounterRange: expectedRange atProgramCounterMarkers: expectedMarkers [
	self assert
		label: 'Assert session frame ', anIndex printString, ' programCounterRange';
		value: [ :debuggerEl |
			(debuggerEl debugSession remoteStackFrames at: anIndex)
				programCounterRange ]
		equals: expectedRange;
		// GtGemStoneExpandableDebuggerElement.
	self assert
		label: 'Assert session frame ', anIndex printString, ' programCounterMarkers';
		value: [ :debuggerEl |
			(debuggerEl debugSession remoteStackFrames at: anIndex)
				programCounterMarkers ]
		equals: expectedMarkers;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #assertions }
GtGemStoneDebuggerDevScripterCheckStep >> assertSessionFrameAtTopIndex: anIndex highlightedText: expectedText [
	self assert
		label: 'Assert session frame ', anIndex printString, ' highlighted text';
		value: [ :debuggerEl |
			| frame range |
			frame := debuggerEl debugSession remoteStackFrames at: anIndex.
			range := frame programCounterRange.
			frame frameSpecification sourceString
				copyFrom: range first to: range last ]
		equals: expectedText;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #assertions }
GtGemStoneDebuggerDevScripterCheckStep >> assertSessionFrameAtTopIndex: anIndex highlightedText: expectedText atProgramCounterMarkers: expectedMarkers [
	self assert
		label: 'Assert session frame ', anIndex printString, ' programCounterMarkers';
		value: [ :debuggerEl |
			(debuggerEl debugSession remoteStackFrames at: anIndex)
				programCounterMarkers ]
		equals: expectedMarkers;
		// GtGemStoneExpandableDebuggerElement.
	self assert
		label: 'Assert session frame ', anIndex printString, ' highlighted text from markers';
		value: [ :debuggerEl |
			| frame markers |
			frame := debuggerEl debugSession remoteStackFrames at: anIndex.
			markers := frame programCounterMarkers.
			(frame frameSpecification sourceString
				copyFrom: markers first to: markers second) trimBoth ]
		equals: expectedText trimBoth;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #assertions }
GtGemStoneDebuggerDevScripterCheckStep >> assertSessionFrameAtTopIndex: anIndex highlightedText: expectedText atProgramCounterRange: expectedRange [
	self assert
		label: 'Assert session frame ', anIndex printString, ' programCounterRange';
		value: [ :debuggerEl |
			(debuggerEl debugSession remoteStackFrames at: anIndex)
				programCounterRange ]
		equals: expectedRange;
		// GtGemStoneExpandableDebuggerElement.
	self assert
		label: 'Assert session frame ', anIndex printString, ' highlighted text from range';
		value: [ :debuggerEl |
			| frame range |
			frame := debuggerEl debugSession remoteStackFrames at: anIndex.
			range := frame programCounterRange.
			(frame frameSpecification sourceString
				copyFrom: range first to: range last) trimBoth ]
		equals: expectedText trimBoth withUnixLineEndings;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #assertions }
GtGemStoneDebuggerDevScripterCheckStep >> assertSessionFrameAtTopIndex: anIndex highlightedText: expectedText atProgramCounterRange: expectedRange atProgramCounterMarkers: expectedMarkers [
	self
		assertSessionFrameAtTopIndex: anIndex
		highlightedText: expectedText
		atProgramCounterRange: expectedRange.
	self assert
		label: 'Assert session frame ', anIndex printString, ' programCounterMarkers';
		value: [ :debuggerEl |
			(debuggerEl debugSession remoteStackFrames at: anIndex)
				programCounterMarkers ]
		equals: expectedMarkers;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #assertions }
GtGemStoneDebuggerDevScripterCheckStep >> assertSessionFrameAtTopIndex: anIndex highlightedText: expectedText atRange: expectedRange [
	self
		assertSessionFrameAtTopIndex: anIndex
		highlightedText: expectedText
		atProgramCounterRange: expectedRange.
	self assert
		label: 'Assert session frame ', anIndex printString, ' programCounterMarkers matches range';
		value: [ :debuggerEl |
			(debuggerEl debugSession remoteStackFrames at: anIndex)
				programCounterMarkers ]
		equals: { expectedRange first. expectedRange last };
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #assertions }
GtGemStoneDebuggerDevScripterCheckStep >> assertSessionFrameAtTopIndex: anIndex isSelector: aSelector inBlock: aBoolean [
	self assert
		label: 'Assert session frame ', anIndex printString, ' selector';
		value: [ :debuggerEl |
			(debuggerEl debugSession remoteStackFrames at: anIndex) methodSelector ]
		equals: aSelector;
		// GtGemStoneExpandableDebuggerElement.
	self assert
		label: 'Assert session frame ', anIndex printString, ' inBlock';
		value: [ :debuggerEl |
			(debuggerEl debugSession remoteStackFrames at: anIndex) inBlock ]
		equals: aBoolean;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #'steps - assertions' }
GtGemStoneDebuggerDevScripterCheckStep >> assertSessionFrameAtTopIndex: anIndex notSelector: aSelector [
	self assert
		label: 'Assert session frame ', anIndex printString, ' not selector ', aSelector;
		value: [ :debuggerEl |
			(debuggerEl debugSession remoteStackFrames at: anIndex) methodSelector ~= aSelector ]
		equals: true;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #'assertions - variables' }
GtGemStoneDebuggerDevScripterCheckStep >> assertSessionVariable: aName equals: aValueString [
	self assert
		label: 'Assert session variable ', aName, ' value';
		value: [ :debuggerEl |
			| vars match |
			vars := debuggerEl currentCallFrame safeVariablesAssociationsBasedOnIndex.
			match := vars detect: [ :each | each first = aName ] ifNone: [ nil ].
			match ifNil: [ 'variable not found' ] ifNotNil: [ match second ] ]
		equals: aValueString;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #'assertions - variables' }
GtGemStoneDebuggerDevScripterCheckStep >> assertSessionVariableAtFrameIndex: anIndex name: aName equals: aValueString [
	self assert
		label: 'Assert variable ', aName, ' at frame ', anIndex printString;
		value: [ :debuggerEl |
			| frame vars match |
			frame := debuggerEl debugSession remoteStackFrames at: anIndex.
			vars := frame safeVariablesAssociationsBasedOnIndex.
			match := vars detect: [ :each | each first = aName ] ifNone: [ nil ].
			match ifNil: [ 'variable not found' ] ifNotNil: [ match second ] ]
		equals: aValueString;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #'assertions - variables' }
GtGemStoneDebuggerDevScripterCheckStep >> assertSessionVariableNames: expectedNames [
	self assert
		label: 'Assert session variable names';
		value: [ :debuggerEl |
			(debuggerEl currentCallFrame safeVariablesAssociationsBasedOnIndex
				collect: [ :each | each first ]) asArray ]
		equals: expectedNames asArray;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #'assertions - variables' }
GtGemStoneDebuggerDevScripterCheckStep >> assertSessionVariableNamesAtFrameIndex: anIndex equals: expectedNames [
	self assert
		label: 'Assert session variable names at frame ', anIndex printString;
		value: [ :debuggerEl |
			| frame |
			frame := debuggerEl debugSession remoteStackFrames at: anIndex.
			(frame safeVariablesAssociationsBasedOnIndex
				collect: [ :each | each first ]) asArray ]
		equals: expectedNames asArray;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #'assertions - variables' }
GtGemStoneDebuggerDevScripterCheckStep >> assertVariable: aName equals: aValueString [
	self assertSessionVariable: aName equals: aValueString.
	self assertVisualVariable: aName equals: aValueString
]

{ #category : #'assertions - variables' }
GtGemStoneDebuggerDevScripterCheckStep >> assertVariableNames: expectedNames [
	self assertSessionVariableNames: expectedNames.
	self assertVisualVariableNames: expectedNames
]

{ #category : #'steps - assertions' }
GtGemStoneDebuggerDevScripterCheckStep >> assertVisualVariable: aName equals: aValueString [
	self assert
		label: 'Assert visual variable ', aName, ' value';
		value: [ :debuggerEl |
			| items match |
			items := debuggerEl variableListItems.
			match := items detect: [ :each | each first = aName ] ifNone: [ nil ].
			match ifNil: [ 'variable not found' ] ifNotNil: [ match second ] ]
		equals: aValueString;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #'steps - assertions' }
GtGemStoneDebuggerDevScripterCheckStep >> assertVisualVariableNames: expectedNames [
	self assert
		label: 'Assert visual variable names';
		value: [ :debuggerEl |
			(debuggerEl variableListItems collect: [ :each | each first ]) asArray ]
		equals: expectedNames asArray;
		// GtGemStoneExpandableDebuggerElement
]

{ #category : #'actions - stack' }
GtGemStoneDebuggerDevScripterCheckStep >> clickInsideCoderAtTopIndex: anIndex [
	self click
		label: 'Click inside coder at frame ', anIndex printString;
		// (GtExpandableContextMethodCoderId indexed: anIndex)
]

{ #category : #accessing }
GtGemStoneDebuggerDevScripterCheckStep >> debggerToolbarId [
	^GtGemStoneExpandableDebuggerToolbar
]

{ #category : #'actions - variables' }
GtGemStoneDebuggerDevScripterCheckStep >> doubleClickOnVariableNamed: aName [
	self doubleClick
		label: 'Double-click on variable ', aName;
		// GtGemStoneExpandableDebuggerElement;
		onChildFromBlock: [ :debuggerEl |
			| list |
			list := debuggerEl instVarNamed: 'variableList'.
			list withAllChildrenBreadthFirst
				detect: [ :el |
					(el isKindOf: BrLabel) and: [
						el text asString = aName ] ] ]
]

{ #category : #'actions - stack' }
GtGemStoneDebuggerDevScripterCheckStep >> expandCoderAtTopIndex: anIndex [
	self click
		label: 'Expand coder at frame ', anIndex printString;
		// (GtExpandableContextMethodCoderId indexed: anIndex);
		// GtSourceCoderExpanderToggleId
]

{ #category : #steps }
GtGemStoneDebuggerDevScripterCheckStep >> moveCursorTo: aPosition [
	self
		substeps2: 'Move cursor to position ', aPosition printString
		do: [ :aStep |
			aStep do
				label: 'Move cursor';
				action: [ :aStackElement |
					aStackElement selectedCoderUIModel
						moveCursorTo: aPosition ];
				// GtGemStoneExpandableStackElement ]
]

{ #category : #steps }
GtGemStoneDebuggerDevScripterCheckStep >> moveCursorTo: aPosition atTopIndex: anIndex [
	self
		substeps2: 'Move cursor to position ', aPosition printString
		do: [ :aStep |
			aStep do
				label: 'Move cursor';
				action: [ :anEditorElement |
					anEditorElement editor moveCursorTo: aPosition ];
				// (GtExpandableContextMethodCoderId indexed: anIndex);
				// GtSourceCoderEditorId ]
]

{ #category : #'actions - stack' }
GtGemStoneDebuggerDevScripterCheckStep >> scrollToFrameAtTopIndex: anIndex [
	self do
		label: 'Scroll to frame ', anIndex printString;
		action: [ :aStackElement |
			aStackElement stackFramesList scrollToIndex: anIndex offset: 0 ];
		// GtGemStoneExpandableStackElement
]

{ #category : #'actions - stack' }
GtGemStoneDebuggerDevScripterCheckStep >> selectFrameAtTopIndex: anIndex [
	self
		substeps2: 'Select frame at index ', anIndex printString
		do: [ :aStep |
			aStep do
				label: 'Scroll to frame';
				action: [ :aStackElement |
					aStackElement stackFramesList scrollToIndex: anIndex offset: 0 ];
				// GtGemStoneExpandableStackElement.
			aStep click
				label: 'Expand frame coder';
				// (GtExpandableContextMethodCoderId indexed: anIndex);
				// GtSourceCoderExpanderToggleId.
			aStep click
				label: 'Click inside frame coder';
				// (GtExpandableContextMethodCoderId indexed: anIndex) ]
]
