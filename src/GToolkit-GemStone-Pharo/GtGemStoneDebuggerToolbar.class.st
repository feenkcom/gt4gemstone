Class {
	#name : #GtGemStoneDebuggerToolbar,
	#superclass : #GtGemStoneExpandableDebuggerToolbar,
	#instVars : [
		'debuggerMessageEditor'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #callbacks }
GtGemStoneDebuggerToolbar >> actOnDebugSessionChanged [

	super actOnDebugSessionChanged.
	debuggerMessageEditor text: dapDebugElement debuggerClient messageText.
]

{ #category : #initialization }
GtGemStoneDebuggerToolbar >> initialize [

	super initialize.
	debuggerMessageEditor := self newExceptionMessageEditor.
	self addChildFirst: debuggerMessageEditor.
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newExceptionMessageEditor [

	^ BrEditor new
		aptitude: BrGlamorousEditorAptitude;
		margin: (BlInsets all: 5);
		"background: Color white;"
		hMatchParent;
		vFitContent;
		beMode: BrTextEditorReadonlyWithoutSelectionMode new.
]
