Class {
	#name : #GtGemStoneSessionSelectionStencil,
	#superclass : #BrStencil,
	#instVars : [
		'extent',
		'registry',
		'selectAction',
		'currentSessionNameComputation',
		'currentSessionDisplayLabelComputation'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #'api - instantiation' }
GtGemStoneSessionSelectionStencil >> create [ 
	"Create a new session selection button with dropdown selection"
	^ GtGemStoneSessionSelectionBadgeElement new
		registry: registry;
		selectAction: selectAction;
		currentSessionNameComputation: currentSessionNameComputation;
		currentSessionDisplayLabelComputation: currentSessionDisplayLabelComputation
]

{ #category : #accessing }
GtGemStoneSessionSelectionStencil >> currentSessionDisplayLabelComputation [
	^ currentSessionDisplayLabelComputation
]

{ #category : #accessing }
GtGemStoneSessionSelectionStencil >> currentSessionDisplayLabelComputation: anObject [
	currentSessionDisplayLabelComputation := anObject
]

{ #category : #accessing }
GtGemStoneSessionSelectionStencil >> currentSessionNameComputation: aBlock [
	currentSessionNameComputation := aBlock
]

{ #category : #accessing }
GtGemStoneSessionSelectionStencil >> registry [

	^ registry
]

{ #category : #accessing }
GtGemStoneSessionSelectionStencil >> registry: aRegistry [

	registry := aRegistry
]

{ #category : #accessing }
GtGemStoneSessionSelectionStencil >> selectAction [

	^ selectAction
]

{ #category : #accessing }
GtGemStoneSessionSelectionStencil >> selectAction: anObject [

	selectAction := anObject
]
