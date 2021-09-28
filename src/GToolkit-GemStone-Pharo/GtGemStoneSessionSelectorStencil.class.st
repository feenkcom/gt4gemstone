Class {
	#name : 'GtGemStoneSessionSelectorStencil',
	#superclass : 'BrStencil',
	#instVars : [
		'registry',
		'selectAction',
		'extent'
	],
	#category : 'GToolkit-GemStone-Pharo-UI'
}

{ #category : 'api - instantiation' }
GtGemStoneSessionSelectorStencil >> create [ 
	| element sessionList toolbar selectSessionButton |

	element := GtGemStoneSessionManagerWidget onRegistry: registry.
	element 
		addInspectButton;
		padding: (BlInsets all: 10);
		exact: extent.

	sessionList := element sessionList.
	toolbar := element toolbar.
	selectSessionButton := BrButton new
		aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
		icon: BrGlamorousVectorIcons accept;
		label: 'Select';
		margin: (BlInsets left: 5);
		fitContent;
		disable;
		action: 
			[ sessionList selectedItemDo: [ :session | 
				selectAction cull: session cull: selectSessionButton ] ].
	toolbar addChild: selectSessionButton.
	sessionList 
		when: BrSelectionChanged 
		do: [ selectSessionButton enable ].
	^ element
]

{ #category : 'accessing' }
GtGemStoneSessionSelectorStencil >> extent [

	^ extent
]

{ #category : 'accessing' }
GtGemStoneSessionSelectorStencil >> extent: anObject [

	extent := anObject
]

{ #category : 'accessing' }
GtGemStoneSessionSelectorStencil >> registry [

	^ registry
]

{ #category : 'accessing' }
GtGemStoneSessionSelectorStencil >> registry: anObject [

	registry := anObject
]

{ #category : 'accessing' }
GtGemStoneSessionSelectorStencil >> selectAction [

	^ selectAction
]

{ #category : 'accessing' }
GtGemStoneSessionSelectorStencil >> selectAction: anObject [

	selectAction := anObject
]
