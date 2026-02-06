Class {
	#name : #GtGemStoneSessionsCardWidget,
	#superclass : #BrVerticalPane,
	#instVars : [
		'registry',
		'sessionList',
		'elementUpdater'
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

{ #category : #callbacks }
GtGemStoneSessionsCardWidget >> actOnGemStoneSessionAnnouncement [
	self requestContentUpdate
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

{ #category : #actions }
GtGemStoneSessionsCardWidget >> addSessionForConnector: aGemStoneConnector [ 
	| newSession |
	newSession := self registry 
		newConnectedDefaultSessionWithReusageWithConnector: aGemStoneConnector.
	
	self updateContent.
	self selectSession: newSession.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> buildContent [
	self
		addChild: (sessionList := self createListWithItems) as: #sessionList;
		addChild: self createToolbar.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> createAddNewDefaultSessionButton [
	| selectionButton |
	
	selectionButton := BrButton new.
	selectionButton 
		icon: BrGlamorousVectorIcons add;
		label: 'Add a new default session';
		id: GtGemStoneSessionsCardWidgetAddSessionButtonId;
		aptitude: BrGlamorousButtonWithIconAptitude;
		addAptitude: (BrGlamorousWithExplicitDropdownAptitude 
			handle:[ 
				BrButton new
					icon: BrGlamorousVectorIcons add;
					aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude ]
			content: [
				 (self createConnectorsSelectionWidget)
				 	hExact: 580 ] ).
	
	^ selectionButton
]

{ #category : #'private - children' }
GtGemStoneSessionsCardWidget >> createConnectorsSelectionWidget [
	^ GtGemStoneConnectorsWidget new
		sessionsRegistry:  self registry;
		actionCallback: [ :aGemStoneConnector |
			self addSessionForConnector: aGemStoneConnector ]
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> createInspectButton [

	^ BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude new;
			icon: BrGlamorousVectorIcons inspect;
			id: GtGemStoneSessionsCardWidgetInspectButtonId ;
			label: 'Inspect registry';
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
			self createStatusLabel ];
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
		rowStencil: self createRowStencil;
		padding: (BlInsets top: 5);
		matchParent.
	
	newList addAptitude: BrColumnedListHeaderAptitude.
	
	^ newList.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> createListWithItems [
	| newList |
	newList := self createList.
	newList items: self sessionsToDisplay.
	^ newList
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> createRefreshButton [

	^ BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude new;
			icon: BrGlamorousVectorIcons refresh;
			id: GtGemStoneSessionsCardWidgetRefreshButtonId;
			label: 'Refresh sessions list';
			action: [ :aButton | self requestContentUpdate ];
			yourself.
]

{ #category : #'private - children' }
GtGemStoneSessionsCardWidget >> createRowStencil [
	^ BrColumnedListItemElementWithContextMenuDecorator new
		stencilBuilder: BrGlamorousColumnedListSelectableRowElementStencilBuilder new;
		contextMenuStencil: [ :anElement :aSession | 
			self sessionActionsFor: aSession ] 
]

{ #category : #'private - children' }
GtGemStoneSessionsCardWidget >> createStatusLabel [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new;
		hMatchParent;
		vFitContent
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
	session isDefaultSession ifFalse: [ 
		self informCannotOpenSnippetOnNonDefaultSession.
		^ self  ].

	self 
		openPlaygroundWithDefaultSessionIdentifierNamed: session name
		from: anEvent currentTarget.
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

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> informCannotOpenSnippetOnNonDefaultSession [
	self
		showNotification: (GtNotificationMessage
				message: 'Cannot create a GemStone snippet on a session that is not default using double click. Make the session default, or create an explicit GemStone snippet.')
				showNotifications
]

{ #category : #'initialization ' }
GtGemStoneSessionsCardWidget >> initialize [
	super initialize.
	
	self buildContent.
	elementUpdater := BrElementUpdater new 
		element: self
		selector: #updateContent.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> inspectRegistryFrom: aButton [
	BlSpace new
		inPager: (GtInspectorTool forObject: self registry);
		title: 'GemStone Registry';
		showFrom: aButton
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> inspectSession: aSession from: anElement [
	BlSpace new
		inPager: (GtInspectorTool forObject: aSession);
		title: aSession name;
		showFrom: anElement
]

{ #category : #'private - hooks' }
GtGemStoneSessionsCardWidget >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	
	self requestContentUpdate
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> openPlaygroundOnSessionNamed: aSessionName withSnippet: aGemStoneSnippet from: anElement [
	| page |
	page := LePage unnamedPage.
	page addSnippet: aGemStoneSnippet.
	LeDatabasesRegistry default defaultLogicalDatabase playgroundDB addPage: page.
	
	BlSpace new
		title: aSessionName;
		inPager: [ 
			page asLepiterPagePhlowTool 
				asElementDo: [ :e | e ] ] asStencil;
		withSceneDriller;
		showFrom: anElement
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> openPlaygroundWithDefaultSessionIdentifierNamed: aSessionName from: anElement [
	^ self 
		openPlaygroundOnSessionNamed: aSessionName
		withSnippet: LeGemStoneSnippet withDefaultSessionIdentifier 
		from: anElement
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> openPlaygroundWithExplicitSessionIdentifierNamed: aSessionName from: anElement [
	^ self 
		openPlaygroundOnSessionNamed: aSessionName
		withSnippet: (LeGemStoneSnippet sessionName: aSessionName)
		from: anElement
]

{ #category : #accessing }
GtGemStoneSessionsCardWidget >> registry [
	^ registry ifNil: [ 
		"Initialize the registry with the default one"
		self registry: GtGemStoneSessionRegistry default.
		registry ]
]

{ #category : #accessing }
GtGemStoneSessionsCardWidget >> registry: aGtGemStoneSessionRegistry [

	registry ifNotNil: [ registry unsubscribe: self ].
	registry := aGtGemStoneSessionRegistry.
	registry announcer weak
		when: GtGemStoneSessionAnnouncement
		send: #actOnGemStoneSessionAnnouncement
		to: self.
]

{ #category : #updating }
GtGemStoneSessionsCardWidget >> requestContentUpdate [
	elementUpdater ifNil: [ ^ self ].
	elementUpdater requestUpdate
]

{ #category : #'actions - ui' }
GtGemStoneSessionsCardWidget >> selectSession: aSession [ 
	| sessionIndex |
	sessionIndex := self sessionList items indexOf:  aSession.
	sessionIndex > 0 ifTrue: [
		self sessionList selectOne: sessionIndex ].
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> sessionActionsFor: aGtGemStoneSession [
	| actions |
	
	aGtGemStoneSession class = GtGemStoneCardWidgetNoSessions
		ifTrue: [ ^ BrGlamorousSimpleContextMenuContent new].
	
	actions := OrderedCollection new.
	
	aGtGemStoneSession isDefaultSession 
		ifTrue: [
			actions addAll: {'Playground (default snippet)' -> [ :aStatusLineElement | 
				self 
					openPlaygroundWithDefaultSessionIdentifierNamed: aGtGemStoneSession name
					from: aStatusLineElement ]} ].
	actions addAll: {
		'Playground (explicit snippet)' -> [ :aStatusLineElement | 
				self 
					openPlaygroundWithExplicitSessionIdentifierNamed: aGtGemStoneSession name
					from: aStatusLineElement]}.
	
	aGtGemStoneSession isRunning 
		ifTrue: [
			actions addAll: {
				'Commit' -> [ :aStatusLineElement |
					aGtGemStoneSession commitTransactionWithErrorChecking.
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
					
	aGtGemStoneSession isDefaultSession 
		ifFalse: [
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
			self updateContent ]}.
	
	"aGtGemStoneSession currentFeatures hasGemStoneTranscriptV1 ifTrue: [ 
		actions addAll: {
			'Toggle Transcript' -> [:aStatusLineElement | 
				aGtGemStoneSession toggleRemoteTranscript ]} ]."
			
	actions addAll: {
		'Inspect' -> [:aStatusLineElement | 
			self inspectSession: aGtGemStoneSession from: aStatusLineElement]}.
				
	^ BrGlamorousSimpleContextMenuContent new 
		items: actions
]

{ #category : #accessing }
GtGemStoneSessionsCardWidget >> sessionList [
	^self 
		childNamed: #sessionList    
		ifFound: [ :anElement | anElement ] 
		ifNone: [ nil ]
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> sessionsToDisplay [
	^ ((self registry sessionsToDisplay 
		sorted: #name ascending) ifEmpty:[ 
			{ GtGemStoneCardWidgetNoSessions new } ])
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> updateContent [
	| selectedSession currentSessionList |
	
	currentSessionList := self sessionList.
	currentSessionList ifNil: [ ^self ].
	
	selectedSession := currentSessionList selectedItems
		ifEmpty: [ nil ] 
		ifNotEmpty: [ :aList | aList first ].
		
	self 
		replaceChild: currentSessionList
		with: self createListWithItems
		as: #sessionList.
		
	selectedSession ifNotNil: [
		self selectSession: selectedSession ]
]
