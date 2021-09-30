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
	| element |

	element := GtGemStoneSessionManagerWidget onRegistry: registry.
	element 
		addInspectButton;
		exact: extent.

	element gemStoneSessionManagerViewModel when: GtGemStoneSessionViewModelActivated  do: [ :anEvent |
		selectAction cull: anEvent gemStoneSessionViewModel gemStoneSession cull: element ].

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
