Class {
	#name : #GtGemStoneSessionManagerWidget,
	#superclass : #BrVerticalPane,
	#traits : 'TGtWithGemStoneSessionManagerViewModel',
	#classTraits : 'TGtWithGemStoneSessionManagerViewModel classTrait',
	#instVars : [
		'sessionList',
		'newSessionButton',
		'toolbar'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #'instance creation' }
GtGemStoneSessionManagerWidget class >> onRegistry: aGtGemStoneSessionRegistry [
	^ self new gemStoneSessionManagerViewModel: 
		(GtGemStoneSessionManagerViewModel new 
			gemStoneSessionRegistry: aGtGemStoneSessionRegistry)
]

{ #category : #configuration }
GtGemStoneSessionManagerWidget >> addInspectButton [
	"Add an 'Inspect' button to the toolbar allowing the receiver's GtGemStoneSessionRegistry to be edited"

	toolbar addChild: self createInspectButton.

]

{ #category : #private }
GtGemStoneSessionManagerWidget >> addNewConnector [

	gemStoneSessionManagerViewModel addNewConnector
]

{ #category : #configuration }
GtGemStoneSessionManagerWidget >> addNewSessionButton [
	"Add the 'New Session' button to the toolbar"

	newSessionButton ifNotNil: 
		[ self error: 'New Session button already exists' ].

	newSessionButton := self createNewSessionButton.
	toolbar addChild: newSessionButton
]

{ #category : #initialization }
GtGemStoneSessionManagerWidget >> createInspectButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Inspect session registry';
		beSmallSize;
		action: [ :theButton | theButton phlow spawnObject: self gemStoneSessionManagerViewModel gemStoneSessionRegistry ]
]

{ #category : #initialization }
GtGemStoneSessionManagerWidget >> createNewSessionButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
		icon: BrGlamorousVectorIcons add;
		label: 'New Session';
		fitContent;
		action: [ self addNewConnector ].

]

{ #category : #initialization }
GtGemStoneSessionManagerWidget >> createSessionList [
	| list headerPane |

	headerPane := BrHorizontalPane new
		margin: (BlInsets bottom: 5);
		hMatchParent;
		vFitContent;
		padding: (BlInsets left: 18 right: 64).

	{ 'Name' . 'Username' . 'Stone name' } do: [ :eachColumnName | 
			| label |
			label := BrLabel new
				aptitude: (BrGlamorousLabelAptitude new foreground: self theme button defaultTextColor);
				text: eachColumnName;
				hMatchParent.
			headerPane addChild: label ].

	list := BrSimpleList new.
	list 
		padding: (BlInsets top: 5);
		matchParent.

	list itemStencil: [ GtGemStoneSessionManagerListSessionElement new ].
	list itemDataBinder: [ :eachSessionElement :eachSessionViewModel | eachSessionElement gemStoneSessionViewModel: eachSessionViewModel ].

	list addChildFirst: headerPane.

	^ list
]

{ #category : #initialization }
GtGemStoneSessionManagerWidget >> createToolbar [
	| newToolbar |

	newToolbar := BrHorizontalPane new.
	newToolbar
		hMatchParent;
		vFitContent;
		alignCenterRight;
		padding: (BlInsets all: 5).

	^ newToolbar
]

{ #category : #initialization }
GtGemStoneSessionManagerWidget >> initialize [ 
	super initialize.

	self matchParent.
	
	sessionList := self createSessionList.
	toolbar := self createToolbar.

	self addChild: sessionList as: #sessionList.
	self addChild: toolbar as: #toolbar
]

{ #category : #'api - gem stone session manager view model' }
GtGemStoneSessionManagerWidget >> onGemStoneSessionManagerViewModelChanged [
	"Is sent when a new gemStoneSessionManagerViewModel is assigned to the receiver.
	Note: #onGemStoneSessionManagerViewModelChanged is sent before #subscribeToGemStoneSessionManagerViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostGemStoneSessionManagerViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
	
	self updateSessionList
]

{ #category : #accessing }
GtGemStoneSessionManagerWidget >> sessionList [

	^ sessionList
]

{ #category : #'api - gem stone session manager view model' }
GtGemStoneSessionManagerWidget >> subscribeToGemStoneSessionManagerViewModel [
	"Is sent after a new gemStoneSessionManagerViewModel is assigned to the receiver.
	It is required to unsubscribe from the previously subscribed objects by implementing
	#unsubscribeFromGemStoneSessionManagerViewModel if the receiver subscribes to them"
	<modelSubscriber: #sessionManager>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#subscribeToObjectTemplate'>
	
	self gemStoneSessionManagerViewModel gemStoneSessionRegistry
		when: GtGemStoneConnectorAnnouncement
		send: #updateSessionList
		to: self
]

{ #category : #accessing }
GtGemStoneSessionManagerWidget >> toolbar [

	^ toolbar
]

{ #category : #'api - gem stone session manager view model' }
GtGemStoneSessionManagerWidget >> unsubscribeFromGemStoneSessionManagerViewModel [
	"Is sent before a new gemStoneSessionManagerViewModel is assigned to the receiver.
	Objects that subscribe to gemStoneSessionManagerViewModel are required to implement this method."
	<modelUnsubscriber: #sessionManager>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#unsubscribeFromObjectTemplate'>
	
	self gemStoneSessionManagerViewModel gemStoneSessionRegistry unsubscribe: self
]

{ #category : #private }
GtGemStoneSessionManagerWidget >> updateSessionList [

	sessionList items: (self gemStoneSessionManagerViewModel gemStoneSessionsViewModel gemStoneSessionViewModels
		sorted: [ :a :b | a name < b name ])
]
