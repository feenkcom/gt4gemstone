Class {
	#name : #GtGemStoneExpandableDebuggerElement,
	#superclass : #GtGemStoneDebuggerElement,
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
GtGemStoneExpandableDebuggerElement >> buildStackElement [
	| newStackElement |
	newStackElement := GtGemStoneExpandableStackElement new.
	newStackElement containerName: #stackElement.
	^ newStackElement
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

	self updateCallFrame.
	self updateVariables.
	self updateStdout.
]
