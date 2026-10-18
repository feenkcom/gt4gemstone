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
			| attributes found |
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
		equals: expectedText trimBoth;
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

{ #category : #accessing }
GtGemStoneDebuggerDevScripterCheckStep >> debggerToolbarId [
	^GtGemStoneExpandableDebuggerToolbar
]

{ #category : #actions }
GtGemStoneDebuggerDevScripterCheckStep >> expandCoderAtTopIndex: anIndex [
	self
		substeps2: 'Expand coder at index ', anIndex printString
		do: [ :aStep |
			aStep do
				label: 'Expand coder ', anIndex printString;
				action: [ :aCoderElement | aCoderElement expand ];
				// (GtExpandableContextMethodCoderId indexed: anIndex) ]
]
