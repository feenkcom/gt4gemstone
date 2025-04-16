Class {
	#name : #GtGemStoneSessionSelectionBadgeElement,
	#superclass : #BrFrame,
	#instVars : [
		'selectionButton',
		'currentSessionNameComputation',
		'registry',
		'selectAction',
		'extent',
		'currentSessionDisplayLabelComputation'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> currentSessionDisplayLabelComputation [
	^ currentSessionDisplayLabelComputation
]

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> currentSessionDisplayLabelComputation: anObject [
	currentSessionDisplayLabelComputation := anObject
]

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> currentSessionNameComputation [
	^ currentSessionNameComputation
]

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> currentSessionNameComputation: anObject [
	currentSessionNameComputation := anObject
]

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> initialize [
	super initialize.
	
	self fitContent.
	
	extent := 400 @200.
	
	selectionButton := BrButton new.
	selectionButton 
		label: 'Select Session';
		aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
		addAptitude: (BrGlamorousWithExplicitDropdownAptitude
			handle:
				[ BrButton new
					label: currentSessionDisplayLabelComputation value;
					aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
					beSmallSize;
					fitContent ]
			content: [ | aSelectionElement |
				aSelectionElement := GtGemStoneSessionSelectionElement new
					registry: registry;
					selectAction: [ :aSession |
						selectAction
							cull: aSession
							cull: selectionButton ];
					currentSessionNameComputation: currentSessionNameComputation;
					exact: extent.

				aSelectionElement addAptitude: BrGlamorousPopoverResizableAptitude new.
					
				aSelectionElement
					when: GtPhlowObjectToSpawn
					do: [ :anEvent | selectionButton phlow spawnPreviousEvent: anEvent ].
				aSelectionElement ]);
		beSmallSize;
		fitContent.
		
	self addChild: selectionButton
]

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> label [
	^ selectionButton label
]

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> label: aString [
	selectionButton label: aString
]

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> registry [
	^ registry
]

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> registry: aRegistry [
	registry := aRegistry
]

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> selectAction [
	^ selectAction
]

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> selectAction: anObject [
	selectAction := anObject
]

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> selectionButton [
	^ selectionButton
]

{ #category : #accessing }
GtGemStoneSessionSelectionBadgeElement >> selectionButton: anObject [
	selectionButton := anObject
]
