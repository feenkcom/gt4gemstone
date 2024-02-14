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
TGlpoGtPhlowListingViewSpecification >> retrieveFormattedItems [
	"This method does not use pagination. Should only be used in examples"
	
	^ (self performEvaluation
		selector: #retrieveFormattedItems;
		returnLegacy;
		evaluate) wait
]

{ #category : #accessing }
TGlpoGtPhlowListingViewSpecification >> retrieveItems: anItemsCount fromIndex: anIndex [

	^ (self performEvaluation
		selector: #retrieveItems:fromIndex:;
		arguments: { anItemsCount . anIndex  };
		returnLegacy;
		evaluate) wait
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

	^ (self performEvaluation
		selector: #retriveSentItemAt:;
		arguments: { aSelectionIndex };
		returnProxy;
		evaluate) wait
]
