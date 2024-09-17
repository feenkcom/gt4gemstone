Class {
	#name : #GtGemStoneSessionsCardWidget,
	#superclass : #BrVerticalPane,
	#instVars : [
		'registry',
		'sessionList'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #'instance creation' }
GtGemStoneSessionsCardWidget class >> addToHomeSectionCardsContainer: cardsContainer in: aGtHomeSection [

	cardsContainer
		addChild: (BrFrame new
			background: Color white;
			aptitude: BrShadowAptitude new beLarge;
			geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
			padding: (BlInsets top: 0 bottom: 10 left: 10 right: 10);
			margin: (BlInsets
				top: aGtHomeSection spaceGap
				left: 2 * aGtHomeSection spaceGap
				bottom: 2 * aGtHomeSection spaceGap
				right: 2 * aGtHomeSection spaceGap);
			size: 325 @ 150;
			addChild: (self new
				matchParent;
				constraintsDo: [ :c | 
					c frame horizontal alignLeft.
					c frame vertical alignCenter ]))
]

{ #category : #private }
GtGemStoneSessionsCardWidget >> activeMark [

	^ BlElement new
		layout: BlLinearLayout horizontal alignCenter;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		addChild: (BrGlamorousVectorIcons accept asElement)
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> buildContent [

	self
		addChild: (sessionList := self createList);
		addChild: self createToolbar
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> createAddNewDefaultSessionButton [
	| selectionButton |
	
	selectionButton := BrButton new.
	selectionButton 
		icon: BrGlamorousVectorIcons add;
		label: 'Add a new default session';
		aptitude: BrGlamorousButtonWithIconAptitude;
		addAptitude: ((BrGlamorousWithDropdownAptitude 
			handle:[ 
				BrButton new
					icon: BrGlamorousVectorIcons add;
					aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude ]
			content: [
				| connectorsList |
				connectorsList := self createConnectorList.
				connectorsList padding: (BlInsets left: 10 right: 10).
				connectorsList items: (self registry connectors
					sorted: #name ascending) ] )
			preferredExtent: 380 @250).
	
	^ selectionButton
]

{ #category : #'private - children' }
GtGemStoneSessionsCardWidget >> createConnectorList [
	| newList |
	newList := BrColumnedList new.
	newList 
		rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new);
		matchParent.

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
				| aWidgetElement selectedConnector newSession |
				aWidgetElement := anEvent currentTarget.
				selectedConnector := aWidgetElement viewModel
					itemAt: theIndices first.
				newSession := self registry 
					newSessionReusesOrDefaultWithConnector: selectedConnector.
				newSession beDefaultSession.
				self updateContent.
				
				self selectSession: newSession.
				
				anEvent target fireEvent: BrDropdownHideWish new] ].

	newList addAptitude: BrColumnedListHeaderAptitude.

	^ newList
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> createInspectButton [

	^ BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude new;
			icon: BrGlamorousVectorIcons inspect;
			action: [ :aButton | self inspectRegistryFrom: aButton ];
			yourself.
]

{ #category : #'private - children' }
GtGemStoneSessionsCardWidget >> createList [
	| newList |

	newList := BrColumnedList new.
	
	newList column
		title: 'Name';
		width: 130;
		cellStencil: [ 
			GtPhlowLabelWithIcon new
				withSmallSize ];
		dataBinder: [ :anElement :aSession | 
			anElement 
				initializeWithIcon: (self 
					iconForSymbol: aSession iconName)
				label: (aSession formatBasedOnStatusText: aSession displayName) ].
			
	newList column
		title: 'Status';
		width: 125;
		cellStencil:[ 
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vFitContent ];
		dataBinder: [ :aLabel :aSession |
			aLabel text: (aSession formatBasedOnStatusText: aSession statusDescription) ].
	
	newList column
		title: 'Default';
		width: 50;
		stencil: [ :aSession |
			aSession isDefaultSession
				ifTrue: [ self activeMark ]
				ifFalse: [ BlElement new size: 0@0 ] ].
				
	newList
		when: BrSelectionDoubleClicked
		do: [ :anEvent | self doDoubleClicked: anEvent ].
	newList
		when: BrSelectionChanged 
		do: [ :anEvent | self doSelectionChanged: anEvent ].
	
	newList
		rowStencil: (BrColumnedListItemElementWithContextMenuDecorator new
			stencilBuilder: BrGlamorousColumnedListSelectableRowElementStencilBuilder new;
			contextMenuStencil: [ :anElement :aSession | 
				self sessionActionsFor: aSession ] );
		padding: (BlInsets top: 5);
		matchParent.
	
	newList addAptitude: BrColumnedListHeaderAptitude.
	
	^ newList.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> createRefreshButton [

	^ BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude new;
			icon: BrGlamorousVectorIcons refresh;
			action: [ :aButton | self updateContent ];
			yourself.
]

{ #category : #'private - children' }
GtGemStoneSessionsCardWidget >> createTitleLabel [

	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new;
		hMatchParent;
		vFitContent;
		text: 'GemStone Sessions' asRopedText bold.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> createToolbar [

	^ BrHorizontalPane new
		hMatchParent;
		vFitContent;
		layout: BlLinearLayout horizontal alignTopRight;
		addChild: self createTitleLabel;
		addChild: (self createAddNewDefaultSessionButton 
			margin: (BlInsets right: 5));
		addChild: (self createRefreshButton 
			margin: (BlInsets right: 5));
		addChild: self createInspectButton;
		yourself.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> doDoubleClicked: anEvent [ 
	| session |

	session := anEvent currentTarget items at: anEvent selection first.
	session class = GtGemStoneCardWidgetNoSessions ifTrue: [ ^ self ].

	self openPlaygroundOn: session
		from: anEvent currentTarget.
]

{ #category : #'private - children' }
GtGemStoneSessionsCardWidget >> doSelectionChanged: anEvent [ 
]

{ #category : #utils }
GtGemStoneSessionsCardWidget >> iconForSymbol: anIconName [ 
	
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

{ #category : #'initialization ' }
GtGemStoneSessionsCardWidget >> initialize [
	super initialize.
	
	self buildContent.
	self updateContent.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> inspectRegistryFrom: aButton [ 

	GtPager
		openWrappedOn: (GtInspector newOn: self registry)
		title: 'GemStone Registry'
		from: aButton.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> inspectSession: aSession from: anElement [

	GtPager
		openWrappedOn: (GtInspector newOn: aSession)
		title: aSession name
		from: anElement.
]

{ #category : #'private - hooks' }
GtGemStoneSessionsCardWidget >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	
	self updateContent
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> openPlaygroundOn: aSession from: anElement [
	| page |

	page := LePage unnamedPage.
	page addSnippet: (LeGemStoneSnippet new sessionName: aSession name).
	LeDatabasesRegistry default defaultLogicalDatabase playgroundDB addPage: page.
	GtWorldUtility
		showSpaceWithTitle: aSession name
		inPagerWith: [ page asLepiterPagePhlowTool asElementDo: [ :e | e ] ]
				asStencil
		from: anElement
]

{ #category : #accessing }
GtGemStoneSessionsCardWidget >> registry [

	^ registry ifNil: [ GtGemStoneSessionRegistry default ]
]

{ #category : #accessing }
GtGemStoneSessionsCardWidget >> registry: aGtGemStoneSessionRegistry [

	registry ifNotNil: [ registry unsubscribe: self ].
	registry := aGtGemStoneSessionRegistry.
	registry
		when: GtGemStoneSessionAnnouncement
		send: #updateContent
		to: self.
]

{ #category : #'actions - ui' }
GtGemStoneSessionsCardWidget >> selectSession: aSession [ 
	| sessionIndex |
	sessionIndex := sessionList items indexOf:  aSession.
	sessionIndex > 0 ifTrue: [
		sessionList selectOne: sessionIndex ].
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> sessionActionsFor: aGtGemStoneSession [
	| actions |
	
	aGtGemStoneSession class = GtGemStoneCardWidgetNoSessions
		ifTrue: [ ^ BrGlamorousSimpleContextMenuContent new].
	
	actions := OrderedCollection new.
	
	actions addAll: {
		'Playground' -> [ :aStatusLineElement | 
				self openPlaygroundOn: aGtGemStoneSession from: aStatusLineElement]}.
	
	aGtGemStoneSession isRunning 
		ifTrue: [
			actions addAll: {
				'Commit' -> [ :aStatusLineElement |
					aGtGemStoneSession commitTransaction.
					self updateContent].
				'Abort' -> [ :aStatusLineElement |
					aGtGemStoneSession abortTransaction.
					self updateContent].
				'Disconnect' -> [ :aStatusLineElement |
					| newDefaultSession |
					aGtGemStoneSession close.
					
					newDefaultSession := self registry ensureDefaultSession.
					
					self updateContent.
					newDefaultSession ifNotNil: [
						self selectSession: newDefaultSession ] ]} ]
		ifFalse: [
			actions addAll: {
				'Connect' -> [ :aStatusLineElement |
					aGtGemStoneSession connect.
					self updateContent] } ].
					
	aGtGemStoneSession isDefaultSession ifFalse: [
		actions addAll: {
			'Be Default' -> [ :aStatusLineElement |
				aGtGemStoneSession beDefaultSession.
				self updateContent]} ].
					
	actions addAll: {
		'Toggle AutoCommit' -> [:aStatusLineElement |
			aGtGemStoneSession toggleAutoCommit.
			self updateContent].
		'Toggle CodeSync' -> [:aStatusLineElement |
			aGtGemStoneSession toggleCodeSync.
			self updateContent].
		'Toggle CodeSync & AutoCommit' -> [:aStatusLineElement |
			aGtGemStoneSession toggleCodeSyncAndAutoCommit.
			self updateContent ].
		'Inspect' -> [:aStatusLineElement | 
			self inspectSession: aGtGemStoneSession from: aStatusLineElement]}.
				
	^ BrGlamorousSimpleContextMenuContent new 
		items: actions
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> updateContent [

	sessionList items: ((self registry activeSessions 
		sorted: #name ascending) ifEmpty:[ 
			{ GtGemStoneCardWidgetNoSessions new } ]).
]
