Class {
	#name : 'GtGemStoneSessionManagerWidget',
	#superclass : 'BrVerticalPane',
	#instVars : [
		'sessionList',
		'newSessionButton',
		'sessionRegistryModel',
		'toolbar'
	],
	#category : 'GToolkit-GemStone-Pharo-UI'
}

{ #category : 'instance creation' }
GtGemStoneSessionManagerWidget class >> onRegistry: aGtGemStoneSessionRegistry [

	^ self new sessionRegistryModel: 
		(GtGemStoneSessionManagerViewModel new 
			sessionRegistry: aGtGemStoneSessionRegistry)
]

{ #category : 'private' }
GtGemStoneSessionManagerWidget >> addNewConnector [

	sessionRegistryModel addNewConnector
]

{ #category : 'initialization' }
GtGemStoneSessionManagerWidget >> buildUI [ 

	sessionList := self createSessionList.
	toolbar := self createToolbar.

	self matchParent.
	self addChild: sessionList as: #sessionList.
	self addChild: toolbar as: #toolbar.
]

{ #category : 'initialization' }
GtGemStoneSessionManagerWidget >> createNewSessionButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
		icon: BrGlamorousVectorIcons add;
		label: 'New Session';
		fitContent;
		action: [ self addNewConnector ].

]

{ #category : 'initialization' }
GtGemStoneSessionManagerWidget >> createSessionList [
	| list |

	list := BrColumnedList new.
	list 
		rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new);
		padding: (BlInsets top: 5);
		matchParent.

	list column
		title: 'Name';
		width: 100;
		cellStencil: [ :each | BrLabel new aptitude: BrGlamorousLabelAptitude new ];
		dataBinder: [ :aLabel :eachItem |
			aLabel text: eachItem name ].

	list column
		title: 'User';
		width: 100;
		cellStencil: [ :each | BrLabel new aptitude: BrGlamorousLabelAptitude new ];
		dataBinder: [ :aLabel :eachItem |
			aLabel text: eachItem username ].

	list column
		title: 'Stone';
		cellStencil: [ :each | BrLabel new aptitude: BrGlamorousLabelAptitude new ];
		dataBinder: [ :aLabel :eachItem |
			aLabel text: eachItem stone ].

	list
		when: BrSelectionDoubleClicked
		do: [ :anEvent | 
			anEvent selection ifNotEmpty: [ :theIndices | 
				| connector selectedObject |
				anEvent target selectedItemDo: [ :item | connector := item ].
				self assert: connector isNotNil.
				selectedObject := sessionRegistryModel sessionNamed: connector name.
				self phlow spawnObject: selectedObject ] ].
	list addAptitude: BrColumnedListHeaderAptitude.
	^ list
]

{ #category : 'initialization' }
GtGemStoneSessionManagerWidget >> createToolbar [
	| toolbar |

	toolbar := BrHorizontalPane new.
	toolbar
		hMatchParent;
		vFitContent;
		alignCenterRight.

	newSessionButton := self createNewSessionButton.
	toolbar addChild: newSessionButton.

	^ toolbar
]

{ #category : 'initialization' }
GtGemStoneSessionManagerWidget >> initialize [ 

	super initialize.
	self buildUI.

]

{ #category : 'hooks - children' }
GtGemStoneSessionManagerWidget >> onAddedToSceneGraph [ 

	super onAddedToSceneGraph.
	sessionRegistryModel ifNotNil:
		[ self subscribeToSessionRegistryModel ].
]

{ #category : 'hooks - children' }
GtGemStoneSessionManagerWidget >> onRemovedFromSceneGraph [ 

	super onRemovedFromSceneGraph.
	sessionRegistryModel ifNotNil:
		[ self unsubscribeFrom: sessionRegistryModel ].
]

{ #category : 'private' }
GtGemStoneSessionManagerWidget >> onSessionManagerViewModelChanged [

	self updateSessionList.
	self subscribeToSessionRegistryModel.

]

{ #category : 'enumerating' }
GtGemStoneSessionManagerWidget >> selectedSessionDo: aBlock [
	"Evaluate the supplied block with the selected session and index.
	Does nothing if there is no selection."

	sessionList selectedItemDo: aBlock
]

{ #category : 'accessing' }
GtGemStoneSessionManagerWidget >> sessionList [

	^ sessionList
]

{ #category : 'accessing' }
GtGemStoneSessionManagerWidget >> sessionRegistryModel [

	^ sessionRegistryModel
]

{ #category : 'accessing' }
GtGemStoneSessionManagerWidget >> sessionRegistryModel: aGtGemStoneSessionManagerViewModel [

	sessionRegistryModel ifNotNil:
		[ self unsubscribeFrom: sessionRegistryModel ].
	sessionRegistryModel := aGtGemStoneSessionManagerViewModel.
	self onSessionManagerViewModelChanged.
]

{ #category : 'private' }
GtGemStoneSessionManagerWidget >> subscribeToSessionRegistryModel [

	sessionRegistryModel
		when: GtGemStoneConnectorAnnouncement
		send: #updateSessionList
		to: self
]

{ #category : 'accessing' }
GtGemStoneSessionManagerWidget >> toolbar [

	^ toolbar
]

{ #category : 'private' }
GtGemStoneSessionManagerWidget >> unsubscribeFrom: aGtGemStoneSessionRegistryModel [

	aGtGemStoneSessionRegistryModel sessionRegistry unsubscribe: self
]

{ #category : 'private' }
GtGemStoneSessionManagerWidget >> updateSessionList [

	sessionList items: (sessionRegistryModel allConnectors
		sorted: [ :a :b | a name < b name ]).

]
