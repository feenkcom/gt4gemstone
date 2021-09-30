Class {
	#name : #GtGemStoneSessionManagerListSessionElement,
	#superclass : #BrHorizontalPane,
	#traits : 'TGtWithGemStoneSessionViewModel',
	#classTraits : 'TGtWithGemStoneSessionViewModel classTrait',
	#instVars : [
		'name',
		'username',
		'stoneName',
		'activated',
		'actions'
	],
	#category : 'GToolkit-GemStone-Pharo-UI'
}

{ #category : #initialization }
GtGemStoneSessionManagerListSessionElement >> initialize [
	super initialize.
	
	self addAptitude: BrGlamorousListItemAptitude.
	
	self hMatchParent.
	self vFitContent.
	self alignCenterLeft.
	
	self addAptitude:
		(BrGlamorousWithContextMenuAptitude
			content: [
				BrGlamorousSimpleContextMenuContent new
					items: (
				self gemStoneSessionViewModel allSessionActions
					collect: [ :eachAction | eachAction label -> [ :anElement | eachAction performActionOn: anElement ] ]) ]).

	self
		when: BlClickEvent
		do: [ :anEvent |
			anEvent consumed: true.
			anEvent currentTarget gemStoneSessionViewModel selectSessionWithoutOtherEntities ].

	self
		when: BlDoubleClickEvent
		do: [ :anEvent | 
			anEvent consumed: true.
			anEvent currentTarget phlow spawnObject: anEvent currentTarget gemStoneSessionViewModel gemStoneSession ].
	
	activated := BrGlamorousVectorIcons accept asElement background: self theme default primaryBorderColor.
	activated margin: (BlInsets left: 2).
	
	name := BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		hMatchParent.
		
	username := BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		hMatchParent.
		
	stoneName := BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		hMatchParent.

	actions := BrToolbar new
		aptitude: (BrGlamorousToolbarAptitude new spacing: 2);
		fitContent.

	self addAptitude: (BrStyleCommonAptitude new
		@ actions;
		default: [ :aStyle | aStyle visibility: BlVisibility hidden ];
		hovered: [ :aStyle | aStyle visibility: BlVisibility visible ]).

	self addChildren: { 
		activated.
		name.
		username.
		stoneName.
		actions
	}
]

{ #category : #'api - gem stone session view model' }
GtGemStoneSessionManagerListSessionElement >> onGemStoneSessionViewModelChanged [
	"Is sent when a new gemStoneSessionViewModel is assigned to the receiver.
	Note: #onGemStoneSessionViewModelChanged is sent before #subscribeToGemStoneSessionViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostGemStoneSessionViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
	
	name text: self gemStoneSessionViewModel name.
	username text: self gemStoneSessionViewModel username.
	stoneName text: self gemStoneSessionViewModel stoneName.

	self updateSelection.
	self updateActivation.
	self updateToolbar
]

{ #category : #'api - gem stone session view model' }
GtGemStoneSessionManagerListSessionElement >> subscribeToGemStoneSessionViewModel [
	"Is sent after a new gemStoneSessionViewModel is assigned to the receiver.
	It is required to unsubscribe from the previously subscribed objects by implementing
	#unsubscribeFromGemStoneSessionViewModel if the receiver subscribes to them"
	<modelSubscriber: #session>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#subscribeToObjectTemplate'>
	
	self gemStoneSessionViewModel
		when: GtGemStoneSessionViewModelSelected, GtGemStoneSessionViewModelDeselected
			send: #updateSelection
			to: self;
		when: GtGemStoneSessionViewModelActivated, GtGemStoneSessionViewModelDeactivated
			send: #updateActivation
			to: self
]

{ #category : #'api - gem stone session view model' }
GtGemStoneSessionManagerListSessionElement >> unsubscribeFromGemStoneSessionViewModel [
	"Is sent before a new gemStoneSessionViewModel is assigned to the receiver.
	Objects that subscribe to gemStoneSessionViewModel are required to implement this method."
	<modelUnsubscriber: #session>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#unsubscribeFromObjectTemplate'>
	
	self gemStoneSessionViewModel unsubscribe: self
]

{ #category : #'private - update' }
GtGemStoneSessionManagerListSessionElement >> updateActivation [
	self gemStoneSessionViewModel isActivatedSession
		ifTrue: [ activated visibility: BlVisibility visible ]
		ifFalse: [ activated visibility: BlVisibility hidden ]
]

{ #category : #'private - update' }
GtGemStoneSessionManagerListSessionElement >> updateSelection [
	self gemStoneSessionViewModel isSelectedSession
		ifTrue: [ self states addState: BlElementState selected ]
		ifFalse: [ self states removeState: BlElementState selected ]
]

{ #category : #'private - update' }
GtGemStoneSessionManagerListSessionElement >> updateToolbar [

	actions removeAllItems.

	self gemStoneSessionViewModel allSessionActions do: [ :eachAction |
		eachAction
			asElement: [ :anActionElement |
				anActionElement beTinySize.
				anActionElement aptitude: BrGlamorousButtonWithIconAptitude.
				anActionElement margin: (BlInsets empty).
				actions addItem: anActionElement ]
			withHostElement: self ]
]
