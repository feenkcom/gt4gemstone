Class {
	#name : #GtGemStoneKeepAliveNotificationElement,
	#superclass : #GtNotificationEventElement,
	#instVars : [
		'nameLabel',
		'borderElement',
		'updater',
		'statesPane',
		'sessionList',
		'descriptionEditor'
	],
	#category : #'GToolkit-GemStone-Pharo-Notifications'
}

{ #category : #accessing }
GtGemStoneKeepAliveNotificationElement >> actOnElementDetached [
	super actOnElementDetached.
	self clearContent.
]

{ #category : #'private - accessing' }
GtGemStoneKeepAliveNotificationElement >> borderElement [
	<return: #GtNotificationBorderElement>
	^ borderElement
]

{ #category : #initialization }
GtGemStoneKeepAliveNotificationElement >> buildDescriptionEditor [

	^ BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude;
		hMatchParent;
		vFitContent;
		beReadOnlyWithSelection;
		text: ''

]

{ #category : #initialization }
GtGemStoneKeepAliveNotificationElement >> buildNameLabel [
	| horizontalPane |

	horizontalPane := BrHorizontalPane new
			margin: (BlInsets bottom: 3);
			hMatchParent;
			vFitContent.
	nameLabel := BrLabel new
			aptitude: (BrGlamorousLabelAptitude new 
				foreground: BrGlamorousColors disabledHeaderTextColor);
			fitContent.
	horizontalPane
		addChild: (BlElement new size: 10@10);
		addChild: nameLabel.
	^ horizontalPane
]

{ #category : #initialization }
GtGemStoneKeepAliveNotificationElement >> buildSessionList [
	| newList |

	newList := BrColumnedList new.
	newList
		rowStencil: (BrGlamorousColumnedListItemElementWithContextMenuDecorator new
			contextMenuStencil: [ :anItemElement :aSession :anItemIndex :anItemType |
				self contextMenuFor: aSession ];
			stencilBuilder: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new
				cellSpacing: BrColumn defaultCellSpacing));
		padding: (BlInsets top: 5);
		matchParent.
	newList rowDataBinder: [ :aRowElement :aSession |
		GtGemStoneLogoutPendingRowAptitude bindRow: aRowElement toSession: aSession ].
	newList column
		title: 'Name';
		width: 100;
		cellStencil:
			[ BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vFitContent ];
		dataBinder: [ :aLabel :aSession |
			aLabel text: (aSession formatBasedOnStatusText: aSession name)].

	newList column
		title: 'Status';
		matchParent;
		stencil: [ :aSession |
			self labelWithText: aSession keepAlive notificationStateDescription ].

	newList addAptitude: BrColumnedListHeaderAptitude.
	^ newList.

]

{ #category : #initialization }
GtGemStoneKeepAliveNotificationElement >> buildToolbar [
	| horizontalPane  toolbarButtons |
	
	horizontalPane := BrHorizontalPane new
			hMatchParent;
			vFitContent;
			alignCenterRight.
			
	toolbarButtons := self buildToolbarButtons.
	
	horizontalPane
		addChildren: toolbarButtons.
	^ horizontalPane
]

{ #category : #initialization }
GtGemStoneKeepAliveNotificationElement >> buildToolbarButtons [
	| infoButton documentationButton |

	infoButton := BrButton new
		beTinySize;
		aptitude: BrGlamorousButtonWithIconAptitude;
		label: 'Inspect KeepAlive';
		icon: BrGlamorousVectorIcons inspect;
		margin: (BlInsets top: 2 left: 10);
		action: [ self inspectKeepAlive ].

	documentationButton := BrButton new
		beTinySize;
		aptitude: BrGlamorousButtonWithIconAptitude;
		label: 'Keep alive documentation';
		icon: BrGlamorousVectorIcons help;
		margin: (BlInsets top: 2 left: 5);
		action: [ self inspectDocumentation ].

	^ Array with: infoButton with: documentationButton

]

{ #category : #'private - hooks' }
GtGemStoneKeepAliveNotificationElement >> clearContent [

	sessionList items: #().
]

{ #category : #private }
GtGemStoneKeepAliveNotificationElement >> contextMenuContentFor: aSession [
	| items |

	items := OrderedCollection withAll: aSession contextMenuContent.
	aSession keepAlive canPostponeAutoLogout ifTrue: [
		items add: aSession keepAlive postponeLogoutLabel -> [ :anElement |
			self postponeAutoLogoutOf: aSession ] ].
	(aSession keepAlive isScheduledForAutoLogout and: [ aSession isBusy not ]) ifTrue: [
		items add: 'Logout now' -> [ :anElement |
			self logoutSessionNow: aSession ] ].
	^ items asArray

]

{ #category : #private }
GtGemStoneKeepAliveNotificationElement >> contextMenuFor: aSession [
	| menuItems |

	menuItems := BrMenuItems new.
	(self contextMenuContentFor: aSession) do: [ :each |
		menuItems
			addItemLabel: each key
			action: [ :anElement :aButtonModel :anEvent |
				each value cull: anElement anchor ] ].
	^ menuItems

]

{ #category : #initialization }
GtGemStoneKeepAliveNotificationElement >> defaultLayout [
	^ BlLinearLayout vertical alignCenterRight
]

{ #category : #'private - accessing' }
GtGemStoneKeepAliveNotificationElement >> descriptionEditor [

	^ descriptionEditor

]

{ #category : #initialization }
GtGemStoneKeepAliveNotificationElement >> initialize [
	| namePane toolbarPane |

	super initialize.

	self initializeBorderElement.
	namePane := self buildNameLabel.
	nameLabel text: 'GemStone Sessions'.
	descriptionEditor := self buildDescriptionEditor.
	sessionList := self buildSessionList.
	toolbarPane := self buildToolbar.

	self addChild: self borderElement as: #border.
	self borderElement containerDo: [ :aContainer |
		aContainer
			addChild: namePane;
			addChild: descriptionEditor;
			addChild: sessionList;
			addChild: toolbarPane ].

	self addAptitude: (BrLayoutResizerAptitude new
		hInherit;
		vAnyToFitContent;
		hInherit: self borderElement;
		vAnyToFitContent: self borderElement;
		hInherit: descriptionEditor;
		vAnyToFitContent: descriptionEditor;
		hInherit: sessionList;
		vAnyToFitContent: sessionList).

	updater := BrElementUpdater new
		element: self
		selector: #updateContent.
	updater postponedDuration: 1 seconds.

]

{ #category : #initialization }
GtGemStoneKeepAliveNotificationElement >> initializeBorderElement [
	borderElement := GtNotificationBorderElement new
		withCloseButtonAction: [ self dismiss ]
]

{ #category : #private }
GtGemStoneKeepAliveNotificationElement >> inspectDocumentation [

	self notificationDo: [ :aNotification | | reference |
		reference := aNotification documentationPage.
		reference
			pageFor: self
			ifFound: [ :aPage | self phlow spawnObject: aPage ]
			ifNone: [ self phlow spawnObject: reference ] ]

]

{ #category : #private }
GtGemStoneKeepAliveNotificationElement >> inspectKeepAlive [

	self notificationDo: [ :aNotification |
		GtInspectorTool
			openWrappedOn: aNotification keepAlive
			title: 'GemStone Keep Alive'
			from: self ]

]

{ #category : #accessing }
GtGemStoneKeepAliveNotificationElement >> keepAlive [

	^ notification keepAlive

]

{ #category : #'private - accessing' }
GtGemStoneKeepAliveNotificationElement >> labelWithText: aString [

	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new;
		text: aString;
		hMatchParent;
		vFitContent

]

{ #category : #private }
GtGemStoneKeepAliveNotificationElement >> logoutSessionNow: aSession [

	self notificationDo: [ :aNotification |
		aNotification logoutSessionNow: aSession ]

]

{ #category : #accessing }
GtGemStoneKeepAliveNotificationElement >> onAddedToSceneGraph [

	super onAddedToSceneGraph.
	self updateContent.
]

{ #category : #'private - hooks' }
GtGemStoneKeepAliveNotificationElement >> onNotificationChanged [

	self clearContent.
	self requestUpdate
]

{ #category : #'private - hooks' }
GtGemStoneKeepAliveNotificationElement >> onNotificationDataChangedFor: anAnnouncement [
	self requestUpdate
]

{ #category : #private }
GtGemStoneKeepAliveNotificationElement >> postponeAutoLogoutOf: aSession [

	self notificationDo: [ :aNotification |
		aNotification postponeAutoLogoutOf: aSession ]

]

{ #category : #'private - updating' }
GtGemStoneKeepAliveNotificationElement >> requestUpdate [
	updater requestUpdate
]

{ #category : #'private - accessing' }
GtGemStoneKeepAliveNotificationElement >> sessionList [

	^ sessionList

]

{ #category : #subscriptions }
GtGemStoneKeepAliveNotificationElement >> subscribeToNotification [

	self notificationDo: [ :aNotification |
		aNotification weak
			when: GtNotificationDataChangedAnnouncement
			send: #onNotificationDataChangedFor:
			to: self ]

]

{ #category : #'private - subscriptions' }
GtGemStoneKeepAliveNotificationElement >> unsubscribeFromNotification [

	self notificationDo: [ :aNotification |
		aNotification unsubscribe: self ]

]

{ #category : #'private - updating' }
GtGemStoneKeepAliveNotificationElement >> updateContent [
	"Update the label and the states."

	self updateSessions.
]

{ #category : #'private - updating' }
GtGemStoneKeepAliveNotificationElement >> updateDescription [

	self notificationDo: [ :aNotification |
		descriptionEditor text: aNotification descriptionText ]

]

{ #category : #'private - updating' }
GtGemStoneKeepAliveNotificationElement >> updateSessions [
	| sessions |

	sessions := self notification
		ifNil: [ #() ]
		ifNotNil: [ :aNotification | aNotification sessions ].
	sessionList items: sessions.
	self updateDescription.
	sessions ifEmpty: [
		self notificationDo: [ :aNotification | aNotification requestRemoval ] ].

]
