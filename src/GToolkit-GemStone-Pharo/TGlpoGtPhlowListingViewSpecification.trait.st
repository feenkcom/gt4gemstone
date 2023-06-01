Trait {
	#name : #TGlpoGtPhlowListingViewSpecification,
	#category : #'GToolkit-GemStone-Pharo-Stubs'
}

{ #category : #accessing }
TGlpoGtPhlowListingViewSpecification >> retrieveItems: anItemsCount fromIndex: anIndex [
	^ self
		proxyPerform: #retrieveItems:fromIndex:
		withArguments: { anItemsCount . anIndex  }
]

{ #category : #accessing }
TGlpoGtPhlowListingViewSpecification >> retrieveTotalItemsCount [
	^ self
		proxyPerform: #retrieveTotalItemsCount
]

{ #category : #accessing }
TGlpoGtPhlowListingViewSpecification >> retriveSentItemAt: aSelectionIndex [ 
	^ self
		proxyPerform: #retriveSentItemAt:
		withArguments: { aSelectionIndex }
]
