Class {
	#name : #GtGemStoneSessionSelectionElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'registry',
		'currentList',
		'state',
		'selectAction',
		'currentSessionNameComputation',
		'currentSessionDisplayLabelComputation'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #private }
GtGemStoneSessionSelectionElement >> activeMark [

	^ BlElement new
		layout: BlLinearLayout horizontal alignCenter;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		addChild: (BrGlamorousVectorIcons accept asElement)
]

{ #category : #private }
GtGemStoneSessionSelectionElement >> buildUI [

	state := #sessions.
	self 
		addChild: (currentList := self createSessionList);
		addChild: self createToolbar.
]

{ #category : #private }
GtGemStoneSessionSelectionElement >> connectorActionsFor: aConnector [

	^ BrGlamorousSimpleContextMenuContent new items: {
		'Select' -> [ :aStatusLineElement | 
			selectAction 
				cull: (registry newSessionWithConnector: aConnector) ].
		'Inspect' -> [ :aStatusLineElement | 
			aStatusLineElement phlow 
				spawnObject: aConnector ].
	}
]

{ #category : #private }
GtGemStoneSessionSelectionElement >> createConnectorList [
	| newList |
	newList := BrColumnedList new.
	newList 
		rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new);
		margin: (BlInsets top: 5 left: 10);
		matchParent.

	newList column
		title: 'Name' translated;
		width: 110;
		cellStencil: [ :each | BrLabel new 
			aptitude: BrGlamorousLabelAptitude new ];
		dataBinder: [ :aLabel :eachItem |
			aLabel parent addAptitude: 
				(BrGlamorousWithContextMenuAptitude content: 
						[ self connectorActionsFor: eachItem ]).
			aLabel text: eachItem name asRopedText ].
	newList column 
		title: 'Username' translated;
		width: 100;
		cellStencil: [ :each | 
			BrLabel new 
				aptitude: BrGlamorousLabelAptitude new ];
		dataBinder: [ :aLabel :eachItem |
			aLabel text: eachItem username ].
	newList column 
		title: 'Stone' translated;
		width: 110;
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
				selectAction cull: (registry 
					newSessionReusedOrDefaultWithConnector: selectedConnector) ] ].

	newList addAptitude: BrColumnedListHeaderAptitude.

	^ newList
]

{ #category : #private }
GtGemStoneSessionSelectionElement >> createDefaultSessionButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
		icon: BrGlamorousIcons settings;
		label: 'Use Default Session';
		margin: (BlInsets bottom: 5 right: 5);
		action: [ :theButton | self selectDefaultSessionFrom: theButton ].

]

{ #category : #private }
GtGemStoneSessionSelectionElement >> createInspectButton [

	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Inspect session registry';
		margin: (BlInsets bottom: 5 right: 5);
		action: [ :theButton | theButton phlow spawnObject: registry ]
]

{ #category : #private }
GtGemStoneSessionSelectionElement >> createNewSessionButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
		icon: BrGlamorousVectorIcons add;
		label: 'New Session';
		margin: (BlInsets bottom: 5 right: 5);
		action: [ self switchState ].

]

{ #category : #private }
GtGemStoneSessionSelectionElement >> createSessionList [
	| newList |
	newList := BrColumnedList new.

	newList
		rowStencil: (BrColumnedListItemElementWithContextMenuDecorator new
				stencilBuilder: BrGlamorousColumnedListSelectableRowElementStencilBuilder new;
				contextMenuStencil: [ :anElement :aSession | self sessionActionsFor: aSession ]);
		margin: (BlInsets top: 5 left: 10);
		matchParent.

	newList column
		title: 'Name' translated;
		width: 120;
		cellStencil: [ BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vFitContent ];
		dataBinder: [ :aLabel :aSession | 
			| sessionName sessionLabel |
			sessionName := aSession displayName.
			sessionLabel := aSession formatBasedOnStatusText: sessionName.
			Stdio stdout
				<< 'sessionName: ';
				<< sessionName asString;
				<< ', computation: ';
				<< currentSessionNameComputation value asString;
				lf.
			sessionName = currentSessionNameComputation value
				ifTrue: [ sessionLabel bold ].
			aLabel text: sessionLabel ].

	newList column
		title: 'Status';
		width: 150;
		cellStencil: [ BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vFitContent ];
		dataBinder: [ :aLabel :aSession | 
			| statusLabel |
			statusLabel := aSession formatBasedOnStatusText: aSession statusDescription.
			aSession displayName = currentSessionNameComputation value
				ifTrue: [ statusLabel bold ].
			aLabel text: statusLabel ].

	newList column
		title: 'Default';
		width: 60;
		stencil: [ :aSession | 
			aSession isDefaultSession
				ifTrue: [ self activeMark ]
				ifFalse: [ BlElement new size: 0 @ 0 ] ].

	newList
		when: BrSelectionDoubleClicked
		do: [ :anEvent | self handleSessionDoubleClick: anEvent ].

	newList addAptitude: BrColumnedListHeaderAptitude.

	^ newList
]

{ #category : #private }
GtGemStoneSessionSelectionElement >> createToolbar [

	^ BrHorizontalPane new
		hMatchParent;
		vFitContent;
		layout: BlLinearLayout horizontal alignTopRight;
		addChild: self createInspectButton as: #inspectButton;
		addChild: self createNewSessionButton as: #newSessionButton;
		addChild: self createDefaultSessionButton as: #defaultSessionButton;
		yourself.
]

{ #category : #accessing }
GtGemStoneSessionSelectionElement >> currentSessionDisplayLabelComputation [
	^ currentSessionDisplayLabelComputation
]

{ #category : #accessing }
GtGemStoneSessionSelectionElement >> currentSessionDisplayLabelComputation: anObject [
	currentSessionDisplayLabelComputation := anObject
]

{ #category : #accessing }
GtGemStoneSessionSelectionElement >> currentSessionNameComputation [
	^ currentSessionNameComputation
]

{ #category : #accessing }
GtGemStoneSessionSelectionElement >> currentSessionNameComputation: anObject [
	currentSessionNameComputation := anObject
]

{ #category : #private }
GtGemStoneSessionSelectionElement >> handleSessionDoubleClick: anEvent [
	^ anEvent selection ifNotEmpty: [ :theIndices | 
		| aWidgetElement selectedSession |
		aWidgetElement := anEvent currentTarget.
		selectedSession := aWidgetElement viewModel itemAt: theIndices first.
		Stdio stdout
			<< 'selecting: ';
			<< selectedSession printString;
			lf.
		selectAction cull: selectedSession ]
]

{ #category : #initialize }
GtGemStoneSessionSelectionElement >> initialize [

	super initialize.
	self buildUI.
]

{ #category : #private }
GtGemStoneSessionSelectionElement >> newSessionButtonLabel [

	^ state = #sessions
		ifTrue: [ 'New Session' ]
		ifFalse: [ 'Existing Session' ]
]

{ #category : #'private - hooks' }
GtGemStoneSessionSelectionElement >> onAddedToSceneGraph [

	super onAddedToSceneGraph.
	self updateContent.
]

{ #category : #accessing }
GtGemStoneSessionSelectionElement >> registry [
	^ registry
]

{ #category : #accessing }
GtGemStoneSessionSelectionElement >> registry: anObject [
	registry := anObject
]

{ #category : #accessing }
GtGemStoneSessionSelectionElement >> selectAction [
	^ selectAction
]

{ #category : #accessing }
GtGemStoneSessionSelectionElement >> selectAction: anObject [
	selectAction := anObject
]

{ #category : #private }
GtGemStoneSessionSelectionElement >> selectDefaultSessionFrom: aButton [ 

	selectAction
		cull: (GtGemStoneDefaultSessionIdentifier new)
		cull: aButton
]

{ #category : #accessing }
GtGemStoneSessionSelectionElement >> sessionActionsFor: aGtGemStoneSession [
	| actions |
	aGtGemStoneSession class = GtGemStoneCardWidgetNoSessions ifTrue: [ 
		^ BrGlamorousSimpleContextMenuContent new ].
		
	actions := OrderedCollection new.
	
	actions addAll: {
		'Select' -> [ :aStatusLineElement | 
			selectAction cull: aGtGemStoneSession ]}.
			
	aGtGemStoneSession isRunning 
		ifTrue: [
			actions addAll: {
				'Commit' -> [ :aStatusLineElement | 
					aGtGemStoneSession commitTransaction ].
				'Abort' -> [ :aStatusLineElement | 
					aGtGemStoneSession abortTransaction ].
				'Disconnect' -> [ :aStatusLineElement | 
					aGtGemStoneSession close ]} ]
		ifFalse: [
			actions addAll: {
				'Connect' -> [ :aStatusLineElement | 
					aGtGemStoneSession connect ]} ].
		
	aGtGemStoneSession isDefaultSession ifFalse: [
		actions addAll: {
			'Be Default' -> [ :aStatusLineElement | 
				aGtGemStoneSession beDefaultSession.
				selectAction cull: aGtGemStoneSession ] } ].
	
	actions addAll: {
		'Toggle AutoCommit' -> [:aStatusLineElement |
			aGtGemStoneSession toggleAutoCommit ].
		'Toggle CodeSync' -> [:aStatusLineElement |
			aGtGemStoneSession toggleCodeSync ].
		'Toggle CodeSync & AutoCommit' -> [:aStatusLineElement |
			aGtGemStoneSession toggleCodeSyncAndAutoCommit ].
		'Inspect' -> [ :aStatusLineElement | 
			aStatusLineElement phlow spawnObject: aGtGemStoneSession ] }.

	^ BrGlamorousSimpleContextMenuContent new 
		items: actions
]

{ #category : #accessing }
GtGemStoneSessionSelectionElement >> state [
	^ state
]

{ #category : #accessing }
GtGemStoneSessionSelectionElement >> state: aSymbol [

	state = aSymbol ifTrue: [ ^ self ].
	(#(sessions connectors) includes: aSymbol) ifFalse:
		[ self error: 'Invalid state: ', aSymbol ].
	state := aSymbol.
	currentList removeFromParent.
	state = #sessions 
		ifTrue: [ self addChildFirst: (currentList := self createSessionList) ]
		ifFalse: [ self addChildFirst: (currentList := self createConnectorList) ].
	self updateContent.
]

{ #category : #private }
GtGemStoneSessionSelectionElement >> switchState [

	self state: (state = #sessions
		ifTrue: [ #connectors ]
		ifFalse: [ #sessions ])
]

{ #category : #private }
GtGemStoneSessionSelectionElement >> updateContent [
	| items |

	items := state = #sessions ifTrue:
		[ self registry activeSessions ifEmpty:
			[ { GtGemStoneCardWidgetNoSessions new } ] ]
	ifFalse: [ state = #connectors ifTrue:
		[ self registry connectors 
			ifNil: [ #() ]
			ifNotNil: #values ] ].
	items := items sorted: #name ascending.
	currentList items: items.
	(self childNamed: #newSessionButton) label: self newSessionButtonLabel.
]
