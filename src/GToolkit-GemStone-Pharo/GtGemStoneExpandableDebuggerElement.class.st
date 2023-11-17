Class {
	#name : #GtGemStoneExpandableDebuggerElement,
	#superclass : #GtGemStoneDebuggerElement,
	#instVars : [
		'mainTab'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement class >> registerToolsOn: registry [
	"self register"
	registry registerDebugger: self withRank: 901.
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> actOnSelectedContextChangedFor: aContext [
	self updateVariables.
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> buildLeftPane [
	| leftPane |
	leftPane := BrVerticalPane new
		matchParent;
		constraintsDo: [ :c | c linear weight: 2 ].
	callFramesList := self buildStackElement.
	leftPane
		addChild: callFramesList.
	^ leftPane
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> buildMainContent [
	| container mainPane panesTabGroupElement |
	"container := BrVerticalPane new matchParent."
	
	mainPane := self buildPanesStructure.
	toolbar := self newToolbar.

	panesTabGroupElement := self
			buildStackTabGroupForElement: mainPane
			withToolbar: toolbar.
	
	^ panesTabGroupElement
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> buildRightPane [
	| rightPane rightTabGroup |
	rightPane := BrVerticalPane new
			matchParent;
			constraintsDo: [ :c | c linear weight: 0.7 ].
	rightTabGroup := self newRightTabGroup.
	rightPane
		addChild: rightTabGroup.
	^ rightPane
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> buildStackElement [
	| newStackElement |
	newStackElement := GtGemStoneExpandableStackElement new.
	newStackElement containerName: #stackElement.
	^ newStackElement
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> buildStackTabGroupForElement: aStackContainerElement withToolbar: anObject [
	| tabGroup |
	mainTab := BrTab new.
	mainTab
		aptitude: BrGlamorousTabWithoutBarAptitude;
		label: '';
		stencil: (BrValuableStencil from: aStackContainerElement);
		padding: (BlInsets top: 15 right: 0 bottom: 15 left: 10);
		toolbarStencil: [ anObject ].
	tabGroup := BrTabGroup new.
	tabGroup
		aptitude:
			(BrGlamorousTabGroupAptitude new
				headerBackground: self theme header defaultBackgroundColor);
		addTab: mainTab;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		addChild:
			(BlElement new
				constraintsDo: [ :c | 
					c ignoreByLayout.
					c horizontal matchParent.
					c vertical exact: 5 ];
				background: self theme status errorBackgroundColor;
				yourself).
	^ tabGroup
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> currentCallFrame [
	^ callFramesList selectedContext
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> newRightTabGroup [

	^ BrTabGroup new 
		aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude;
		margin: (BlInsets all: self defaultMargin);
		background: Color white;
		"addTab: self summaryTab;"
		addTab: self variablesTab;
		addTab: self stdoutTab.
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> updateCallFrame [
	
	callFramesList updateForSession: debuggingSession
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> updateDisplay [ 

	self updateMainTabLabel.
	self updateCallFrame.
	self updateVariables.
	self updateStdout.
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> updateMainTabLabel [
	mainTab label: self debuggerClient messageText.
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> updateUI [

	self updateDisplay.
	toolbar updateUI.
]
