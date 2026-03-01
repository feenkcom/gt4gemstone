Class {
	#name : #GtGemStoneClassDefinitionDiffTab,
	#superclass : #GtGemStoneClassDefinitionTab,
	#instVars : [
		'contentSelector'
	],
	#category : #'GToolkit-GemStone-Pharo-UiClassDefinition'
}

{ #category : #accessing }
GtGemStoneClassDefinitionDiffTab >> compileGsOnGt [

	classDefinitionWidget compileGsOnGt
]

{ #category : #accessing }
GtGemStoneClassDefinitionDiffTab >> compileGtOnGs [

	classDefinitionWidget compileGtOnGs
]

{ #category : #accessing }
GtGemStoneClassDefinitionDiffTab >> contentSelector [
	^ contentSelector
]

{ #category : #accessing }
GtGemStoneClassDefinitionDiffTab >> contentSelector: anObject [
	contentSelector := anObject
]

{ #category : #accessing }
GtGemStoneClassDefinitionDiffTab >> newPane [

	^ BlElement new
		constraintsDo: [ :c |
			c vertical matchParent.
			c horizontal matchParent ].
]

{ #category : #accessing }
GtGemStoneClassDefinitionDiffTab >> newToolbar [

	^ BrHorizontalPane new
		hMatchParent;
		vFitContent;
		addChild: (BrButton new
			aptitude: BrGlamorousButtonWithLabelAptitude;
			margin: (BlInsets left: 10 right: 10);
			label: 'GT -> GS';
			action: [ self compileGtOnGs ]);
		addChild: (BrButton new
			aptitude: BrGlamorousButtonWithLabelAptitude;
			margin: (BlInsets right: 10);
			label: 'GT <- GS';
			action: [ self compileGsOnGt ]);
		yourself.
]

{ #category : #accessing }
GtGemStoneClassDefinitionDiffTab >> setTabVisibility [

	self tab visibility: (self classDefinitionTool bothExistAndDefinitionsDiffer
		ifTrue: [ BlVisibility visible ]
		ifFalse: [ BlVisibility gone ])
]

{ #category : #accessing }
GtGemStoneClassDefinitionDiffTab >> updateContents [
	| diffElement |

	diffElement := (GtDiffElementWithLabelStencil new
		fromLabelText: 'GT:';
		toLabelText: 'GS:';
		shouldHideDiff: false;
		change: (contentSelector value: classDefinitionWidget);
		styler: (GtCodeDiffRBTextStyler new isForWorkspace: true)) asElement.
	self pane
		removeChildren;
		addChild: diffElement.
]
