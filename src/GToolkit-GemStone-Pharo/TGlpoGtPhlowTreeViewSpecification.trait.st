Trait {
	#name : #TGlpoGtPhlowTreeViewSpecification,
	#category : #'GToolkit-GemStone-Pharo-Stubs'
}

{ #category : #accessing }
TGlpoGtPhlowTreeViewSpecification >> flushItemsIterator [
	^ self
		proxyPerform: #flushItemsIterator
]

{ #category : #accessing }
TGlpoGtPhlowTreeViewSpecification >> retrieveChildrenForNodeAtPath: aNodePath [
	^ self
		proxyPerform: #retrieveChildrenForNodeAtPath:
		withArguments: { aNodePath }
]

{ #category : #accessing }
TGlpoGtPhlowTreeViewSpecification >> retrieveSentItemAtPath: aNodePath [
	^ self
		proxyPerform: #retrieveSentItemAtPath:
		withArguments: { aNodePath }
]

{ #category : #accessing }
TGlpoGtPhlowTreeViewSpecification >> retriveSentItemAtPath: aNodePath [
	^ self
		proxyPerformReturnProxy: #retriveSentItemAtPath:
		withArguments: { aNodePath }
]
