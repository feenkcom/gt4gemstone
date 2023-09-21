Trait {
	#name : #TGlpoGtPhlowListingViewSpecification,
	#category : #'GToolkit-GemStone-Pharo-Stubs'
}

{ #category : #accessing }
TGlpoGtPhlowListingViewSpecification >> flushItemsIterator [
	^ self
		proxyPerform: #flushItemsIterator
]

{ #category : #accessing }
TGlpoGtPhlowListingViewSpecification >> retrieveItems: anItemsCount fromIndex: anIndex [
	^ self
		proxyPerform: #retrieveItems:fromIndex:
		withArguments: { anItemsCount . anIndex  }
]

{ #category : #accessing }
TGlpoGtPhlowListingViewSpecification >> retrieveSentItemAt: aSelectionIndex [ 
	^ self
		proxyPerformReturnProxy: #retrieveSentItemAt:
		withArguments: { aSelectionIndex }
]

{ #category : #accessing }
TGlpoGtPhlowListingViewSpecification >> retrieveTotalItemsCount [
	^ self
		proxyPerform: #retrieveTotalItemsCount
]

{ #category : #accessing }
TGlpoGtPhlowListingViewSpecification >> retriveSentItemAt: aSelectionIndex [ 
	^ self
		proxyPerformReturnProxy: #retriveSentItemAt:
		withArguments: { aSelectionIndex }
]
