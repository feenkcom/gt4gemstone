Class {
	#name : #GtGemStoneClassDefinitionWidget,
	#superclass : #BrVerticalPane,
	#instVars : [
		'classDefinitionTool',
		'classDefinitionTabs',
		'currentTab',
		'toolbarContainer'
	],
	#category : #'GToolkit-GemStone-Pharo-UiClassDefinition'
}

{ #category : #'private - ui' }
GtGemStoneClassDefinitionWidget >> addTabsTo: aTabGroup [

	self classDefinitionTabs do: [ :each |
		aTabGroup addTab: each tab ].
]

{ #category : #'private - ui' }
GtGemStoneClassDefinitionWidget >> buildUI [
	| tabGroup |

	toolbarContainer := self newToolBarContainer.
	tabGroup := self newTabGroup.
	self addTabsTo: tabGroup.

	self
		addChild: tabGroup;
		addChild: toolbarContainer.
]

{ #category : #accessing }
GtGemStoneClassDefinitionWidget >> classDefinitionTabs [

	^ classDefinitionTabs ifNil: [ classDefinitionTabs := self newClassDefinitionTabs ]
]

{ #category : #accessing }
GtGemStoneClassDefinitionWidget >> classDefinitionTool [
	^ classDefinitionTool
]

{ #category : #accessing }
GtGemStoneClassDefinitionWidget >> classDefinitionTool: aGtGemStoneClassDefinitionTool [

	classDefinitionTool := aGtGemStoneClassDefinitionTool.
	self enqueueTask: (BlTaskAction new action: 
		[ (currentTab ifNil: [ currentTab := self classDefinitionTabs first ]) updateContents ]).
]

{ #category : #'private - actions' }
GtGemStoneClassDefinitionWidget >> compileGs: code [

	classDefinitionTool compileGs: code.
	self updateCurrent.
]

{ #category : #'private - actions' }
GtGemStoneClassDefinitionWidget >> compileGsOnGt [

	self compileGt: self gtDefinitionStringFromGs
]

{ #category : #'private - actions' }
GtGemStoneClassDefinitionWidget >> compileGt: definitionCode [

	classDefinitionTool compileGt: definitionCode.
	self updateCurrent.
]

{ #category : #'private - actions' }
GtGemStoneClassDefinitionWidget >> compileGtOnGs [

	self compileGs: self gsDefinitionStringFromGt
]

{ #category : #'private - ui' }
GtGemStoneClassDefinitionWidget >> definitionTabLabel: labelString sourceSelector: sourceSelector compileSelector: compileSelector compileLabel: compileLabel existsSelector: existsSelector [

	^ GtGemStoneClassDefinitionSourceTab new
		classDefinitionWidget: self;
		label: labelString;
		sourceSelector: sourceSelector;
		compileSelector: compileSelector;
		existsSelector: existsSelector;
		compileLabel: compileLabel
]

{ #category : #'private - ui' }
GtGemStoneClassDefinitionWidget >> diffTabLabel: labelString contentSelector: contentSelector [

	^ GtGemStoneClassDefinitionDiffTab new
		classDefinitionWidget: self;
		label: labelString;
		contentSelector: contentSelector.
]

{ #category : #'private - accessing' }
GtGemStoneClassDefinitionWidget >> gsDefinitionString [

	^ classDefinitionTool gsDefinitionString
]

{ #category : #'private - accessing' }
GtGemStoneClassDefinitionWidget >> gsDefinitionStringFromGt [

	^ classDefinitionTool gsDefinitionStringFromGt
]

{ #category : #'private - accessing' }
GtGemStoneClassDefinitionWidget >> gsDiff [
	| gtDefinitionString gsDefinitionString |

	gtDefinitionString := self gsDefinitionStringFromGt.
	gsDefinitionString := self gsDefinitionString.

	^ GtDiffBuilder
		computeDifferencesFrom: gtDefinitionString
		to: gsDefinitionString
		using: GtSmaCCDiffSplitter forPharo.
]

{ #category : #'private - accessing' }
GtGemStoneClassDefinitionWidget >> gtDefinitionString [

	^ classDefinitionTool
		ifNil: [ 'N/A' ]
		ifNotNil: [ classDefinitionTool gtDefinitionString ]
]

{ #category : #'private - accessing' }
GtGemStoneClassDefinitionWidget >> gtDefinitionStringFromGs [

	^ classDefinitionTool gtDefinitionStringFromGs
]

{ #category : #'private - accessing' }
GtGemStoneClassDefinitionWidget >> gtDiff [
	| gtDefinitionString gsDefinitionString |

	gtDefinitionString := self gtDefinitionString.
	gsDefinitionString := self gtDefinitionStringFromGs.

	^ GtDiffBuilder
		computeDifferencesFrom: gtDefinitionString
		to: gsDefinitionString
		using: GtSmaCCDiffSplitter forPharo.
]

{ #category : #initialize }
GtGemStoneClassDefinitionWidget >> initialize [

	super initialize.
	self matchParent.

	self buildUI.
]

{ #category : #accessing }
GtGemStoneClassDefinitionWidget >> newClassDefinitionTabs [

	^ {
		self definitionTabLabel: 'GT definition' 
			sourceSelector: #gtDefinitionString 
			compileSelector: #compileGt:
			compileLabel: 'Compile to GT'
			existsSelector: #gtClassExists.
		self definitionTabLabel: 'GS definition' 
			sourceSelector: #gsDefinitionString 
			compileSelector: #compileGs:
			compileLabel: 'Compile to GS'
			existsSelector: #gsClassExists.
		self diffTabLabel: 'GT diff' 
			contentSelector: #gtDiff.
		self diffTabLabel: 'GS diff' 
			contentSelector: #gsDiff.
		self definitionTabLabel: 'GT -> GS' 
			sourceSelector: #gsDefinitionStringFromGt 
			compileSelector: #compileGs:
			compileLabel: 'Compile to GS'
			existsSelector: #gtExistsAndDefinitionsDiffer.
		self definitionTabLabel: 'GT <- GS' 
			sourceSelector: #gtDefinitionStringFromGs 
			compileSelector: #compileGt:
			compileLabel: 'Compile to GT'
			existsSelector: #gsExistsAndDefinitionsDiffer.
	}
]

{ #category : #'private - ui' }
GtGemStoneClassDefinitionWidget >> newTabGroup [

	^ BrTabGroup new
		aptitude: BrGlamorousTabGroupAptitude new;
		when: BrTabSelectedEvent do: [ :event | 
			self selectTab: event ];
		yourself.
]

{ #category : #'private - ui' }
GtGemStoneClassDefinitionWidget >> newToolBarContainer [

	^ BlElement new
		constraintsDo: [ :c |
			c vertical exact: 50.
			c horizontal matchParent ].
]

{ #category : #'hooks - children' }
GtGemStoneClassDefinitionWidget >> onAddedToSceneGraph [

	super onAddedToSceneGraph.
	self updateCurrent.
]

{ #category : #'private - ui' }
GtGemStoneClassDefinitionWidget >> selectTab: anEvent [

	classDefinitionTool ifNil: [ ^ self ].
	currentTab := anEvent tab widget userData at: #gsDefinitionTab.
	currentTab updateContents.
	toolbarContainer
		removeChildren;
		addChild: currentTab toolbar.
]

{ #category : #'private - ui' }
GtGemStoneClassDefinitionWidget >> updateCurrent [

	currentTab ifNotNil: [ currentTab updateContents ].
	classDefinitionTabs do: #setTabVisibility.
]
