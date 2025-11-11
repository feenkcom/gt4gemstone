Class {
	#name : #GtGemStoneKeepAliveNotificationElement,
	#superclass : #GtNotificationEventElement,
	#instVars : [
		'nameLabel',
		'borderElement',
		'updater',
		'statesPane',
		'sessionList'
	],
	#category : #'GToolkit-GemStone-Pharo-Notifications'
}

{ #category : #accessing }
GtGemStoneKeepAliveNotificationElement >> actOnElementDetached [
	super actOnElementDetached.
	self clearContent.
]

{ #category : #'private - accessing' }
GtGemStoneKeepAliveNotificationElement >> activeMark [

	^ BlElement new
		layout: BlLinearLayout horizontal alignCenter;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		addChild: (BrGlamorousVectorIcons accept asElement)
]

{ #category : #'private - accessing' }
GtGemStoneKeepAliveNotificationElement >> borderElement [
	<return: #GtNotificationBorderElement>
	^ borderElement
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
		rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new);
		padding: (BlInsets top: 5);
		matchParent.
	newList column
		title: 'Name';
		width: 100;
		cellStencil:
			[ BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vFitContent ];
		dataBinder: [ :aLabel :aSession |
			aLabel parent addAptitude: 
				(BrGlamorousWithExplicitContextMenuAptitude 
					itemsWithAnchorActions: [ aSession contextMenuContent ]).
			aLabel text: (aSession formatBasedOnStatusText: aSession name)].

	newList column
		title: 'Default';
		width: 50;
		stencil: [ :aSession |
			aSession isDefaultSession
				ifTrue: [ self activeMark ]
				ifFalse: [ BlElement new size: 0@0 ] ].
	
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
	| infoButton |
	
	infoButton := BrButton new
			beTinySize;
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: 'Inspect KeepAlive';
			icon: BrGlamorousVectorIcons inspect;
			margin: (BlInsets top: 2 left: 10);
			action: [ self inspectRegistry ].


	^ { infoButton }
]

{ #category : #'private - hooks' }
GtGemStoneKeepAliveNotificationElement >> clearContent [

	sessionList items: #().
]

{ #category : #initialization }
GtGemStoneKeepAliveNotificationElement >> defaultLayout [
	^ BlLinearLayout vertical alignCenterRight
]

{ #category : #initialization }
GtGemStoneKeepAliveNotificationElement >> initialize [
	| namePane toolbarPane |

	super initialize.
	
	self initializeBorderElement.
	namePane := self buildNameLabel.
	nameLabel text: 'GemStone Dirty Sessions'.
	sessionList := self buildSessionList.
	toolbarPane := self buildToolbar.
	
	self addChild: self borderElement as: #border.
	self borderElement containerDo: [ :aContainer |
		aContainer 
			addChild: namePane;
			addChild: sessionList;
			addChild: toolbarPane ].
	
	self addAptitude: (BrLayoutResizerAptitude new
		hInherit;
		vAnyToFitContent;
		hInherit: self borderElement;
		vAnyToFitContent: self borderElement;
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
GtGemStoneKeepAliveNotificationElement >> inspectRegistry [
	"Inspect the receiver's job in a new tab in GtWorld"
	
	self notificationDo: [ :aNotification |
		GtInspectorTool
			openWrappedOn: aNotification registry
			title: 'Session Registry' 
			from: self ]
]

{ #category : #accessing }
GtGemStoneKeepAliveNotificationElement >> keepAlive [

	^ notification registry keepAlive
]

{ #category : #accessing }
GtGemStoneKeepAliveNotificationElement >> onAddedToSceneGraph [

	super onAddedToSceneGraph.
	self requestUpdate.
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

{ #category : #'private - updating' }
GtGemStoneKeepAliveNotificationElement >> requestUpdate [
	updater requestUpdate
]

{ #category : #subscriptions }
GtGemStoneKeepAliveNotificationElement >> subscribeToNotification [
	"Subscribe for updates, which actually come from the registgry keepalive, not the notification itself"

	self notificationDo: [ :aNotification | 
		aNotification registry keepAlive
			when: GtGemStoneKeepAlivePollCompletedSignal
			send: #onNotificationDataChangedFor: 
			to: self ]
]

{ #category : #'private - subscriptions' }
GtGemStoneKeepAliveNotificationElement >> unsubscribeFromNotification [
	self notificationDo: [ :aNotification | 
		aNotification registry keepAlive unsubscribe: self ]	
]

{ #category : #'private - updating' }
GtGemStoneKeepAliveNotificationElement >> updateContent [
	"Update the label and the states."

	self updateSessions.
]

{ #category : #'private - updating' }
GtGemStoneKeepAliveNotificationElement >> updateSessions [
	| dirtySessions |

	dirtySessions := self keepAlive dirtySessions.
	sessionList items: dirtySessions.
	dirtySessions ifEmpty: [ notification requestRemoval ].
]
