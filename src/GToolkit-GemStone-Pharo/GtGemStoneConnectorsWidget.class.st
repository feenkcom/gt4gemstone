Class {
	#name : #GtGemStoneConnectorsWidget,
	#superclass : #BrVerticalPane,
	#instVars : [
		'connectorsList',
		'sessionsRegistry',
		'actionCallback'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #callbacks }
GtGemStoneConnectorsWidget >> actOnConnectorSelected: aGemStoneConnector [ 
	actionCallback value: aGemStoneConnector
]

{ #category : #accessing }
GtGemStoneConnectorsWidget >> actionCallback: aBlockClosure [
	actionCallback := aBlockClosure
]

{ #category : #'building widgets' }
GtGemStoneConnectorsWidget >> createConnectorList [
	| newList |
	
	newList := BrColumnedList new.
	newList 
		rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new).

	newList column
		title: 'Name';
		width: 130;
		cellStencil: [ 
			GtPhlowLabelWithIcon new ];
		dataBinder: [ :anElement :eachItem | 
			anElement 
				initializeWithIcon: (self 
					iconForSymbol: eachItem iconName)
				label: eachItem name ].
	newList column 
		title: 'Username';
		width: 120;
		cellStencil: [ :each | 
			BrLabel new 
				aptitude: BrGlamorousLabelAptitude new ];
		dataBinder: [ :aLabel :eachItem |
			aLabel text: eachItem username ].
	newList column 
		title: 'Host';
		width: 120;
		cellStencil: [ :each | 
			BrLabel new 
				aptitude: BrGlamorousLabelAptitude new ];
		dataBinder: [ :aLabel :eachItem |
			aLabel text: eachItem host ].
	newList column 
		title: 'Stone';
		width: 120;
		cellStencil: [ :each | 
			BrLabel new 
				aptitude: BrGlamorousLabelAptitude new ];
		dataBinder: [ :aLabel :eachItem |
			aLabel text: eachItem stoneName ].
	newList column 
		title: 'Version';
		width: 60;
		cellStencil: [ :each | 
			BrLabel new 
				aptitude: BrGlamorousLabelAptitude new ];
		dataBinder: [ :aLabel :eachItem |
			aLabel text: (eachItem versionString ifNil: [ '-' ]) ].

	newList
		when: BrSelectionDoubleClicked
		do: [ :anEvent | 
			anEvent selection ifNotEmpty: [ :theIndices | 
				| aWidgetElement selectedConnector |
				aWidgetElement := anEvent currentTarget.
				selectedConnector := aWidgetElement viewModel
					itemAt: theIndices first.
				self actOnConnectorSelected: selectedConnector.
				
				anEvent target fireEvent: BrDropdownHideWish new] ].

	newList addAptitude: BrColumnedListHeaderAptitude.

	^ newList
]

{ #category : #'building widgets' }
GtGemStoneConnectorsWidget >> createRebuildConnectorsButton [
	^BrButton new
		aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
		addAptitude: (BrGlamorousWithExplicitTooltipAptitude 
			text: 'Rebuild the list of connectors');
		icon: BrGlamorousVectorIcons refresh;
		label: 'Rebuild';
		id: GtGemStoneConnectorsWidgetRebuildConnectorsButtonId ;
		beTinySize;
		action: [ :aButtonElement :aButtonModel :anEvent | 
			self rebuildConnectorsList ];
		yourself
]

{ #category : #'building widgets' }
GtGemStoneConnectorsWidget >> createToolbarElement [
	| refreshButton |
	
	refreshButton := self createRebuildConnectorsButton.
	^ BrToolbar new
			aptitude: BrGlamorousToolbarAptitude;
			addItem: refreshButton;
			padding: (BlInsets all: 8 );
			yourself
]

{ #category : #utils }
GtGemStoneConnectorsWidget >> iconForSymbol: anIconName [ 
	
	^ [ 
		anIconName 
			ifNil: [ BrGlamorousVectorIcons gemStone ]
			ifNotNil: [ (BrGlamorousVectorIcons classSide 
			includesSelector: anIconName asSymbol)
				ifTrue: [ BrGlamorousVectorIcons perform: anIconName asSymbol ]
				ifFalse:  [ 
					self gtSafeIconNamed: anIconName ] ]
	] on: Error do: [ :error | 
		Smalltalk ui icons iconNamed: #smallWarningIcon ]
]

{ #category : #initialization }
GtGemStoneConnectorsWidget >> initialize [
	super initialize.
	
	self matchParent.
	
	self initializeContent.
]

{ #category : #initialization }
GtGemStoneConnectorsWidget >> initializeContent [
	| toolbarElement |

	connectorsList := self createConnectorList.
	connectorsList 
		matchParent;
		padding: (BlInsets left: 10 right: 10).
					
	toolbarElement := self createToolbarElement.
					
	self 
		addChild: connectorsList;
		addChild: toolbarElement.
]

{ #category : #updating }
GtGemStoneConnectorsWidget >> rebuildConnectorsList [
	self sessionsRegistry resetConnectors.
	self updateConnectorsList
]

{ #category : #accessing }
GtGemStoneConnectorsWidget >> sessionsRegistry [
	^sessionsRegistry
]

{ #category : #accessing }
GtGemStoneConnectorsWidget >> sessionsRegistry: aSessionsRegistry [
	sessionsRegistry := aSessionsRegistry.
	self updateConnectorsList.
]

{ #category : #updating }
GtGemStoneConnectorsWidget >> updateConnectorsList [
	connectorsList items: (self sessionsRegistry connectors
			sorted: #name ascending)
]
