Class {
	#name : #GtGemStoneClassDefinitionSourceTab,
	#superclass : #GtGemStoneClassDefinitionTab,
	#instVars : [
		'sourceSelector',
		'compileSelector',
		'compileLabel',
		'existsSelector'
	],
	#category : #'GToolkit-GemStone-Pharo-UiClassDefinition'
}

{ #category : #'private - actions' }
GtGemStoneClassDefinitionSourceTab >> compile [

	classDefinitionWidget perform: compileSelector with: pane text asString.
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> compileLabel [
	^ compileLabel
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> compileLabel: anObject [
	compileLabel := anObject
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> compileSelector [
	^ compileSelector
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> compileSelector: anObject [
	compileSelector := anObject
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> existsSelector [
	^ existsSelector
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> existsSelector: anObject [
	existsSelector := anObject
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> newCompileButton [

	^ BrButton new
		aptitude: BrGlamorousButtonWithLabelAptitude;
		margin: (BlInsets left: 10);
		label: compileLabel;
		action: [ self compile ].
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> newPane [

	^ BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude new;
		styler: (BrRBTextStyler new
			isForWorkspace: true);
		text: self sourceCode.
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> newToolbar [

	^ BrHorizontalPane new
		hMatchParent;
		vFitContent;
		addChild: self newCompileButton;
		yourself.
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> setTabVisibility [

	self tab visibility: ((existsSelector value: self classDefinitionTool)
		ifTrue: [ BlVisibility visible ]
		ifFalse: [ BlVisibility gone ])
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> sourceCode [
	^ sourceSelector value: classDefinitionWidget
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> sourceSelector [
	^ sourceSelector
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> sourceSelector: anObject [
	sourceSelector := anObject
]

{ #category : #accessing }
GtGemStoneClassDefinitionSourceTab >> updateContents [
	self pane text: self sourceCode
]
