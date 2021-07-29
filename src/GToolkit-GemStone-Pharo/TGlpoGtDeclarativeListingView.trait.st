Trait {
	#name : 'TGlpoGtDeclarativeListingView',
	#category : 'GToolkit-GemStone-Pharo-Stubs'
}

{ #category : 'accessing' }
TGlpoGtDeclarativeListingView >> retrieveItems: anItemsCount fromIndex: anIndex [
	^ self
		proxyPerform: #retrieveItems:fromIndex:
		withArguments: { anItemsCount . anIndex  }
]

{ #category : 'accessing' }
TGlpoGtDeclarativeListingView >> retrieveTotalItemsCount [
	^ self
		proxyPerform: #retrieveTotalItemsCount
]

{ #category : 'accessing' }
TGlpoGtDeclarativeListingView >> retriveSentItemAt: aSelectionIndex [ 
	^ self
		proxyPerform: #retriveSentItemAt:
		withArguments: { aSelectionIndex }
]
