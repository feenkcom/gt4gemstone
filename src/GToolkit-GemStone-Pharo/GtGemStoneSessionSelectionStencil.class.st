Class {
	#name : #GtGemStoneSessionSelectionStencil,
	#superclass : #BrStencil,
	#instVars : [
		'tooltip',
		'extent',
		'registry',
		'selectAction'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #'api - instantiation' }
GtGemStoneSessionSelectionStencil >> create [ 
	"Create a new session selection button with dropdown selection"
	| selectionButton |

	selectionButton := BrButton new.
	selectionButton 
		label: tooltip;
		aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
		addAptitude: (BrGlamorousWithDropdownAptitude 
			handle:
				[ BrButton new
					label: tooltip;
					aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
					beSmallSize;
					fitContent ]
			content: 
				[
				| aSelectionElement |
				
				aSelectionElement := GtGemStoneSessionManagerWidget onRegistry: registry.
				aSelectionElement 
					addInspectButton;
					exact: extent.

				aSelectionElement gemStoneSessionManagerViewModel
					when: GtGemStoneSessionViewModelActivated
					do: [ :anEvent |
						selectAction
							cull: anEvent gemStoneSessionViewModel gemStoneSession
							cull: selectionButton ].

				aSelectionElement
					when: GtPhlowObjectToSpawn
					do: [ :anEvent | selectionButton fireEvent: anEvent ].
				aSelectionElement ] );
		beSmallSize;
		fitContent.
	^ selectionButton
]

{ #category : #initialization }
GtGemStoneSessionSelectionStencil >> initialize [ 

	super initialize.
	tooltip := 'Select Session'.
	extent := 400 @ 300.
]

{ #category : #accessing }
GtGemStoneSessionSelectionStencil >> registry [

	^ registry
]

{ #category : #accessing }
GtGemStoneSessionSelectionStencil >> registry: anObject [

	registry := anObject
]

{ #category : #accessing }
GtGemStoneSessionSelectionStencil >> selectAction [

	^ selectAction
]

{ #category : #accessing }
GtGemStoneSessionSelectionStencil >> selectAction: anObject [

	selectAction := anObject
]
