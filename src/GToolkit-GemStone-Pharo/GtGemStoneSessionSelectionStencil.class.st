Class {
	#name : #GtGemStoneSessionSelectionStencil,
	#superclass : #BrStencil,
	#instVars : [
		'tooltip',
		'extent',
		'registry',
		'selectAction',
		'currentSessionNameComputation'
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
					label: ('GemStone ({1})' format: { currentSessionNameComputation value });
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

				aSelectionElement
					when: GtPhlowObjectToSpawn
					do: [ :anEvent | selectionButton fireEvent: anEvent ].
				aSelectionElement ] );
		beSmallSize;
		fitContent.
	^ selectionButton
]

{ #category : #accessing }
GtGemStoneSessionSelectionStencil >> currentSessionNameComputation: aBlock [
	currentSessionNameComputation := aBlock
]

{ #category : #initialization }
GtGemStoneSessionSelectionStencil >> initialize [ 

	super initialize.
	tooltip := 'Select Session'.
	extent := 400 @ 200.
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
